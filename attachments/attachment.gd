class_name Attachment extends Node2D

@export var control_marker: Control
@export var z_index_override: int = -1

@onready var drop_area: Area2D = $DropArea
@onready var connect_to_info = $ConnectTo
@onready var sprite = $Sprite

@export var battle_behavior: BattleBehavior
@export var assembly_behavior: AssemblyBehavior

enum Type {
	UNASSIGNED,
	ASSEMBLY,
	BATTLE
}

enum BodyParts {
	Head,
	Shell,
	Tail,
	Foot
}

var type = Type.UNASSIGNED

var id_name: String
var owned_index: int

# ASSEMBLY

var attached: bool = false

signal detached

func _ready():
	add_default_behavior()
	
	var c = connect_to_info.connect_to
	var b = BodyParts
	
	if z_index_override == -1:
		match (c):
			b.Foot:
				sprite.z_index = 12
			b.Shell:
				sprite.z_index = 10
			b.Head:
				sprite.z_index = 11
			b.Tail:
				sprite.z_index = 9
	else:
		z_index = z_index_override


func add_default_behavior():
	if type == Type.ASSEMBLY:
		if !assembly_behavior:
			assembly_behavior = AssemblyBehavior.new()
			add_child(assembly_behavior)
	if type == Type.BATTLE:
		if !battle_behavior:
			battle_behavior = BattleBehavior.new()
			add_child(battle_behavior)


func replace_slot(slot: AttachmentSlot):
	slot.set_new_attachment(self)


func attach(slot: AttachmentSlot):
	print("ATTACHED")
	if not slot:
		return
	attached = true
	replace_slot(slot)
	global_position = slot.global_position
	rotation = slot.rotation
	global_scale = slot.global_scale


func detach():
	print("DETACHING")
	attached = false
	detached.emit()
	rotation = 0
	scale = Vector2(1,1)


func get_slot() -> AttachmentSlot:
	for area in drop_area.get_overlapping_areas():
		if area is SlotArea:
			if connect_to_info.connect_to == area.get_parent().type:
				return area.get_parent()
	return null
