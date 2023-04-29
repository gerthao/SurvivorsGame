extends CharacterBody2D
class_name BasicEnemy

@onready var health_component: HealthComponent     = $HealthComponent as HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent as VelocityComponent
@onready var hurtbox_component: HurtboxComponent   = $HurtboxComponent as HurtboxComponent
@onready var hit_audio_player                      = $%HitAudioComponent as RandomAudioStreamPlayer2DComponent
@onready var visuals: Node2D                       = $Visuals
@onready var sprite: Sprite2D                      = $Visuals/Sprite2D
@onready var animation_player: AnimationPlayer     = $AnimationPlayer

@onready var sprite_texture: Texture2D = [
	preload("res://scenes/game_object/basic_enemy/basic_enemy_1.png"),
	preload("res://scenes/game_object/basic_enemy/basic_enemy_2.png")
].pick_random()


func _ready():
	hurtbox_component.hit.connect(on_hit)


func _process(delta):
	sprite.texture = sprite_texture
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	update_sprite(velocity_component.velocity)
	

func update_sprite(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		animation_player.play("RESET")
		return 
		
	animation_player.play("move")
	visuals.scale = Vector2(-sign(direction.x), 1)
	
	
func on_hit() -> void:
	hit_audio_player.play_random()
