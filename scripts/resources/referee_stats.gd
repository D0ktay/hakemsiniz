class_name RefereeStats
extends Resource

## Saha statları (1-99)
@export var agility := 30.0
@export var stamina := 30.0
@export var concentration := 30.0
@export var vision := 30.0
@export var authority := 30.0
@export var composure := 30.0

## İlişki / durum statları (0-100)
@export var public_rel := 50.0
@export var federation_rel := 50.0
@export var suspicion := 0.0
@export var energy := 100.0
@export var family_rel := 60.0
@export var journalist_rel := 30.0
@export var friend_rel := 30.0

## Ekonomi (iki cüzdan)
@export var clean_money := 5000
@export var dirty_money := 0
## Aklanmayı bekleyen kirli para: [{amount:int, ready_week:int}]
@export var pending_laundering: Array = []

## Kariyer
@export var league_tier := 0
@export var age := 22
@export var week := 1
@export var career_score := 0.0
@export var matches_played := 0
@export var total_bribes_accepted := 0

## Soruşturma
@export var evidence_score := 0.0
@export var max_suspicion := 0.0
@export var under_investigation := false

## NPC hafızası: kaynak adı -> {"trust": float, "kin": float}
@export var npc_memory: Dictionary = {}

## Envanter/koruma
@export var has_lawyer_retainer := false
@export var protection_weeks := 0
@export var owns_house := false
@export var family_crisis_happened := false

const LEAGUE_NAMES := ["Aday Hakem", "İl Hakemi", "Bölgesel Hakem", "3. Lig", "2. Lig", "1. Lig", "Süper Lig", "FIFA Kokartlı"]
const WEEKS_PER_YEAR := 34

func league_name() -> String:
	return LEAGUE_NAMES[clampi(league_tier, 0, LEAGUE_NAMES.size() - 1)]

func is_top_tier() -> bool:
	return league_tier >= LEAGUE_NAMES.size() - 1

func current_year() -> int:
	return int(week / WEEKS_PER_YEAR) + 1

func get_npc(source: String) -> Dictionary:
	if not npc_memory.has(source):
		npc_memory[source] = {"trust": 20.0, "kin": 0.0}
	return npc_memory[source]

func adjust_npc(source: String, trust_delta: float, kin_delta: float) -> void:
	var npc: Dictionary = get_npc(source)
	npc.trust = clampf(npc.trust + trust_delta, 0.0, 100.0)
	npc.kin = clampf(npc.kin + kin_delta, 0.0, 100.0)
	npc_memory[source] = npc

func clamp_all() -> void:
	public_rel = clampf(public_rel, 0.0, 100.0)
	federation_rel = clampf(federation_rel, 0.0, 100.0)
	suspicion = clampf(suspicion, 0.0, 100.0)
	energy = clampf(energy, 0.0, 100.0)
	family_rel = clampf(family_rel, 0.0, 100.0)
	journalist_rel = clampf(journalist_rel, 0.0, 100.0)
	friend_rel = clampf(friend_rel, 0.0, 100.0)
	max_suspicion = maxf(max_suspicion, suspicion)
