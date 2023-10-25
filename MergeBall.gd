extends RigidBody2D

var ball_scene = preload("res://ball.tscn")

var parent = null

const numIndex = 0
const fontSizeIndex = 1
const colorIndex = 2

var ball_types = [
	[1   , 16, Color.hex(0x0)],
	[2   , 16, Color.hex(0xece4dbff)],
	[4   , 18, Color.hex(0xeae0c9ff)],
	[8   , 32, Color.hex(0xe5b47eff)],
	[16  , 42, Color.hex(0xe49b68ff)],
	[32  , 55, Color.hex(0xe28563ff)],
	[64  , 64, Color.hex(0xdf6b43ff)],
	[128 , 75, Color.hex(0xe6d07aff)],
	[256 , 80, Color.hex(0xe5cd6bff)],
	[512 , 84, Color.hex(0xe5c95cff)],
	[1024, 86, Color.hex(0xe4c64fff)],
	[2048, 90, Color.hex(0xe4c443ff)],
	[4096, 98, Color.hex(0x3d3933ff)],
]

var current_radius
var current_color

var lifetime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent().get_parent()
	var collision_shape = $CollisionShape2D as CollisionShape2D
	var shape = (collision_shape.shape as CircleShape2D)
	mass = shape.radius
	current_radius = shape.radius
	#print("R: " + str(shape.radius))
	var c = int(int(shape.radius) / 10)
	#print("Color: " + str(c))
	
	var num = $Num as Label
	var settings = LabelSettings.new()
	if c < ball_types.size():
		current_color = ball_types[c][colorIndex]
		collision_shape.debug_color = ball_types[c][colorIndex]
		num.text = str(ball_types[c][0])
		settings.font_size = ball_types[c][fontSizeIndex]
		if c <= 2:
			settings.font_color = Color.hex(0x746d62ff)
		num.label_settings = settings
			
	else: 
		var index = ball_types.size()-1
		collision_shape.debug_color = ball_types[index][colorIndex];
		settings.font_size = ball_types[index][fontSizeIndex]
		num.text = str(pow(2, c))
	num.label_settings = settings

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	lifetime += 1
	#if lifetime > 1000:
	#	rotate(deg_to_rad(.5))
	#	apply_torque(10 * mass) 
	if lifetime > 500:
		var _dir = 1
		#if (lifetime / 500) > 250: 
		#	dir = -1
		rotate(deg_to_rad(.25))
		#apply_torque(dir * 10_000 * mass) 
	pass

func _draw():
	draw_circle(position, current_radius, current_color)

func _on_body_entered(body):
	var label = body.get_node_or_null("./SizeLabel") as Label
	var node = body.get_node_or_null("./IndexLabel") as Label
	var self_label = self.get_node("SizeLabel") as Label
	var self_node = self.get_node("IndexLabel") as Label
	if body.is_in_group("destroy_ball"):
		self.queue_free()
		Global.game_over.emit()
		
	if label != null && self_label != null:
		if label.text == self_label.text:	
			# Spawn new
			if node != null :
				if int(node.text) >= int(self_node.text):
					var instance = ball_scene.instantiate()
					var n = instance.get_node(".") as Node2D
					n.position = global_position
					var labelsize = n.get_node("RigidBody2D/SizeLabel") as Label
					labelsize.text = str(25)
					
					# Set Shape Size
					var collision_shape = n.get_node("RigidBody2D/CollisionShape2D") as CollisionShape2D
					var shape = CircleShape2D.new()
					shape.radius = ((get_node("CollisionShape2D") as CollisionShape2D).shape as CircleShape2D).radius + 10
					collision_shape.shape = shape
					
					var size_label = n.get_node("RigidBody2D/SizeLabel") as Label
					size_label.text = str(shape.radius)
					
					# Set Index
					var idx_label = n.get_node("RigidBody2D/IndexLabel") as Label
					idx_label.text = str(int(self_node.text))
					
					var c = int(int(shape.radius) / 10)
					var point = 0
					if c < ball_types.size():
						point = ball_types[c][numIndex]
					else: 
						var index = ball_types.size()-1
						point = ball_types[index][numIndex]
						
					if point < 10:
						point = 10	
					Global.update_score(point/10)
					
					parent.call_deferred("add_child", instance)
					
					# Remove bodies
					body.queue_free()
					self.queue_free()
