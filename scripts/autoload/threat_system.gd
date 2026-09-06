extends Node
## Tehdit ve baskı sistemi (§7). Taraftar/mafya/şantaj/fiziksel saldırı.

func maybe_generate_threat(stats: RefereeStats, match_importance: float) -> Dictionary:
	# En kinci NPC şantaj/mafya tehdidi başlatabilir.
	var worst_source := ""
	var worst_kin := 0.0
	for source in stats.npc_memory.keys():
		var kin: float = stats.npc_memory[source].get("kin", 0.0)
		if kin > worst_kin:
			worst_kin = kin
			worst_source = source

	if worst_kin >= 60.0 and randf() < 0.35:
		var is_bluff: bool = randf() < 0.3
		return {
			"type": "santaj",
			"source": worst_source,
			"is_bluff": is_bluff,
			"amount": int(randf_range(3000, 12000) * (stats.league_tier + 1)),
			"text": "%s seni şantajlıyor: 'Söylediklerimi yapmazsan ifşa ederim.'" % worst_source,
		}

	if stats.public_rel < 30.0 and randf() < 0.25 * match_importance:
		var severe: bool = stats.public_rel < 10.0 and match_importance > 2.0 and randf() < 0.2
		return {
			"type": "saldiri" if severe else "taraftar",
			"text": "Öfkeli taraftarlar seni tehdit ediyor." if not severe else "Taraftarlar seni fiziksel olarak tehdit ediyor, gerginlik tırmanıyor!",
		}

	return {}

func apply_choice(stats: RefereeStats, threat: Dictionary, choice: String) -> String:
	var result_text := ""
	match threat.get("type", ""):
		"santaj":
			var source: String = threat.get("source", "")
			var amount: int = threat.get("amount", 0)
			match choice:
				"pay":
					stats.clean_money = maxi(0, stats.clean_money - amount)
					result_text = "%d TL ödedin, susturuldu (şimdilik)." % amount
				"refuse":
					if threat.get("is_bluff", false):
						result_text = "Blöfünü gördün, taviz vermedin. Hiçbir şey olmadı."
					else:
						stats.evidence_score += 15.0
						stats.public_rel -= 10.0
						result_text = "Şantajı reddettin, %s belgeleri sızdırdı. İtibarın zedelendi." % source
				"report":
					stats.federation_rel += 5.0
					stats.adjust_npc(source, 0.0, 20.0)
					result_text = "Federasyona bildirdin, korumaya alındın."
		"taraftar":
			match choice:
				"ignore":
					stats.energy -= 10.0
					result_text = "Görmezden geldin, biraz yıprandın."
				"protection":
					stats.clean_money = maxi(0, stats.clean_money - 2000)
					stats.protection_weeks += 2
					result_text = "Koruma tuttun, 2000 TL harcadın."
				"police":
					stats.public_rel += 5.0
					result_text = "Polise gittin, kamuoyu senin yanında."
		"saldiri":
			match choice:
				"sue":
					stats.energy = maxf(10.0, stats.energy - 50.0)
					stats.public_rel += 15.0
					result_text = "Saldırıya uğradın ama dava açtın; kamuoyu senden yana döndü. Ağır yaralandın."
				"silent":
					stats.energy = maxf(10.0, stats.energy - 50.0)
					stats.public_rel -= 5.0
					result_text = "Saldırıya uğradın ve sessiz kaldın. Enerjin çok düştü."

	stats.clamp_all()
	return result_text
