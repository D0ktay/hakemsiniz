extends Control
## Maç akışı + GDD §5.3'teki tam 5 adımlı VAR incelemesi:
## 1) Sinyal  2) Donmuş kare + scrub  3) Çizgi overlay (ofsayt)  4) Açı/zoom  5) Karar.

@onready var minute_label: Label = %MinuteLabel
@onready var description_label: Label = %DescriptionLabel
@onready var decision_true_button: Button = %DecisionTrueButton
@onready var decision_false_button: Button = %DecisionFalseButton
@onready var result_label: Label = %ResultLabel
@onready var next_button: Button = %NextButton
@onready var finish_panel: PanelContainer = %FinishPanel
@onready var finish_label: Label = %FinishLabel
@onready var continue_button: Button = %ContinueButton
@onready var decision_box: HBoxContainer = %DecisionBox

@onready var var_panel: PanelContainer = %VarPanel
@onready var var_step_label: Label = %VarStepLabel
@onready var var_info_label: Label = %VarInfoLabel
@onready var var_signal_button: Button = %VarSignalButton
@onready var var_scrub_slider: HSlider = %VarScrubSlider
@onready var var_scrub_continue: Button = %VarScrubContinue
@onready var var_line_button: Button = %VarLineButton
@onready var var_angle_button: Button = %VarAngleButton
@onready var var_angle_continue: Button = %VarAngleContinue
@onready var var_change_button: Button = %VarChangeButton
@onready var var_keep_button: Button = %VarKeepButton

var _current_position: Dictionary
var _pending_decision: bool = false

# VAR oturum durumu
var _var_confidence: float = 0.0
var _var_critical_point: float = 50.0
var _var_angle_tries: int = 0

func _ready() -> void:
	decision_true_button.pressed.connect(func(): _on_decision(true))
	decision_false_button.pressed.connect(func(): _on_decision(false))
	next_button.pressed.connect(_show_next_position)
	continue_button.pressed.connect(_on_continue_pressed)

	var_signal_button.pressed.connect(_var_go_to_scrub)
	var_scrub_slider.value_changed.connect(_on_scrub_changed)
	var_scrub_continue.pressed.connect(_var_go_to_line_or_angle)
	var_line_button.pressed.connect(_on_line_drawn)
	var_angle_button.pressed.connect(_on_angle_tried)
	var_angle_continue.pressed.connect(_var_go_to_decision)
	var_change_button.pressed.connect(func(): _on_var_resolved(true))
	var_keep_button.pressed.connect(func(): _on_var_resolved(false))

	_show_next_position()

func _show_next_position() -> void:
	result_label.text = ""
	next_button.visible = false
	var_panel.visible = false
	decision_box.visible = true

	if not MatchManager.has_current():
		_finish_match()
		return

	_current_position = MatchManager.get_current()
	var type: String = _current_position.type
	minute_label.text = "%d. dakika" % _current_position.minute

	var stats := GameManager.stats
	var ratio: float = MatchManager.compute_vision_ratio(stats, _current_position)
	var shown_accurately: bool = randf() < ratio
	var truth: bool = _current_position.ground_truth
	var shown_truth: bool = truth if shown_accurately else not truth

	description_label.text = MatchManager.DESCRIPTIONS[type][shown_truth]
	if not shown_accurately:
		description_label.text += "\n(Açı kötü, emin olamıyorsun...)"
	_current_position["_seen_ratio"] = ratio

	var labels: Dictionary = MatchManager.DECISION_LABELS[type]
	decision_true_button.text = labels["true"]
	decision_false_button.text = labels["false"]

func _on_decision(decision: bool) -> void:
	_pending_decision = decision
	decision_box.visible = false

	if MatchManager.should_trigger_var(_current_position):
		_var_start()
	else:
		_apply_decision(decision)

## ---- VAR akışı ----

func _var_start() -> void:
	_var_confidence = float(_current_position.get("_seen_ratio", 0.5))
	_var_critical_point = randf_range(30.0, 70.0)
	_var_angle_tries = 0
	var_panel.visible = true
	_var_show_signal()

func _var_show_signal() -> void:
	var_step_label.text = "ADIM 1/4 - SİNYAL"
	var_info_label.text = "VAR odası telsizle uyarıyor: 'Kontrol et, kontrol et!' Monitöre yürüyorsun."
	_set_var_step_visibility("signal")

