extends CanvasLayer

func _ready():
	network.connect("server_created", self, "_on_ready_to_play")
	network.connect("join_success", self, "_on_ready_to_play")
	network.connect("join_fail", self, "_on_join_fail")

func set_player_info():
	pass

func _on_btCreate_pressed():
	set_player_info()
	
	if (!$PanelHost/txtServerName.text.empty()):
		network.server_info.name = $PanelHost/txtServerName.text
	network.server_info.max_players = int($PanelHost/txtMaxPlayers.value)
	network.server_info.used_port = int($PanelHost/txtServerPort.text)
	
	network.create_server()


func _on_btJoin_pressed():
	set_player_info()
	
	var ip = $PanelJoin/txtJoinIP.text
	var port = int($PanelJoin/txtJoinPort.text)
	
	network.join_server(ip, port)


func _on_ready_to_play():
	get_tree().change_scene("res://base/levels/content/multiplayer.tscn")

func _on_join_fail():
	print("Failed to join server")