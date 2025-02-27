extends Node

@export var obstacle : PackedScene
@export var coin : PackedScene

var dynamic_objects_speed: int = 700
var player_health : float = 100
var health_decrease_speed : int = 10
var score : float

var obstacle_spawn_x : int = 1700
var coin_spawn_x : int = 1700

var last_obstacle_position : String


func _process(_delta: float) -> void:
	for dynamic_object in get_tree().get_nodes_in_group("Dynamic_Object"):
		dynamic_object.position.x -= _delta * dynamic_objects_speed
		
	if player_health > 0:
		player_health-= _delta * health_decrease_speed
		$UI/HealthBar.value = player_health
	else:
		_game_over()
		
	score += _delta
	var formatted_score = str(score)
	var decimal_index = formatted_score.find(".")
	formatted_score = formatted_score.left(decimal_index+3)
	$UI/HealthBar/Score.text = formatted_score
	
	


func _on_spawn_timer_timeout() -> void:
	var random : int = randi() % 2
	var obstacle_instance : Area2D = obstacle.instantiate()
	add_child(obstacle_instance)
	obstacle_instance.position.x = obstacle_spawn_x
	obstacle_instance.body_entered.connect(_on_obstacle_collided)
	if random == 0:
		obstacle_instance.position.y = 200
		last_obstacle_position = "up"
	elif random == 1:
		obstacle_instance.position.y = 800
		obstacle_instance.scale.y *= -1
		last_obstacle_position = "down"


func _on_coin_timer_timeout() -> void:
	var random_posi : int = randi() % 3
	# check if coin posi and obstacle posi are the same
	if random_posi == 0 and last_obstacle_position == "up":
		return
	if random_posi == 2 and last_obstacle_position == "down":
		return
		
	var coin_instance : Area2D = coin.instantiate()
	
	add_child(coin_instance)
	coin_instance.position.x = coin_spawn_x
	coin_instance.position.y = 280 + random_posi * 200
	coin_instance.body_entered.connect(_on_coin_collided.bind(coin_instance))

func _on_coin_collided(body : Node2D, coin_instance : Area2D) -> void:
	if body.is_in_group("Player"):
		player_health +=15
		coin_instance.queue_free()
		
		if player_health > 100:
			player_health= 100
		pass
		
func _on_obstacle_collided(body : Node2D) -> void:
	if body.is_in_group("Player"):
		_game_over()

func _game_over() -> void:
	$Game_Over.show()
	get_tree().paused = true
