extends Node2D

var size = 0

func _ready():
	for slot: AttachmentSlot in get_children():
		slot.number = size
		size += 1
