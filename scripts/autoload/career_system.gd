extends Node
## Kariyer terfisi, yıllık fitness testi ve emeklilik sonları (§11-13).

const MIN_MATCHES_FOR_PROMOTION := 4
const MIN_AVG_SCORE_FOR_PROMOTION := 1.5

func average_score(stats: RefereeStats) -> float:
	if stats.matches_played <= 0:
		return 0.0
	return stats.career_score / stats.matches_played

func can_attempt_promotion(stats: RefereeStats) -> bool:
	return not stats.is_top_tier() \
		and stats.matches_played >= MIN_MATCHES_FOR_PROMOTION \
		and average_score(stats) >= MIN_AVG_SCORE_FOR_PROMOTION \
		and stats.federation_rel >= 40.0

func promotion_blockers(stats: RefereeStats) -> Array[String]:
	var blockers: Array[String] = []
	if stats.is_top_tier():
		blockers.append("Zaten en üst seviyedesin.")
		return blockers
	if stats.matches_played < MIN_MATCHES_FOR_PROMOTION:
		blockers.append("En az %d maç yönetmen gerekiyor (%d/%d)." % [
			MIN_MATCHES_FOR_PROMOTION, stats.matches_played, MIN_MATCHES_FOR_PROMOTION
		])
	if average_score(stats) < MIN_AVG_SCORE_FOR_PROMOTION:
		blockers.append("Ortalama gözlemci notun yetersiz (%.2f / %.2f)." % [
			average_score(stats), MIN_AVG_SCORE_FOR_PROMOTION
		])
	if stats.federation_rel < 40.0:
		blockers.append("Federasyon İlişkisi çok düşük (%.0f / 40)." % stats.federation_rel)
	return blockers

## Fitness testi: Kondisyon + Çeviklik ortalaması başarı şansını belirler.
func attempt_fitness_test(stats: RefereeStats) -> bool:
	var chance: float = clampf((stats.stamina + stats.agility) / 2.0 / 99.0, 0.1, 0.95)
	return randf() < chance

func attempt_promotion(stats: RefereeStats) -> Dictionary:
	if not can_attempt_promotion(stats):
		return {"success": false, "reason": "Terfi koşulları sağlanmıyor."}
	if not attempt_fitness_test(stats):
		return {"success": false, "reason": "Fitness testinde başarısız oldun, bu sezon terfi yok."}

	stats.league_tier += 1
	stats.matches_played = 0
	stats.career_score = 0.0
	return {"success": true, "reason": "Tebrikler! %s seviyesine terfi ettin." % stats.league_name()}

## §13 Sonlar tablosu.
func determine_retirement_ending(stats: RefereeStats) -> String:
	if stats.is_top_tier() and stats.public_rel > 80.0 and stats.max_suspicion < 40.0:
		return "efsane_hakem"
	if stats.federation_rel > 85.0 and stats.public_rel < 30.0:
		return "kukla"
	if stats.dirty_money > 50000 and stats.suspicion < 50.0:
		return "kacis"
	if stats.federation_rel < 15.0:
		return "surgun"
	return "emekli"

const ENDING_TITLES := {
	"efsane_hakem": "EFSANE HAKEM",
	"kukla": "KUKLA",
	"surgun": "SÜRGÜN",
	"yakalandin": "YAKALANDIN",
	"kacis": "KAÇIŞ",
	"trajik_son": "TRAJİK SON",
	"emekli": "SESSİZ EMEKLİLİK",
}

const ENDING_DESCRIPTIONS := {
	"efsane_hakem": "FIFA kokartına ulaştın, halkın sevgisini hiç kaybetmedin ve gölgeli bir geçmişin yok. Adın efsaneler arasına yazıldı.",
	"kukla": "Federasyonun gözdesi oldun ama halk seni hiç sevmedi. Güvendesin, ama itibarsız bir kariyerin var.",
	"surgun": "Federasyonla köprüleri attın. Kariyerin alt liglerde sessizce çürüdü.",
	"yakalandin": "Şüphe zirveye çıktı, kanıtlar toplandı. Sürekli hak mahrumiyeti ve olası bir dava seni bekliyor.",
	"kacis": "Cebinde büyük bir kirli servetle, patlamadan önce bırakmayı bildin. Tedirgin ama zengin bir kaçış.",
	"trajik_son": "Halkın gözünde tükendin ve sahada bir saldırının kurbanı oldun. Kariyerin böyle bitti.",
	"emekli": "Ne efsane ne rezil - sıradan, unutulan bir kariyerin sonuna geldin.",
}
