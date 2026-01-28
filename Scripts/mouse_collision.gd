extends Node


class_name MouseCollision

func mouse_grid_position(camera : Camera3D,cell_size:float) ->Vector3:
	return (camera.project_ray_origin(get_viewport().get_mouse_position())*Vector3(1,0,1)/(cell_size)).floor()*(cell_size)+Vector3(0.5,0,0.5)*cell_size
	
func on_click(camera :Camera3D,grid_size:int,cell_size:float,grid_bool : Array[bool],grid_data:Array[MeshInstance3D],hovered_gameobject : PackedScene,grid : Node3D):
	var mouse3d = mouse_grid_position(camera,cell_size)
	if(mouse3d.x >= 0 and mouse3d.z >= 0 and mouse3d.x <= grid_size*cell_size and mouse3d.z <= grid_size*cell_size):
		var i = floori((mouse3d.x-cell_size/2)/cell_size)
		var j = floori((mouse3d.z-cell_size/2)/cell_size)

		if(!grid_bool[j*grid_size+i]) : 
			var adding = hovered_gameobject.instantiate()
			adding.scale*=cell_size
			adding.position = mouse3d
			adding.name = "[%d,%d]"%[i,j]
			grid.add_child(adding)
			grid_bool[j*grid_size+i] = true
			grid_data[j*grid_size+i] = adding
			print(grid_data[j*grid_size+i])
		else : 
			grid_bool[j*grid_size+i] = false
			grid_data[j*grid_size+i].queue_free()


func on_click_dual(camera :Camera3D,grid_size:int,cell_size:float):
	var mouse3d = mouse_grid_position(camera,cell_size)
	if(mouse3d.x >= 0 and mouse3d.z >= 0 and mouse3d.x <= grid_size*cell_size and mouse3d.z <= grid_size*cell_size):
		var i = floori((mouse3d.x-cell_size/2)/cell_size)
		var j = floori((mouse3d.z-cell_size/2)/cell_size)
		return [i,j]
	return null
