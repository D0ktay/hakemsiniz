extends Node
## Oyun durumunun tek kaynağı: statlar, hafta ilerlemesi, kayıt/yükleme.

signal stats_changed
signal week_advanced
signal game_over(reason: String)

const SAVE_PATH := "user://savegame.tres"

var stats: RefereeStats
var pending_offer: Dictionary = {}
var current_match_importance: float = 1.0
var last_match_summary: Dictionary = {}

func _ready() -> void:
	if not load_game():
		new_game()

func new_game() -> void:
	stats = RefereeStats.new()
	pending_offer = {}
	last_match_summary = {}
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

## Yeni bir haftalık atama başlatır: önem derecesini belirler ve teklif olup olmadığına bakar.
func start_assignment() -> void:
	current_match_importance = randf_range(0.6, 1.4)
	if randf() < 0.35 and randi() % 3 == 0:
		current_match_importance *= 2.5 # derbi / kritik maç

	pending_offer = OfferSystem.maybe_generate_offer(stats, current_match_importance)
	if not pending_offer.is_empty():
		get_tree().change_scene_to_file("res://scenes/offer.tscn")
	else:
		_begin_match()

func resolve_offer(choice: String) -> void:
	OfferSystem.apply_choice(stats, pending_offer, choice)
	pending_offer = {}
	stats_changed.emit()
	_begin_match()

func _begin_match() -> void:
	MatchManager.start_match(stats, current_match_importance)
	get_tree().change_scene_to_file("res://scenes/match.tscn")

func finish_week(summary: Dictionary) -> void:
	last_match_summary = summary
	stats.clamp_all()
	week_advanced.emit()
	save_game()

	if stats.suspicion >= 100.0:
		game_over.emit("yakalandin")
	elif stats.public_rel <= 0.0:
		game_over.emit("trajik_son")
	elif stats.federation_rel <= 0.0 and stats.league_tier <= 0:
		game_over.emit("surgun")
