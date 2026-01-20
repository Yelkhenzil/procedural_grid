extends Node


class_name MouseCollision

func mouse_grid_position(camera : Camera3D,cell_size:float) ->Vector3:
	return (camera.project_ray_origin(get_viewport().get_mouse_position())*Vector3(1,0,1)/(cell_size)).floor()*(cell_size)+Vector3(0.5,0,0.5)*cell_size
	
