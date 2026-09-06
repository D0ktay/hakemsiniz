extends Control

@onready var info_label: Label = %InfoLabel
@onready var button_box: VBoxContainer = %ButtonBox

func _ready() -> void:
	var threat := GameManager.pending_threat
	info_label.text = threat.get("text", "")

	for child in button_box.get_children():
		child.queue_free()

	var options: Array = []
	match threat.get("type", ""):
		"santaj":
			options = [["pay", "Öde"], ["refuse", "Reddet"], ["report", "Federasyona Bildir"]]
		"taraftar":
			options = [["ignore", "Görmezden Gel"], ["protection", "Koruma Tut (2000 TL)"], ["police", "Polise Git"]]
		"saldiri":
			options = [["sue", "Dava Aç"], ["silent", "Sessiz Kal"]]

	for opt in options:
		var btn := Button.new()
		btn.text = opt[1]
		btn.custom_minimum_size = Vector2(0, 52)
		var choice: String = opt[0]
		btn.pressed.connect(func(): GameManager.resolve_threat(choice))
		button_box.add_child(btn)
