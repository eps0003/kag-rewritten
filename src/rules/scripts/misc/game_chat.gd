extends CanvasLayer

signal chat_opened()
signal chat_closed()

export (int) var max_characters = 150

onready var chat_panel = $Panel
onready var chat_tween = $Panel/Layout/ChatTween
onready var chat_display = $Panel/Layout/ChatDisplay
onready var chat_input = $Panel/Layout/ChatInput

func _ready():
	chat_input.connect("text_entered", self, "_send_message")
	_disable()

func _enable():
	chat_panel.show()
	set_process_input(true)

func _disable():
	chat_panel.hide()
	set_process_input(false)

func _input(event):
	if chat_input.has_focus():
		if Input.is_action_just_pressed("chat_close") or Input.is_action_just_pressed("chat_any"):
			if chat_input.text.empty():
				chat_input.release_focus()
				get_tree().set_input_as_handled()
	else:
		if Input.is_action_just_pressed("chat_open") or Input.is_action_just_pressed("chat_any"):
			chat_input.grab_focus()
			get_tree().set_input_as_handled()

func _send_message(message):
	chat_input.clear()
	chat_input.release_focus()

	rpc("_forward_message", message)

remotesync func _forward_message(message: String):
	if !(message is String) or message.replace(" ", "").empty():
		return

	var pinfo = network.players[get_tree().get_rpc_sender_id()]

	var filtered = message.dedent()
	if max_characters > 0 and message.length() > max_characters:
		filtered = filtered.substr(0, max_characters) + " [...]"

	chat_display.append_bbcode(str("\n", "[color=yellow]<", pinfo.name, ">[/color] ", filtered))


func _on_ChatInput_focus_entered():
	emit_signal("chat_opened")


func _on_ChatInput_focus_exited():
	emit_signal("chat_closed")
