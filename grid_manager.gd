class_name GridManager

extends Node3D

@export var grid  : Grid
@export_range(1,50) var grid_size  : int = 5:
	set(new_grid_size):
		grid_size = new_grid_size
		grid.clean_mesh()
		grid.create_mesh(Mesh.PRIMITIVE_LINES,new_grid_size,cell_size)
@export_range(1,100)var cell_size  : float=1:
	set(new_cell_size):
		cell_size = new_cell_size
		grid.clean_mesh()
		grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size,new_cell_size)
		
@export var camera : Camera3D

@export var collider : CollisionShape3D
@export var mouse_collision : MouseCollision
@export var hovered_gameobject : PackedScene
var instance_hovered_gameobject : MeshInstance3D
var grid_data : Array[ArrayMesh]
var grid_bool : Array[bool]
func _ready() -> void:
	grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size,cell_size)
	camera.global_position = Vector3(grid_size*cell_size/2.0,5,grid_size*cell_size/2.0)
	collider.shape.size = Vector3(grid_size*cell_size,0.1,grid_size*cell_size)
	collider.global_position = Vector3(grid_size*cell_size/2.0,-0.05,grid_size*cell_size/2.0)
	instance_hovered_gameobject = hovered_gameobject.instantiate()
	instance_hovered_gameobject.scale*=cell_size
	add_child(instance_hovered_gameobject)


func _physics_process(delta: float) -> void:
	var mouse3d = mouse_collision.mouse_grid_position(camera)
	if(mouse3d.x >= 0 and mouse3d.z >= 0 and mouse3d.x <= grid_size*cell_size and mouse3d.z <= grid_size*cell_size):
		instance_hovered_gameobject.position = mouse3d
		instance_hovered_gameobject.get_active_material(0).albedo_color = Color(1,1,1,1)
	else :
		instance_hovered_gameobject.get_active_material(0).albedo_color = Color(1,1,1,0)
	m
		
