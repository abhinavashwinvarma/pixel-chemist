extends CanvasLayer
@onready var play: TextureButton = $ButtonContainer/Play
@onready var quit: TextureButton = $ButtonContainer/Quit
@onready var background: TileMap = $TileMap
@onready var credits_popup: NinePatchRect = $CreditsPopup
@onready var credits_exit: TextureButton = $CreditsPopup/CreditsExit

func _ready() -> void:
	background.position = Vector2(0, 0)
	credits_popup.hide()

func _process(_delta: float) -> void:
	background.position.x += 0.5

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed() -> void:
	credits_popup.show()

func _on_credits_exit_pressed() -> void:
	credits_popup.hide()
