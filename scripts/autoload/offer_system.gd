extends Node
## Şike teklifi üretimi ve sonuçları. MVP kapsamı: kabul et / reddet (§6.2'nin ilk iki satırı).

const SOURCES := ["Kulüp Yöneticisi", "Bahisçi", "Aracı"]

## %TeklifOlasılığı formülü (§6.1) — sadeleştirilmiş.
func maybe_generate_offer(stats: RefereeStats, match_importance: float) -> Dictionary:
	var base_chance := 0.12 * match_importance
	var federation_factor := 1.0 + (100.0 - stats.federation_rel) / 200.0
	var chance: float = base_chance * federation_factor
	if randf() > chance:
		return {}

	var amount := int(randf_range(4000, 15000) * (stats.league_tier + 1) * match_importance)
	return {
		"source": SOURCES[randi() % SOURCES.size()],
		"amount": amount,
	}

func apply_choice(stats: RefereeStats, offer: Dictionary, choice: String) -> void:
	match choice:
		"accept":
			stats.dirty_money += int(offer.get("amount", 0))
			stats.suspicion += 15.0
		"reject":
			stats.federation_rel += 1.0
	stats.clamp_all()
