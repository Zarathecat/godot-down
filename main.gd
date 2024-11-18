extends Node

@export var platform_scene: PackedScene

var window_size = DisplayServer.window_get_size()
var score = 0
var high_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_score_display()
	# 50 to be a bit more generous
	if $Player.position.y <= -50 or $Player.position.y >= window_size[1]:
		game_over()

	
func get_random_position(win_size):
	var win_x = int(win_size[0])
	var win_y = int(win_size[1] + 50)
	var rand_pos_x = randi_range(0, win_size[0])
	return Vector2(rand_pos_x, win_y)

func increase_score():
	score +=1
	if score > high_score:
		high_score = score
	
func generate_platform(x, y):
	var platform = platform_scene.instantiate()
	if x < 0 or y < 0:
		platform.position = get_random_position(window_size)
	else:
		platform.position = Vector2(x,y)
	platform.add_to_group("platforms")
	add_child(platform)
	
func update_score_display():
	$Hud/Score.text = "Score: " + str(score)
	$Hud/Score.text += "\nHigh Score: " + str(high_score)
	
func game_over():
	var platforms = get_tree().get_nodes_in_group("platforms")
	for platform in platforms:
		platform.queue_free()
	$Platform.queue_free() # Remove the first one, too
	restart()

func restart():
	generate_platform(window_size.x/2, 4 * window_size.y/ 5)
	# Start far down
	$Player.position = Vector2(window_size.x/2, 4 * window_size.y /5 -50)
	score = 0
	

func _on_new_platform_timer_timeout() -> void:
	generate_platform(-1,-1)
	increase_score()
