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

var grid_data : Array[ArrayMesh]

func _ready() -> void:
	grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size,cell_size)
	camera.global_position = Vector3(grid_size*cell_size/2.0,5,grid_size*cell_size/2.0)
	collider.shape.size = Vector3(grid_size*cell_size,0.1,grid_size*cell_size)
	collider.global_position = Vector3(grid_size*cell_size/2.0,-0.05,grid_size*cell_size/2.0)


func _physics_process(delta: float) -> void:
	print(mouse_collision.mouse_grid_position(camera))
