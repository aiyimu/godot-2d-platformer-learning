extends Node2D

## Level 01 - Initial level
## Generates terrain tiles in _ready()

@onready var tile_map: TileMap = $TileMap

# Tile atlas coordinates (atlas_x, atlas_y)
const TILE_GRASS := Vector2i(0, 0)
const TILE_DIRT := Vector2i(1, 0)
const TILE_STONE := Vector2i(2, 0)
const TILE_GRASS_LEFT := Vector2i(3, 0)
const TILE_GRASS_RIGHT := Vector2i(0, 1)
const TILE_GRASS_TOP_LEFT := Vector2i(1, 1)
const TILE_GRASS_TOP_RIGHT := Vector2i(2, 1)

const SOURCE_ID: int = 0
const LAYER: int = 0
const GROUND_Y: int = 15
const TILE_SIZE: int = 16


func _ready() -> void:
	_build_terrain()
	_setup_camera_limits()


func _build_terrain() -> void:
	# === Start area (left): flat ground ===
	for x in range(0, 15):
		_set_tile(x, GROUND_Y, TILE_GRASS)
	for x in range(0, 15):
		for y in range(GROUND_Y + 1, GROUND_Y + 5):
			_set_tile(x, y, TILE_DIRT)

	# === Jump practice area (middle): gaps + low platforms ===
	# Gap 1: x=15,16 (2-tile wide gap)
	# Ground continues x=17 to x=24
	for x in range(17, 25):
		_set_tile(x, GROUND_Y, TILE_GRASS)
	for x in range(17, 25):
		for y in range(GROUND_Y + 1, GROUND_Y + 5):
			_set_tile(x, y, TILE_DIRT)

	# Low platform (above the gap)
	for x in range(14, 18):
		_set_tile(x, GROUND_Y - 3, TILE_STONE)

	# Gap 2: x=25,26
	# Ground continues x=27 to x=39
	for x in range(27, 40):
		_set_tile(x, GROUND_Y, TILE_GRASS)
	for x in range(27, 40):
		for y in range(GROUND_Y + 1, GROUND_Y + 5):
			_set_tile(x, y, TILE_DIRT)

	# Staircase platforms
	for x in range(22, 26):
		_set_tile(x, GROUND_Y - 2, TILE_STONE)
	for x in range(28, 31):
		_set_tile(x, GROUND_Y - 4, TILE_STONE)
	for x in range(33, 36):
		_set_tile(x, GROUND_Y - 6, TILE_STONE)

	# === Challenge area (right) ===
	# Gap 3: x=40,41,42 (3-tile wide gap)
	# Right ground x=43 to x=60
	for x in range(43, 61):
		_set_tile(x, GROUND_Y, TILE_GRASS)
	for x in range(43, 61):
		for y in range(GROUND_Y + 1, GROUND_Y + 5):
			_set_tile(x, y, TILE_DIRT)

	# Alternating height platforms
	for x in range(44, 47):
		_set_tile(x, GROUND_Y - 3, TILE_STONE)
	for x in range(49, 52):
		_set_tile(x, GROUND_Y - 5, TILE_STONE)
	for x in range(54, 57):
		_set_tile(x, GROUND_Y - 3, TILE_STONE)

	# Edge tile decoration
	_set_tile(0, GROUND_Y, TILE_GRASS_LEFT)
	_set_tile(60, GROUND_Y, TILE_GRASS_RIGHT)


func _set_tile(x: int, y: int, atlas_coords: Vector2i) -> void:
	tile_map.set_cell(LAYER, Vector2i(x, y), SOURCE_ID, atlas_coords)


func _setup_camera_limits() -> void:
	var camera: Camera2D = $Player/Camera2D
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = 61 * TILE_SIZE
	camera.limit_bottom = (GROUND_Y + 5) * TILE_SIZE
