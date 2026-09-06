extends Control

@onready var info_label: Label = %InfoLabel
@onready var accept_button: Button = %AcceptButton
@onready var reject_button: Button = %RejectButton

func _ready() -> void:
	var offer := GameManager.pending_offer
	info_label.text = "%s sana %d TL teklif ediyor. Maçı istedikleri gibi yönetmen karşılığında." % [
		offer.get("source", "Bilinmeyen"), offer.get("amount", 0)
	]
	accept_button.pressed.connect(func(): GameManager.resolve_offer("accept"))
	reject_button.pressed.connect(func(): GameManager.resolve_offer("reject"))
