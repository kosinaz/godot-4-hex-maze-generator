extends Node2D

const COLUMNS = 16
const ROWS = 8
const WALL = 0
const PATH = 1
const LENGTH = 4
var map = {}
var stack = []
var current: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	# Fill with walls
	for x in COLUMNS * LENGTH + 3:
		for y in ROWS * LENGTH + 3:
			map[Vector2i(x, y)] = WALL
	
	# Set start
	var start_x = 1 + randi_range(0, COLUMNS) * LENGTH
	var start_y = 1 + randi_range(0, ROWS) * LENGTH
	current = Vector2i(start_x, start_y)
	stack.append(current)
	
	# Generate the maze
	while stack:
		var neighbors = check_neighbors(current)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			connect_cells(current, next)
			current = next
			stack.append(current)
		elif stack:
			current = stack.pop_back()
		
	set_cells()


# Returns an array of cell's unvisited neighbors
func check_neighbors(cell):

	var list = []
	
	var left_top = Vector2i(cell.x - LENGTH, cell.y - LENGTH / 2)
	if map.has(left_top) and map[left_top] == WALL:
		list.append(left_top)
		
	var left_bottom = Vector2i(cell.x - LENGTH, cell.y + LENGTH / 2)
	if map.has(left_bottom) and map[left_bottom] == WALL:
		list.append(left_bottom)
		
	var righttop = Vector2i(cell.x + LENGTH, cell.y - LENGTH / 2)
	if map.has(righttop) and map[righttop] == WALL:
		list.append(righttop)
		
	var rightbottom = Vector2i(cell.x + LENGTH, cell.y + LENGTH / 2)
	if map.has(rightbottom) and map[rightbottom] == WALL:
		list.append(rightbottom)
	
	var top = Vector2i(cell.x, cell.y - LENGTH)
	if map.has(top) and map[top] == WALL:
		list.append(top)
		
	var bottom = Vector2i(cell.x, cell.y + LENGTH)
	if map.has(bottom) and map[bottom] == WALL:
		list.append(bottom)
	
	return list

func connect_cells(from, to):
	
	if from.x < to.x:
		if from.y == to.y + LENGTH / 2:
			for i in range(LENGTH + 1):
				map[Vector2i(from.x + i, from.y - i / 2)] = PATH
		
		if from.y == to.y - LENGTH / 2:
			for i in range(LENGTH + 1):
				map[Vector2i(from.x + i, from.y + i / 2 + i % 2)] = PATH

	elif from.x > to.x:
		if from.y == to.y + LENGTH / 2:
			for i in range(LENGTH + 1):
				map[Vector2i(from.x - i, from.y - i / 2)] = PATH

		if from.y == to.y - LENGTH / 2:
			for i in range(LENGTH + 1):
				map[Vector2i(from.x - i, from.y + i / 2 + i % 2)] = PATH

	else:
		if from.y < to.y:
			for i in range(LENGTH + 1):
				map[Vector2i(from.x, from.y + i)] = PATH

		else:
			for i in range(LENGTH + 1):
				map[Vector2i(from.x, from.y - i)] = PATH

func set_cells():
	for x in COLUMNS * LENGTH + 3:
		for y in ROWS * LENGTH + 3:
			$TileMap.set_cell(0, Vector2i(x, y), 0, Vector2i(map[Vector2i(x, y)], 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
