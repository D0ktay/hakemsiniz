extends Control

const ENERGY_COST := 15.0

@onready var energy_label: Label = %EnergyLabel
@onready var family_bar: ProgressBar = %FamilyBar
@onready var journalist_bar: ProgressBar = %JournalistBar
@onready var friend_bar: ProgressBar = %FriendBar
@onready var family_button: Button = %FamilyButton
@onready var journalist_button: Button = %JournalistButton
@onready var friend_button: Button = %FriendButton
@onready var result_label: Label = %ResultLabel
@onready var back_button: Button = %BackButton

func _ready() -> void:
	family_button.pressed.connect(_on_family)
	journalist_button.pressed.connect(_on_journalist)
	friend_button.pressed.connect(_on_friend)
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/hub.tscn"))
	_refresh()

func _refresh() -> void:
	var s := GameManager.stats
	energy_label.text = "Enerji: %.0f / 100 (her aktivite %.0f enerji harcar)" % [s.energy, ENERGY_COST]
	family_bar.value = s.family_rel
	journalist_bar.value = s.journalist_rel
	friend_bar.value = s.friend_rel
	var enough: bool = s.energy >= ENERGY_COST
	family_button.disabled = not enough
	journalist_button.disabled = not enough
	friend_button.disabled = not enough

func _spend() -> void:
	var s := GameManager.stats
	s.energy -= ENERGY_COST

func _on_family() -> void:
	var s := GameManager.stats
	if s.energy < ENERGY_COST:
		return
	_spend()
	s.family_rel += 10.0
	s.clamp_all()
	result_label.text = "Ailenle vakit geçirdin. Aile İlişkisi arttı."
	GameManager.stats_changed.emit()
	_refresh()

func _on_journalist() -> void:
	var s := GameManager.stats
	if s.energy < ENERGY_COST:
		return
	_spend()
	s.journalist_rel += 10.0
	s.clamp_all()
	result_label.text = "Gazeteciyle görüştün. Bir skandal çıkarsa artık daha yumuşak yazacak."
	GameManager.stats_changed.emit()
	_refresh()

func _on_friend() -> void:
	var s := GameManager.stats
	if s.energy < ENERGY_COST:
		return
	_spend()
	s.friend_rel += 10.0
	if s.friend_rel > 60.0:
		s.suspicion = maxf(0.0, s.suspicion - 3.0)
		result_label.text = "Hakem arkadaşın sana dedikodu ve ipuçları verdi. Şüphe biraz azaldı."
	else:
		result_label.text = "Bir hakem arkadaşınla sohbet ettin."
	s.clamp_all()
	GameManager.stats_changed.emit()
	_refresh()
