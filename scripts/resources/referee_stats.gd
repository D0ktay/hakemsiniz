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

## Ekonomi (iki cüzdan)
@export var clean_money := 5000
@export var dirty_money := 0

## Kariyer
@export var league_tier := 0
@export var age := 22
@export var week := 1
@export var career_score := 0

const LEAGUE_NAMES := ["Aday Hakem", "İl Hakemi", "Bölgesel Hakem", "3. Lig", "2. Lig", "1. Lig", "Süper Lig", "FIFA Kokartlı"]

func league_name() -> String:
	return LEAGUE_NAMES[clampi(league_tier, 0, LEAGUE_NAMES.size() - 1)]

func clamp_all() -> void:
	public_rel = clampf(public_rel, 0.0, 100.0)
	federation_rel = clampf(federation_rel, 0.0, 100.0)
	suspicion = clampf(suspicion, 0.0, 100.0)
	energy = clampf(energy, 0.0, 100.0)
	family_rel = clampf(family_rel, 0.0, 100.0)
