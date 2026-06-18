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

var base_modifiers = {
	hp = 10,
	def = 5,
	spd = 8,
	air_spd = 6,
}

var attachment_behaviors = []

var equipped_attachments = []
var equipped_chassis: Chassis

var health_bar: HealthBar

func append_action(action, weight): #weight unused currently
	actions.append(action)


func calculate_damage(dmg: float) -> float:
	var b = base_modifiers
	return dmg/(b.def*1.5)


func damage(dmg: float):
	print(calculate_damage(dmg))
	base_modifiers.hp -= calculate_damage(dmg)
	health_bar.current_health = base_modifiers.hp
	health_bar.update()


func add_modifier(nm: String, value: float):
	if nm in base_modifiers:
		base_modifiers[nm] = value


func get_modifier(nm: String):
	if nm in base_modifiers:
		return max(1, base_modifiers[nm]) # makes sure that the stat remains at least 1
