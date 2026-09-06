extends Control

@onready var week_label: Label = %WeekLabel
@onready var league_label: Label = %LeagueLabel
@onready var public_bar: ProgressBar = %PublicBar
@onready var federation_bar: ProgressBar = %FederationBar
@onready var energy_bar: ProgressBar = %EnergyBar
@onready var suspicion_bar: ProgressBar = %SuspicionBar
@onready var clean_money_label: Label = %CleanMoneyLabel
@onready var dirty_money_label: Label = %DirtyMoneyLabel
@onready var summary_label: Label = %SummaryLabel
@onready var investigation_label: Label = %InvestigationLabel
@onready var play_button: Button = %PlayButton
@onready var training_button: Button = %TrainingButton
@onready var social_button: Button = %SocialButton
@onready var shop_button: Button = %ShopButton
@onready var career_button: Button = %CareerButton

func _ready() -> void:
	GameManager.stats_changed.connect(_refresh)
	GameManager.game_over.connect(_on_game_over)
	play_button.pressed.connect(_on_play_pressed)
	training_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/training.tscn"))
	social_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/social.tscn"))
	shop_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/shop.tscn"))
	career_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/career.tscn"))
	_show_summary()
	_refresh()

func _refresh() -> void:
	var s := GameManager.stats
	week_label.text = "Hafta %d" % s.week
	league_label.text = s.league_name()
	public_bar.value = s.public_rel
	federation_bar.value = s.federation_rel
	energy_bar.value = s.energy
	suspicion_bar.value = s.suspicion
	clean_money_label.text = "Temiz: %d TL" % s.clean_money
	dirty_money_label.text = "Kirli: %d TL" % s.dirty_money
	play_button.disabled = s.energy < 15.0
	play_button.text = "Maçı Oyna" if s.energy >= 15.0 else "Dinlenmen Lazım"
	investigation_label.visible = s.under_investigation
	if s.under_investigation:
		investigation_label.text = "⚠ SORUŞTURMA ALTINDASIN (Kanıt: %.0f)" % s.evidence_score

func _show_summary() -> void:
	var event_msg: String = GameManager.last_event_message
	if not event_msg.is_empty():
		summary_label.text = event_msg
		GameManager.last_event_message = ""
		return

	var sum := GameManager.last_match_summary
	if sum.is_empty():
		summary_label.text = "Yeni bir hakemlik kariyerine hoş geldin."
	else:
		summary_label.text = "Son maç: %d pozisyon, gözlemci notu %.1f, +%d TL maaş." % [
			sum.get("positions_played", 0), sum.get("observer_score", 0.0), sum.get("wage", 0)
		]

func _on_play_pressed() -> void:
	GameManager.start_assignment()

func _on_game_over(reason: String) -> void:
	pass # ending.tscn ekranı devralır
