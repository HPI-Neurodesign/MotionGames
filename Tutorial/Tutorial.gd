extends Node2D

signal start
signal stop

var running = false

func _ready():
	JoyCon.init()
	JoyCon.get_controller_index()
	JoyCon.set_controller(0)
	
func _physics_process(_delta):
	pass
	#if not running and $"/root/JoyCon".any_button_pressed();
	#	start_game()

func start_game():
	$Explanation.visible = false
	running = true
	emit_signal("start")

func stop_game():
	emit_signal("stop")
	running = false
	var text = tr("KEY_CONGRATS")
	text += "\n"
	text += tr("KEY_FINAL_SCORE").format({score=$UI.score})
	$Explanation.set_final_score(text)

func _on_timeout():
	stop_game()
