class_name GridManager

extends Node3D

@export var grid  : Grid
@export_range(1,50) var grid_size  : int = 5:
	set(new_grid_size):
		grid_size = new_grid_size
		update_mesh()
		update_hovered()
@export_range(1,100)var cell_size  : float=1:
	set(new_cell_size):
		cell_size = new_cell_size
		update_mesh()
		update_hovered()
@export var camera : Camera3D

@export var collider : CollisionShape3D
@export var mouse_collision : MouseCollision
@export var hovered_scene : PackedScene
@export var insctanced_scene : PackedScene
@export var grid_parent : Node3D
var hovered_cell : MeshInstance3D
var grid_data : Array[MeshInstance3D]
var grid_bool : Array[bool]

func _ready() -> void:
	grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size,cell_size,Vector3.ZERO)
	camera.global_position = Vector3(grid_size*cell_size/2.0,5,grid_size*cell_size/2.0)
	collider.shape.size = Vector3(grid_size*cell_size,0.1,grid_size*cell_size)
	collider.global_position = Vector3(grid_size*cell_size/2.0,-0.05,grid_size*cell_size/2.0)
	hovered_cell = hovered_scene.instantiate()
	hovered_cell.scale*=cell_size
	grid_data.resize(grid_size*grid_size)
	grid_bool.resize(grid_size*grid_size)
	mouse_collision.add_child(hovered_cell)


func _physics_process(delta: float) -> void:
	var mouse3d = mouse_collision.mouse_grid_position(camera,cell_size)
	if(mouse3d.x >= 0 and mouse3d.z >= 0 and mouse3d.x <= grid_size*cell_size and mouse3d.z <= grid_size*cell_size):
		hovered_cell.position = mouse3d
		hovered_cell.get_active_material(0).albedo_color = Color(1,1,1,0.5)
		
	else :
		hovered_cell.get_active_material(0).albedo_color = Color(1,1,1,0)

	
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
		mouse_collision.on_click(camera,grid_size,cell_size,grid_bool,grid_data,insctanced_scene,grid_parent)
			
		
		
func update_mesh():
	if(grid!=null):
		grid.clean_mesh()
		grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size,cell_size,Vector3.ZERO)

func update_hovered():
	if(hovered_cell!=null):
		hovered_cell.scale = Vector3(cell_size,cell_size,cell_size)
