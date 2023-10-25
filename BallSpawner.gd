extends Sprite2D

var ball_scene = preload("res://ball.tscn")

@export var max_x = 500
@export var min_x = -20
var index = 0
@export var min_size = 1 #1
@export var max_size = 4 #4
@export var continuous_spawning = false

# x = 2/3 of width
# y = 1/2 of height

# Called when the node enters the scene tree for the first time.
func _ready():
	next_spawn()
	Global.game_reset.connect(_reset_balls)

func _reset_balls():
	#print("Reset Balls")
	for i in $BallParent.get_children():
		i.queue_free()
	pass

func _input(event):
	if event.is_action_pressed("spawn_ball") && !continuous_spawning:
		var instance = spawn_ball(ball_scene)
		$BallParent.add_child(instance)
		
	if event.is_action_pressed("reset_game"):
		Global.game_reset.emit()

var next_radius = 0

func next_spawn():
	next_radius = randi_range(min_size, max_size) * 10
	var collision_shape = $SpawnerIndicator as MeshInstance2D
	collision_shape.scale = Vector2(next_radius, next_radius) * 2

func spawn_ball(_scene):
	var instance = ball_scene.instantiate()
	
	# Set position
	var n = instance.get_node(".") as Node2D
	n.global_translate(clamp_x_pos(Vector2(get_global_mouse_position().x, position.y)))
	
	# Set Shape
	var collision_shape = n.get_node("RigidBody2D/CollisionShape2D") as CollisionShape2D
	var shape = CircleShape2D.new()
	shape.radius = next_radius
	collision_shape.shape = shape
	
	# Set Text
	var label = n.get_node("RigidBody2D/SizeLabel") as Label
	label.text = str(shape.radius)
	
	# Set Node
	var idx_label = n.get_node("RigidBody2D/IndexLabel") as Label
	idx_label.text = str(index)
	index+=1
	next_spawn()
	return instance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var xy = clamp_x_pos(get_global_mouse_position())
	position.x = xy.x
	
	if Input.is_action_pressed("spawn_ball") && continuous_spawning:
		var instance = spawn_ball(ball_scene)
		add_sibling(instance)

func clamp_x_pos(current):
	if current.x > min_x && current.x < max_x :
		return current
	elif current.x > min_x:
		return Vector2(max_x, current.y)
	else:
		return Vector2(min_x, current.y)
