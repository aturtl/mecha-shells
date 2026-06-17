class_name MechStats extends Node

var actions = [
	ActionIdle.new(),
	ActionDodge.new(),
	ActionJump.new(),
	ActionJumpAt.new(),
	ActionBackup.new(),
	ActionRandomDirection.new(),
	ActionTackle.new()
]

var attachment_behaviors = []

var equipped_attachments = []
var equipped_chassis: Chassis
