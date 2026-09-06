extends Control

const ENERGY_COST := 20.0
const STAT_NAMES := {
	"agility": "Çeviklik", "stamina": "Kondisyon", "concentration": "Konsantrasyon",
	"vision": "Görüş", "authority": "Otorite", "composure": "Soğukkanlılık",
}

@onready var energy_label: Label = %EnergyLabel
@onready var stat_box: VBoxContainer = %StatBox
@onready var result_label: Label = %ResultLabel
@onready var back_button: Button = %BackButton

func _ready() -> void:
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/hub.tscn"))
	_rebuild()

func _rebuild() -> void:
	var s := GameManager.stats
	energy_label.text = "Enerji: %.0f / 100 (antrenman %.0f enerji harcar)" % [s.energy, ENERGY_COST]

	for child in stat_box.get_children():
		child.queue_free()

	for key in STAT_NAMES.keys():
		var current: float = s.get(key)
		var btn := Button.new()
		btn.text = "%s (%.0f) - Çalış" % [STAT_NAMES[key], current]
		btn.custom_minimum_size = Vector2(0, 48)
		btn.disabled = s.energy < ENERGY_COST
		btn.pressed.connect(_on_train.bind(key))
		stat_box.add_child(btn)

func _on_train(key: String) -> void:
	var s := GameManager.stats
	if s.energy < ENERGY_COST:
		return
	var current: float = s.get(key)
	var gain: float = maxf(0.5, 3.0 - (current / 99.0) * 2.5)
	s.set(key, minf(99.0, current + gain))
	s.energy -= ENERGY_COST
	s.clamp_all()
	result_label.text = "%s +%.1f arttı." % [STAT_NAMES[key], gain]
	GameManager.stats_changed.emit()
	_rebuild()
