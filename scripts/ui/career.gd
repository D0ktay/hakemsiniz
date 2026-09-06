extends Control

@onready var league_label: Label = %LeagueLabel
@onready var stats_label: Label = %StatsLabel
@onready var blockers_label: Label = %BlockersLabel
@onready var promote_button: Button = %PromoteButton
@onready var result_label: Label = %ResultLabel
@onready var retire_button: Button = %RetireButton
@onready var back_button: Button = %BackButton

func _ready() -> void:
	promote_button.pressed.connect(_on_promote)
	retire_button.pressed.connect(func(): GameManager.retire())
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/hub.tscn"))
	_refresh()

func _refresh() -> void:
	var s := GameManager.stats
	league_label.text = "%s (Yıl %d, Yaş %d)" % [s.league_name(), s.current_year(), s.age]
	stats_label.text = "Bu seviyede %d maç oynadın, ortalama gözlemci notu: %.2f" % [
		s.matches_played, CareerSystem.average_score(s)
	]

	var blockers: Array[String] = CareerSystem.promotion_blockers(s)
	blockers_label.text = "\n".join(blockers) if not blockers.is_empty() else "Terfi için hazırsın!"
	promote_button.disabled = not CareerSystem.can_attempt_promotion(s)

func _on_promote() -> void:
	var s := GameManager.stats
	var result := CareerSystem.attempt_promotion(s)
	result_label.text = result.get("reason", "")
	GameManager.stats.clamp_all()
	GameManager.stats_changed.emit()
	GameManager.save_game()
	_refresh()
