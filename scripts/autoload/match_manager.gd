extends Node
## Maç akışı: pozisyon üretimi, Görme Oranı formülü (§5.2), basit VAR (§5.3).

const DIFFICULTY := {"penalti": 0.10, "ofsayt": 0.20, "faul": 0.05}
const VAR_ELIGIBLE := ["penalti", "faul"]

const DESCRIPTIONS := {
	"penalti": {
		true: "Ceza sahasında hücum oyuncusuna sert bir müdahale oldu.",
		false: "Ceza sahasında temas çok hafif, oyuncu abartıyor olabilir.",
	},
	"ofsayt": {
		true: "Hücum oyuncusu pas anında rakip sahada en geride ikinci oyuncudan ileride.",
		false: "Hücum oyuncusu pas anında savunma hattıyla aynı hizada.",
	},
	"faul": {
		true: "Müdahale çok sert, oyuncunun sağlığını tehlikeye atıyor.",
		false: "Normal bir mücadele, aşırı sert değil.",
	},
}

const DECISION_LABELS := {
	"penalti": {"true": "Penaltı Ver", "false": "Penaltı Yok, Devam"},
	"ofsayt": {"true": "Ofsayt Ver", "false": "Oyunu Sürdür"},
	"faul": {"true": "Kart Göster", "false": "Devam Et"},
}

var positions: Array[Dictionary] = []
var current_index := 0
var observer_score := 0.0
var importance := 1.0

func start_match(_stats: RefereeStats, match_importance: float) -> void:
	positions.clear()
	current_index = 0
	observer_score = 0.0
	importance = match_importance

	var types := ["penalti", "ofsayt", "faul"]
	var count := randi_range(3, 6)
	var minute := 0
	for i in count:
		minute += int(90.0 / count)
		var type: String = types[randi() % types.size()]
		positions.append({
			"type": type,
			"minute": minute,
			"ground_truth": randf() < 0.5,
		})

func has_current() -> bool:
	return current_index < positions.size()

func get_current() -> Dictionary:
	return positions[current_index]

## §5.2 Görme Oranı formülü.
func compute_vision_ratio(stats: RefereeStats, position: Dictionary) -> float:
	var proximity: float = 1.0 if randf() < (stats.agility / 99.0) else 0.4
	var ratio := 0.50
	ratio += 0.30 * (stats.vision / 99.0)
	ratio += 0.15 * (stats.concentration / 99.0)
	ratio += 0.10 * (stats.agility / 99.0) * proximity
	ratio -= 0.20 * (1.0 - stats.energy / 100.0)
	ratio -= DIFFICULTY.get(position.type, 0.1)
	if position.minute > 75:
		ratio -= 0.10
	return clampf(ratio, 0.05, 0.98)

func should_trigger_var(position: Dictionary) -> bool:
	return VAR_ELIGIBLE.has(position.type) and randf() < 0.4

func resolve_decision(stats: RefereeStats, position: Dictionary, player_decision: bool) -> bool:
	var correct: bool = player_decision == position.ground_truth
	if correct:
		stats.public_rel += randf_range(2.0, 5.0)
		stats.federation_rel += randf_range(1.0, 3.0)
		observer_score += 1.0
	else:
		stats.public_rel -= randf_range(3.0, 8.0)
		stats.federation_rel -= randf_range(2.0, 5.0)
		observer_score -= 1.0
	stats.clamp_all()
	return correct

func advance() -> void:
	current_index += 1

func finish_match(stats: RefereeStats) -> Dictionary:
	stats.energy -= randf_range(20.0, 35.0)
	var wage := 500 * (stats.league_tier + 1)
	stats.clean_money += wage
	stats.week += 1
	stats.clamp_all()

	var summary := {
		"observer_score": observer_score,
		"wage": wage,
		"positions_played": positions.size(),
	}
	return summary
