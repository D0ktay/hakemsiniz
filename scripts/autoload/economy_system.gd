extends Node
## Mağaza, harcamalar ve kirli para aklama (§10).

const LAUNDER_LOSS_RATE := 0.25
const LAUNDER_DELAY_WEEKS := 2

const LAWYER_COST := 8000
const PROTECTION_COST := 2000
const PROTECTION_WEEKS := 4
const HOUSE_COST := 20000

func launder(stats: RefereeStats, amount: int) -> String:
	if amount <= 0 or amount > stats.dirty_money:
		return "Geçersiz miktar."
	stats.dirty_money -= amount
	var net := int(amount * (1.0 - LAUNDER_LOSS_RATE))
	stats.pending_laundering.append({"amount": net, "ready_week": stats.week + LAUNDER_DELAY_WEEKS})
	return "%d TL kirli para aklamaya gönderildi (%d TL net, %d hafta sonra temiz hesaba geçer)." % [
		amount, net, LAUNDER_DELAY_WEEKS
	]

func process_weekly(stats: RefereeStats) -> void:
	var still_pending: Array = []
	for entry in stats.pending_laundering:
		if stats.week >= int(entry.get("ready_week", 0)):
			stats.clean_money += int(entry.get("amount", 0))
		else:
			still_pending.append(entry)
	stats.pending_laundering = still_pending

	# Aklanmamış büyük kirli para tutmak Şüphe'yi zamanla artırır (§8.1 basitleştirilmiş).
	if stats.dirty_money > 20000:
		stats.suspicion += 2.0
	stats.suspicion = maxf(0.0, stats.suspicion - 1.0) # doğal soğuma

	if stats.protection_weeks > 0:
		stats.protection_weeks -= 1

func hire_lawyer(stats: RefereeStats) -> String:
	if stats.clean_money < LAWYER_COST:
		return "Yeterli temiz paran yok (%d TL gerekiyor)." % LAWYER_COST
	stats.clean_money -= LAWYER_COST
	stats.evidence_score = maxf(0.0, stats.evidence_score - 25.0)
	stats.has_lawyer_retainer = true
	return "Avukat tuttun. Kanıt puanın azaldı."

func hire_protection(stats: RefereeStats) -> String:
	if stats.clean_money < PROTECTION_COST:
		return "Yeterli temiz paran yok (%d TL gerekiyor)." % PROTECTION_COST
	stats.clean_money -= PROTECTION_COST
	stats.protection_weeks += PROTECTION_WEEKS
	return "%d hafta boyunca korumalısın." % PROTECTION_WEEKS

func buy_house(stats: RefereeStats) -> String:
	if stats.owns_house:
		return "Zaten bir evin var."
	if stats.clean_money < HOUSE_COST:
		return "Yeterli temiz paran yok (%d TL gerekiyor)." % HOUSE_COST
	stats.clean_money -= HOUSE_COST
	stats.owns_house = true
	return "Bir ev aldın. Artık haftalar arası enerjin daha hızlı toparlanacak."
