extends Control

@onready var money_label: Label = %MoneyLabel
@onready var lawyer_button: Button = %LawyerButton
@onready var protection_button: Button = %ProtectionButton
@onready var house_button: Button = %HouseButton
@onready var launder_small_button: Button = %LaunderSmallButton
@onready var launder_all_button: Button = %LaunderAllButton
@onready var result_label: Label = %ResultLabel
@onready var back_button: Button = %BackButton

func _ready() -> void:
	lawyer_button.pressed.connect(func(): _do(EconomySystem.hire_lawyer(GameManager.stats)))
	protection_button.pressed.connect(func(): _do(EconomySystem.hire_protection(GameManager.stats)))
	house_button.pressed.connect(func(): _do(EconomySystem.buy_house(GameManager.stats)))
	launder_small_button.pressed.connect(func(): _do(EconomySystem.launder(GameManager.stats, mini(5000, GameManager.stats.dirty_money))))
	launder_all_button.pressed.connect(func(): _do(EconomySystem.launder(GameManager.stats, GameManager.stats.dirty_money)))
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/hub.tscn"))
	_refresh()

func _do(message: String) -> void:
	result_label.text = message
	GameManager.stats.clamp_all()
	GameManager.stats_changed.emit()
	_refresh()

func _refresh() -> void:
	var s := GameManager.stats
	money_label.text = "Temiz: %d TL   |   Kirli: %d TL   |   Aklanıyor: %d TL" % [
		s.clean_money, s.dirty_money, _pending_total(s)
	]
	house_button.disabled = s.owns_house
	launder_small_button.disabled = s.dirty_money <= 0
	launder_all_button.disabled = s.dirty_money <= 0

func _pending_total(s: RefereeStats) -> int:
	var total := 0
	for entry in s.pending_laundering:
		total += int(entry.get("amount", 0))
	return total
