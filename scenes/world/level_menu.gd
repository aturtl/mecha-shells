extends CameraUI


@onready var header_text = $"LevelHeader/Text"


func set_text(text: String):
	if not is_node_ready():
		await ready
	header_text.text = "[center]"+text+"[/center]"
