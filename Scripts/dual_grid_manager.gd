class_name DualGridManager

extends Node3D

@export var regular_grid  : Grid
@export var dual_grid  : Grid

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
	regular_grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size,cell_size,Vector3.ZERO)
	dual_grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size+1,cell_size,Vector3(-cell_size/2.,0,-cell_size/2.))
	camera.global_position = Vector3(grid_size*cell_size/2.0,5,grid_size*cell_size/2.0)
	collider.shape.size = Vector3(grid_size*cell_size,0.1,grid_size*cell_size)
	collider.global_position = Vector3(grid_size*cell_size/2.0,-0.05,grid_size*cell_size/2.0)
	hovered_cell = hovered_scene.instantiate()
	hovered_cell.scale*=cell_size
	grid_data.resize((grid_size+1)**2)
	grid_bool.resize((grid_size+1)**2)
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
		var index = mouse_collision.on_click_dual(camera,grid_size,cell_size)
		if(index!=null) : 
			update_dual_grid_cells(index[0],index[1])

	
func update_dual_grid_cells(i,j):
	update_dual_grid_cell(i,j)
	update_dual_grid_cell(i,j+1)
	update_dual_grid_cell(i+1,j)
	update_dual_grid_cell(i+1,j+1)

func update_dual_grid_cell(i,j):
	if(!grid_bool[j*grid_size+i]) : 
		var adding = insctanced_scene.instantiate()
		adding.scale*=cell_size
		adding.position = Vector3(i*cell_size,0,j*cell_size)
		adding.name = "[%d,%d]"%[i,j]
		grid_parent.add_child(adding)
		grid_bool[j*grid_size+i] = true
		grid_data[j*grid_size+i] = adding
		print(grid_data[j*grid_size+i])
	else : 
		grid_bool[j*grid_size+i] = false
		grid_data[j*grid_size+i].queue_free()
		
func update_mesh():
	if(regular_grid!=null):
		regular_grid.clean_mesh()
		regular_grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size,cell_size,Vector3.ZERO)
	if(dual_grid!=null):
		dual_grid.clean_mesh()
		dual_grid.create_mesh(Mesh.PRIMITIVE_LINES,grid_size+1,cell_size,Vector3(-cell_size/2,0,-cell_size/2))

func update_hovered():
	if(hovered_cell!=null):
		hovered_cell.scale = Vector3(cell_size,cell_size,cell_size)
