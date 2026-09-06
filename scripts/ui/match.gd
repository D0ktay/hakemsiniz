extends Control

@onready var minute_label: Label = %MinuteLabel
@onready var description_label: Label = %DescriptionLabel
@onready var decision_true_button: Button = %DecisionTrueButton
@onready var decision_false_button: Button = %DecisionFalseButton
@onready var var_panel: PanelContainer = %VarPanel
@onready var var_label: Label = %VarLabel
@onready var var_change_button: Button = %VarChangeButton
@onready var var_keep_button: Button = %VarKeepButton
@onready var result_label: Label = %ResultLabel
@onready var next_button: Button = %NextButton
@onready var finish_panel: PanelContainer = %FinishPanel
@onready var finish_label: Label = %FinishLabel
@onready var continue_button: Button = %ContinueButton
@onready var decision_box: HBoxContainer = %DecisionBox

var _current_position: Dictionary
var _pending_decision: bool = false

func _ready() -> void:
	decision_true_button.pressed.connect(func(): _on_decision(true))
	decision_false_button.pressed.connect(func(): _on_decision(false))
	var_change_button.pressed.connect(func(): _on_var_resolved(true))
	var_keep_button.pressed.connect(func(): _on_var_resolved(false))
	next_button.pressed.connect(_show_next_position)
	continue_button.pressed.connect(_on_continue_pressed)
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

	var labels: Dictionary = MatchManager.DECISION_LABELS[type]
	decision_true_button.text = labels["true"]
	decision_false_button.text = labels["false"]

func _on_decision(decision: bool) -> void:
	_pending_decision = decision
	decision_box.visible = false

	if MatchManager.should_trigger_var(_current_position):
		var truth: bool = _current_position.ground_truth
		var_label.text = "VAR incelemesi: yavaş çekimde net görünen durum - %s" % \
			MatchManager.DESCRIPTIONS[_current_position.type][truth]
		var_change_button.disabled = (decision == truth)
		var_panel.visible = true
	else:
		_apply_decision(decision)

func _on_var_resolved(change: bool) -> void:
	var_panel.visible = false
	var final_decision: bool = (not _pending_decision) if change else _pending_decision
	_apply_decision(final_decision)

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
