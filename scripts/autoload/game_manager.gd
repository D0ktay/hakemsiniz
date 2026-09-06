extends Node
## Oyun durumunun tek kaynağı: statlar, haftalık akış, kayıt/yükleme.

signal stats_changed
signal week_advanced
signal game_over(reason: String)

const SAVE_PATH := "user://savegame.tres"

var stats: RefereeStats
var pending_offer: Dictionary = {}
var pending_threat: Dictionary = {}
var current_match_importance: float = 1.0
var last_match_summary: Dictionary = {}
var last_event_message: String = ""
var last_ending_reason: String = ""

func _ready() -> void:
	if not load_game():
		new_game()

func new_game() -> void:
	stats = RefereeStats.new()
	pending_offer = {}
	pending_threat = {}
	last_match_summary = {}
	last_event_message = ""
	stats_changed.emit()

func save_game() -> void:
	ResourceSaver.save(stats, SAVE_PATH)

func load_game() -> bool:
	if ResourceLoader.exists(SAVE_PATH):
		var loaded: Resource = ResourceLoader.load(SAVE_PATH)
		if loaded is RefereeStats:
			stats = loaded
			stats_changed.emit()
			return true
	return false

func has_save() -> bool:
	return ResourceLoader.exists(SAVE_PATH)

## Yeni bir haftalık atama başlatır: önem derecesini belirler, önce tehdit sonra teklif kontrolü yapar.
func start_assignment() -> void:
	current_match_importance = randf_range(0.6, 1.4)
	if randi() % 3 == 0:
		current_match_importance *= 2.5 # derbi / kritik maç

	pending_threat = ThreatSystem.maybe_generate_threat(stats, current_match_importance)
	if not pending_threat.is_empty():
		get_tree().change_scene_to_file("res://scenes/threat.tscn")
		return

	_check_offer()

func _check_offer() -> void:
	pending_offer = OfferSystem.maybe_generate_offer(stats, current_match_importance)
	if not pending_offer.is_empty():
		get_tree().change_scene_to_file("res://scenes/offer.tscn")
	else:
		_begin_match()

func resolve_threat(choice: String) -> void:
	last_event_message = ThreatSystem.apply_choice(stats, pending_threat, choice)
	pending_threat = {}
	stats_changed.emit()
	_check_offer()

func resolve_offer(choice: String) -> void:
	last_event_message = OfferSystem.apply_choice(stats, pending_offer, choice)
	pending_offer = {}
	stats_changed.emit()
	_begin_match()

func _begin_match() -> void:
	MatchManager.start_match(stats, current_match_importance)
	get_tree().change_scene_to_file("res://scenes/match.tscn")

func finish_week(summary: Dictionary) -> void:
	last_match_summary = summary
	stats.matches_played += 1
	stats.career_score += float(summary.get("observer_score", 0.0))

	EconomySystem.process_weekly(stats)
	stats.clamp_all()

	if stats.family_rel <= 5.0 and not stats.family_crisis_happened:
		stats.family_crisis_happened = true
		stats.clean_money = maxi(0, stats.clean_money - 5000)
		stats.energy = maxf(10.0, stats.energy - 20.0)
		last_event_message = "Ailen boşanma sürecine girdi: avukat masrafı 5000 TL, moralin çöktü."

	if stats.suspicion >= 70.0:
		stats.under_investigation = true
	elif stats.suspicion < 40.0:
		stats.under_investigation = false

	week_advanced.emit()
	save_game()

	if stats.under_investigation and stats.evidence_score >= 60.0:
		_trigger_ending("yakalandin")
	elif stats.public_rel <= 0.0:
		_trigger_ending("trajik_son")
	elif stats.federation_rel <= 0.0 and stats.league_tier <= 0:
		_trigger_ending("surgun")

func retire() -> void:
	_trigger_ending(CareerSystem.determine_retirement_ending(stats))

func _trigger_ending(reason: String) -> void:
	last_ending_reason = reason
	game_over.emit(reason)
	if ResourceLoader.exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	get_tree().change_scene_to_file("res://scenes/ending.tscn")
