class_name Grid

extends MeshInstance3D

var grid_size: int =  50
var cell_size: float =  2

func create_mesh(primitive_Type:Mesh.PrimitiveType,gridsize:int,cellsize:float):
	self.grid_size = gridsize
	self.cell_size = cellsize
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	# PackedVector**Arrays for mesh construction.
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	
	for j in range(grid_size+1):
		for i in range (grid_size+1):
			var point = Vector3(i*cell_size,0,j*cell_size)
			verts.append(point)
			normals.append(Vector3(0,1,0))
			uvs.append(Vector2(i/(float)(grid_size),j/(float)(grid_size)))
	
	var indices  = init_indices()
		# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	mesh.add_surface_from_arrays(primitive_Type, surface_array)
	mesh.surface_get_material(0)


func clean_mesh():
	mesh.clear_surfaces()

func init_indices():
	var indices = PackedInt32Array()
	for j in range(grid_size+1):
		for i in range (grid_size):		
			indices.append(j*(grid_size+1)+i)
			indices.append(j*(grid_size+1)+i+1)
			
			indices.append(j*(grid_size+1)+i)
			indices.append((j+1)*(grid_size+1)+i)
		indices.append(j*(grid_size+1)+grid_size)
		indices.append((j+1)*(grid_size+1)+grid_size)
	return indices
