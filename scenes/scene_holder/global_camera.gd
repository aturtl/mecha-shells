class_name GlobalCamera extends Camera2D


var following: Node = null
@onready var global_node: Node2D = $Global
@onready var local_node: Node2D = $Local

var local_children = []


func _ready():
	print("cam ready")


func reset():
	following = null
	zoom = Vector2.ONE
	scale = Vector2.ONE
	position = -get_viewport_rect().size/2.0


func follow(node: Node):
	following = node


func add_to_local(node: Node2D):
	local_children.append(node)


func add_to_global(node: Node):
	global_node.add_child(node)


func clear_local():
	for child: Node in local_node.get_children():
		local_node.remove_child(child)
		child.queue_free()


func set_global_zoom(z: Vector2):
	zoom = z
	scale = Vector2.ONE/z


func _process(delta):
	print(local_children)
	for child in local_children:
		child.position = self.position - get_viewport_rect().size/2.0
		child.reparent(local_node)
	
	local_children.clear()
	if following:
		position = following.position
