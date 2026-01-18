extends TileMapLayer

@export var player: CharacterBody2D

var removed_cells := {}
var player_mask := 0
var tile_size := Vector2(32, 32)

func _ready():
	if player:
		player_mask = player.collision_layer
	var ts := tile_set
	if ts:
		tile_size = ts.tile_size

func apply_light_polygon(poly_global: PackedVector2Array, light_type: bool) -> void:
	var still_removed := {}
	for c in removed_cells.keys():
		if _cell_overlaps_player(c):
			still_removed[c] = removed_cells[c]
			continue
		var data = removed_cells[c]
		set_cell(c, data.source, data.atlas, data.alt)
	removed_cells = still_removed

	var poly_local := PackedVector2Array()
	for p in poly_global:
		poly_local.append(to_local(p))
	if poly_local.size() < 3:
		return

	var rect := Rect2(poly_local[0], Vector2.ZERO)
	for p in poly_local:
		rect = rect.expand(p)

	var from_cell := local_to_map(rect.position)
	var to_cell := local_to_map(rect.position + rect.size)

	for y in range(from_cell.y - 1, to_cell.y + 2):
		for x in range(from_cell.x - 1, to_cell.x + 2):
			var cell := Vector2i(x, y)
			if removed_cells.has(cell):
				continue
			var source_id := get_cell_source_id(cell)
			if source_id == -1:
				continue
			var tile_data := get_cell_tile_data(cell)
			if tile_data == null:
				continue
			if tile_data.get_custom_data("disappearing") and light_type == false:
				pass
			elif tile_data.get_custom_data("appearing") and light_type == true:
				pass
			else:
				continue
			var point := map_to_local(cell) + tile_size * 0.5
			if Geometry2D.is_point_in_polygon(point, poly_local):
				removed_cells[cell] = {
					"source": source_id,
					"atlas": get_cell_atlas_coords(cell),
					"alt": get_cell_alternative_tile(cell)
				}
				set_cell(cell, source_id, get_cell_atlas_coords(cell), 1)

func _cell_overlaps_player(cell: Vector2i) -> bool:
	if player == null:
		return false
	if player_mask == 0:
		player_mask = player.collision_layer
	var rect_shape := RectangleShape2D.new()
	rect_shape.size = tile_size
	var cell_center_local := map_to_local(cell) + tile_size * 0.5
	var cell_center_global := to_global(cell_center_local)
	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = rect_shape
	params.transform = Transform2D(0.0, cell_center_global)
	params.collision_mask = player_mask
	params.collide_with_bodies = true
	params.collide_with_areas = false
	var space := get_world_2d().direct_space_state
	var hits := space.intersect_shape(params, 1)
	return hits.size() > 0
