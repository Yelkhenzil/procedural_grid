extends "res://mesh_instance_3d.gd"


func _ready():
	create_mesh(Mesh.PRIMITIVE_TRIANGLES)

func init_indices():
	var indices = PackedInt32Array()
	for j in range(gridSize+1):
		for i in range (gridSize):		
			indices.append(j*(gridSize+1)+i)
			indices.append(j*(gridSize+1)+i+1)
			indices.append((j+1)*(gridSize+1)+i)
			
			indices.append(j*(gridSize+1)+i+1)
			indices.append((j+1)*(gridSize+1)+i+1)
			indices.append((j+1)*(gridSize+1)+i)

	return indices
