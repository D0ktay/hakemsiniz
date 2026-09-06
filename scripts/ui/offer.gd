extends Control

@onready var info_label: Label = %InfoLabel
@onready var accept_do_button: Button = %AcceptDoButton
@onready var accept_skip_button: Button = %AcceptSkipButton
@onready var reject_button: Button = %RejectButton
@onready var betray_button: Button = %BetrayButton

func _ready() -> void:
	var offer := GameManager.pending_offer
	info_label.text = "%s sana %d TL teklif ediyor. Maçı istedikleri gibi yönetmen karşılığında." % [
		offer.get("source", "Bilinmeyen"), offer.get("amount", 0)
	]
	accept_do_button.pressed.connect(func(): GameManager.resolve_offer("accept_do"))
	accept_skip_button.pressed.connect(func(): GameManager.resolve_offer("accept_skip"))
	reject_button.pressed.connect(func(): GameManager.resolve_offer("reject"))
	betray_button.pressed.connect(func(): GameManager.resolve_offer("betray"))
