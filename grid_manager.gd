class_name GridManager

extends Node3D

@export var grid  : Grid
@export_range(1,50) var grid_size  : int = 5:
	set(new_grid_size):
		grid_size = new_grid_size
		if(grid!=null):
			grid.clean_mesh()
			grid.create_mesh(Mesh.PRIMITIVE_LINES,new_grid_size,cell_size)
		if(instance_hovered_gameobject!=null):
			instance_hovered_gameobject.scale = Vector3(cell_size,cell_size,cell_size)
@export_range(1,100)var cell_size  : float=1:
	set(new_cell_size):
		cell_size = new_cell_size
		if(grid!=null):
			grid.clean_mesh()
			grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size,new_cell_size)
		if(instance_hovered_gameobject!=null):
			instance_hovered_gameobject.scale = Vector3(cell_size,cell_size,cell_size)
@export var camera : Camera3D

@export var collider : CollisionShape3D
@export var mouse_collision : MouseCollision
@export var hovered_gameobject : PackedScene

var instance_hovered_gameobject : MeshInstance3D
var grid_data : Array[MeshInstance3D]
var grid_bool : Array[bool]

func _ready() -> void:
	grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size,cell_size)
	camera.global_position = Vector3(grid_size*cell_size/2.0,5,grid_size*cell_size/2.0)
	collider.shape.size = Vector3(grid_size*cell_size,0.1,grid_size*cell_size)
	collider.global_position = Vector3(grid_size*cell_size/2.0,-0.05,grid_size*cell_size/2.0)
	instance_hovered_gameobject = hovered_gameobject.instantiate()
	instance_hovered_gameobject.scale*=cell_size
	grid_data.resize(grid_size*grid_size)
	grid_bool.resize(grid_size*grid_size)
	add_child(instance_hovered_gameobject)


func _physics_process(delta: float) -> void:
	var mouse3d = mouse_collision.mouse_grid_position(camera,cell_size)
	if(mouse3d.x >= 0 and mouse3d.z >= 0 and mouse3d.x <= grid_size*cell_size and mouse3d.z <= grid_size*cell_size):
		instance_hovered_gameobject.position = mouse3d
		instance_hovered_gameobject.get_active_material(0).albedo_color = Color(1,1,1,0.5)
		
	else :
		instance_hovered_gameobject.get_active_material(0).albedo_color = Color(1,1,1,0)

	
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
		var mouse3d = mouse_collision.mouse_grid_position(camera,cell_size)
		var i = floori((mouse3d.x-cell_size/2)/cell_size)
		var j = floori((mouse3d.z-cell_size/2)/cell_size)
		print(grid_data[j*grid_size+i])
		if(!grid_bool[j*grid_size+i]) : 
			var adding = hovered_gameobject.instantiate()
			adding.scale*=cell_size
			adding.position = mouse3d
			adding.name = "[%d,%d]"%[i,j]
			add_child(adding)
			grid_bool[j*grid_size+i] = true
			grid_data[j*grid_size+i] = adding
			print(grid_data[j*grid_size+i])
		else : 
			grid_bool[j*grid_size+i] = false
			grid_data[j*grid_size+i].queue_free()
			
		
