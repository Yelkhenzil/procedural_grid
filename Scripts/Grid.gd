class_name Grid

extends MeshInstance3D

var cell_size: float =  2
var offset: Vector3 =  Vector3(10,0,5)
func create_mesh(primitive_Type:Mesh.PrimitiveType,grid_size:int,cellsize:float,offsetpos:Vector3):
	self.cell_size = cellsize
	self.offset = offsetpos
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
	
	var indices  = init_indices(grid_size)
		# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	mesh.add_surface_from_arrays(primitive_Type, surface_array)
	mesh.surface_get_material(0)
	print(offset)
	position = offset


func clean_mesh():
	mesh.clear_surfaces()

func init_indices(grid_size:int):
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
