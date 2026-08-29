extends TextureButton
@onready var musicker: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
func _on_pressed() -> void:
	musicker.play()