func _var_go_to_scrub() -> void:
	var_step_label.text = "ADIM 2/4 - DONMUŞ KARE"
	var_scrub_slider.value = 0
	var_info_label.text = "Görüntüyü kaydırarak kritik kareyi bul."
	_set_var_step_visibility("scrub")

func _on_scrub_changed(value: float) -> void:
	var distance: float = absf(value - _var_critical_point)
	if distance < 8.0:
		_var_confidence = maxf(_var_confidence, 0.9)
		var_info_label.text = "KRİTİK KARE BULUNDU:\n%s" % MatchManager.DESCRIPTIONS[_current_position.type][_current_position.ground_truth]
	else:
		var_info_label.text = "Görüntü bulanık, kritik kareye yaklaşmıyorsun... (%.0f%%)" % (100.0 - distance)

func _var_go_to_line_or_angle() -> void:
	if _current_position.type == "ofsayt":
		var_step_label.text = "ADIM 3/4 - ÇİZGİ OVERLAY"
		var_info_label.text = "Yarı otomatik ofsayt çizgisini çizmek için dokun."
		_set_var_step_visibility("line")
	else:
		_var_go_to_angle()

func _on_line_drawn() -> void:
	_var_confidence = 1.0
	var truth: bool = _current_position.ground_truth
	var_info_label.text = "ÇİZGİ NET: %s" % MatchManager.DESCRIPTIONS[_current_position.type][truth]
	_var_go_to_angle()

func _var_go_to_angle() -> void:
	var_step_label.text = "ADIM 4/4 - AÇI / ZOOM"
	var_info_label.text = "Farklı kamera açılarını dene."
	_set_var_step_visibility("angle")

func _on_angle_tried() -> void:
	_var_angle_tries += 1
	var stats := GameManager.stats
	var reveal_chance: float = clampf(stats.vision / 99.0 + 0.2 * _var_angle_tries, 0.1, 0.95)
	if randf() < reveal_chance:
		_var_confidence = maxf(_var_confidence, 0.85)
		var truth: bool = _current_position.ground_truth
		var_info_label.text = "NET GÖRÜNÜYOR (Açı %d): %s" % [_var_angle_tries, MatchManager.DESCRIPTIONS[_current_position.type][truth]]
	else:
		var_info_label.text = "Bu açıda da emin olamadın. (Açı %d)" % _var_angle_tries

func _var_go_to_decision() -> void:
	var_step_label.text = "KARAR"
	if _var_confidence >= 0.6:
		var truth: bool = _current_position.ground_truth
		var_info_label.text = "Elindeki bilgiler net: %s" % MatchManager.DESCRIPTIONS[_current_position.type][truth]
	else:
		var_info_label.text = "Hâlâ emin değilsin. Vicdanınla karar ver."
	_set_var_step_visibility("decision")

func _set_var_step_visibility(step: String) -> void:
	var_signal_button.visible = step == "signal"
	var_scrub_slider.visible = step == "scrub"
	var_scrub_continue.visible = step == "scrub"
	var_line_button.visible = step == "line"
	var_angle_button.visible = step == "angle"
	var_angle_continue.visible = step == "angle"
	var_change_button.visible = step == "decision"
	var_keep_button.visible = step == "decision"

func _on_var_resolved(change: bool) -> void:
	var_panel.visible = false
	var final_decision: bool = (not _pending_decision) if change else _pending_decision
	_apply_decision(final_decision)

## ---- Sonuç ----

func _apply_decision(decision: bool) -> void:
	var correct: bool = MatchManager.resolve_decision(GameManager.stats, _current_position, decision)
	result_label.text = "DOĞRU KARAR" if correct else "YANLIŞ KARAR"
	result_label.modulate = Color.LIME_GREEN if correct else Color.INDIAN_RED
	MatchManager.advance()
	next_button.visible = true

func _finish_match() -> void:
	decision_box.visible = false
	next_button.visible = false
	var summary := MatchManager.finish_match(GameManager.stats)
	finish_label.text = "Maç bitti.\nGözlemci notu: %.1f\nMaaş: +%d TL" % [
		summary.get("observer_score", 0.0), summary.get("wage", 0)
	]
	finish_panel.visible = true
	GameManager.finish_week(summary)

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hub.tscn")
