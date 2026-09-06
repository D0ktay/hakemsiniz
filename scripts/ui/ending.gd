extends Control

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var score_label: Label = %ScoreLabel
@onready var new_game_button: Button = %NewGameButton

func _ready() -> void:
	var reason: String = GameManager.last_ending_reason
	title_label.text = CareerSystem.ENDING_TITLES.get(reason, "KARİYER SONA ERDİ")
	description_label.text = CareerSystem.ENDING_DESCRIPTIONS.get(reason, "")

	var s := GameManager.stats
	score_label.text = "%s | %d hafta | Halk %.0f | Federasyon %.0f | Temiz %d TL | Kirli %d TL" % [
		s.league_name(), s.week, s.public_rel, s.federation_rel, s.clean_money, s.dirty_money
	]

	new_game_button.pressed.connect(_on_new_game)

func _on_new_game() -> void:
	GameManager.new_game()
	get_tree().change_scene_to_file("res://scenes/hub.tscn")
