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
@onready var play_button: Button = %PlayButton

func _ready() -> void:
	GameManager.stats_changed.connect(_refresh)
	GameManager.game_over.connect(_on_game_over)
	play_button.pressed.connect(_on_play_pressed)
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

func _show_summary() -> void:
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
	summary_label.text = "KARİYER SONA ERDİ: %s" % reason
	play_button.disabled = true
