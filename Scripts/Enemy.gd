extends CharacterBody2D

@export var speed = 100.0
@export var health = 100

var animated_sprite: AnimatedSprite2D

func _ready():
	animated_sprite = $AnimatedSprite2D
	print("Enemy ready - GDScript version")

func take_damage(damage: int):
	health -= damage
	print("Enemy took ", damage, " damage. Health: ", health)
	
	if health <= 0:
		die()

func die():
	print("Enemy died")
	queue_free() 