extends Node
## Şike teklifi üretimi ve tam seçim ağacı (§6.2): kabul-yap / kabul-yapma / reddet / ihanet.

const SOURCES := ["Kulüp Yöneticisi", "Bahisçi", "Aracı"]

## §6.1 TeklifOlasılığı formülü.
func maybe_generate_offer(stats: RefereeStats, match_importance: float) -> Dictionary:
	var base_chance := 0.12 * match_importance
	var federation_factor := 1.0 + (100.0 - stats.federation_rel) / 200.0
	var repeat_factor := 1.0 + stats.total_bribes_accepted * 0.1
	var chance: float = base_chance * federation_factor * repeat_factor
	if randf() > chance:
		return {}

	var source: String = SOURCES[randi() % SOURCES.size()]
	var amount := int(randf_range(4000, 15000) * (stats.league_tier + 1) * match_importance)
	return {"source": source, "amount": amount}

## §6.2 tam sonuç tablosu.
func apply_choice(stats: RefereeStats, offer: Dictionary, choice: String) -> String:
	var source: String = offer.get("source", "Bilinmeyen")
	var amount: int = offer.get("amount", 0)
	var result_text := ""

	match choice:
		"accept_do":
			stats.dirty_money += amount
			stats.suspicion += 15.0
			stats.evidence_score += 10.0
			stats.total_bribes_accepted += 1
			stats.adjust_npc(source, 20.0, 0.0)
			result_text = "Şikeyi kabul edip yaptın. %d TL kirli para kasana girdi, ama Şüphe arttı." % amount
		"accept_skip":
			stats.dirty_money += amount
			stats.suspicion += 5.0
			stats.evidence_score += 4.0
			stats.total_bribes_accepted += 1
			stats.adjust_npc(source, 0.0, 80.0)
			result_text = "Parayı aldın ama sözünü tutmadın. %s artık senden nefret ediyor." % source
		"reject":
			stats.adjust_npc(source, -10.0, 0.0)
			result_text = "Teklifi reddettin. %s'in güveni kırıldı." % source
		"betray":
			var reward := int(amount * 0.4)
			stats.clean_money += reward
			stats.federation_rel += 15.0
			stats.suspicion = maxf(0.0, stats.suspicion - 5.0)
			stats.evidence_score = maxf(0.0, stats.evidence_score - 5.0)
			stats.adjust_npc(source, 0.0, 100.0)
			result_text = "İhanet ettin: federasyona bildirdin. +%d TL temiz ödül, ama %s artık ölümcül düşmanın." % [reward, source]

	stats.clamp_all()
	return result_text
