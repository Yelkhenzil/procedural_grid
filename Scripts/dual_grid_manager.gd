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
@export var corner : PackedScene
@export var full : PackedScene
@export var side : PackedScene
@export var diagonal : PackedScene
@export var intern : PackedScene
@export var grid_parent : Node3D
var hovered_cell : MeshInstance3D
var grid_data : Array[Node3D]
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
	grid_bool[j*grid_size+i] = true
	update_dual_grid_cell(i,j)
	update_dual_grid_cell(i+1,j)
	update_dual_grid_cell(i,j+1)
	update_dual_grid_cell(i+1,j+1)
	

func update_dual_grid_cell(i,j):
	var flag = get_flag(i,j)
	if(grid_data[j*grid_size+i]!=null):
		grid_data[j*grid_size+i].queue_free()
	if(flag ==0) :
		grid_data[j*grid_size+i] = null
		return 
	var object =  get_3d_pattern(flag)
	var adding = object.instantiate()
	grid_data[j*grid_size+i] = adding
	adding.scale*=cell_size
	adding.position = Vector3(i*cell_size,0,j*cell_size)
	rotate_pattern(adding,flag)
	adding.name = "[%d,%d]"%[i,j]
	grid_parent.add_child(adding)

	
	print(grid_data[j*grid_size+i])
		
func get_flag(i,j):
	var tl = is_activated(i-1,j-1)<<3
	var tr = is_activated(i,j-1)<<2
	var bl = is_activated(i-1,j)<<1
	var br = is_activated(i,j)
	var flag = tl+tr+bl+br
	return flag
	
func get_3d_pattern(flag : int) :
	if(flag ==15):
		return full
	elif(flag == 1 || flag == 2 || flag == 4 || flag == 8):
		return corner
	elif(flag == 7 || flag == 11 || flag == 13 || flag == 14):
		return intern
	elif(flag == 9 || flag == 6 ):
		return diagonal
	elif(flag == 3 || flag == 5 || flag == 10 || flag == 12) :  
		return side

func rotate_pattern(adding : Node3D,flag):
	if(flag ==3 || flag == 1 || flag == 11 || flag == 9):
		adding.rotate_y(PI/2)
	if(flag ==5 || flag == 4 || flag == 7):
		adding.rotate_y(PI)
	if(flag ==12 || flag == 8 || flag == 13):
		adding.rotate_y(3*PI/2)


	"""elif(flag == 1 || flag == 2 || flag == 4 || flag == 8):

	elif(flag == 7 || flag == 11 || flag == 13 || flag == 14):
		return intern
	elif(flag == 9 || flag == 6 ):
		return diagonal
	elif(flag == 3 || flag == 5 || flag == 10 || flag == 12) :  
		return side"""
		
func is_activated(i,j):
	if(i<0 or j<0 or i>grid_size or j>grid_size):
		print("%s     %s "%[i,j])
		return 0
	else : 
		return int(grid_bool[i+j*grid_size])
		

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
