extends Node2D
@export var _dimensions : Vector2i = Vector2i(2,2)
@export var _start : Vector2i = Vector2i(-1,-1)
@export var _critical_path_length : int = 2
@export var _branches : int = 3
@export var _branch_length : Vector2i = Vector2i(1, 4)
@export var _roomLength : int = 160
@export var _roomWidth : int = 160

var validPos : Array
var _branch_canidates : Array[Vector2i]
var dungeon : Array
var dungeonMap : Array
var dungeonNodes : Array
var exit1 : Array[Node2D]
var exit2 : Array[Node2D]
var exit3 : Array[Node2D]
var exit4 : Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initialize_dungeon()
	_place_entrance()
	_generate_critical_path(_start, _critical_path_length)
	_print_dungeon()
	_calcValPos()
	_placeMapTest()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _initialize_dungeon() -> void:
	for x in _dimensions.x:
		dungeon.append([])
		for y in _dimensions.y:
			dungeon[x].append(0)
	for x in _dimensions.x:
		dungeonMap.append([])
		for y in _dimensions.y:
			dungeonMap[x].append(0)
	for x in _dimensions.x:
		validPos.append([])
		for y in _dimensions.y:
			validPos[x].append(0)
			
			
func _print_dungeon() -> void:
	var dungeon_as_string : String = ""
	for y in range(_dimensions.y -1, -1, -1):
		for x in _dimensions.x:
			if dungeon [x][y]:
				dungeon_as_string += "[" + str(dungeon[x][y]) + "]"
			else:
				dungeon_as_string += "  "
		dungeon_as_string += '\n'
	print(dungeon_as_string)
	
	
func _place_entrance() -> void:
	if _start.x < 0 or _start.x >= _dimensions.x:
		_start.x = randi_range(0, _dimensions.x -1)
	if _start.y < 0 or _start.y >= _dimensions.y:
		_start.y = randi_range(0, _dimensions.y - 1)
	dungeon[_start.x][_start.y] = 2
	
func _calcValPos() -> void:
	for y in range(_dimensions.y -1, -1, -1):
		for x in _dimensions.x:
			validPos[x][y] = Vector2(((_dimensions.x - x) * (_roomWidth)) - ((_dimensions.x / 2) * _roomLength),((_dimensions.y - y) * (_roomLength)) - ((_dimensions.y / 2) * _roomLength))
	
func _generate_critical_path(from : Vector2i, length : int) -> bool:
	if length == 0:
		return true
	var current : Vector2i = from
	var direction : Vector2i
	match randi_range(0,3):
		0:
			direction = Vector2i.UP
		1:
			direction = Vector2i.RIGHT
		2:
			direction = Vector2i.DOWN
		3: 
			direction = Vector2i.LEFT
	for i in 4:
		if (current.x + direction.x >= 0 and current.x + direction.x < _dimensions.x and 
			current.y + direction.y >= 0 and current.y + direction.y < _dimensions.y and 
			not dungeon[current.x + direction.x][current.y + direction.y]):
			current += direction
			dungeon[current.x][current.y] = 1
			if length > 1:
				_branch_canidates.append(current)
			if _generate_critical_path(current, length - 1):
				return true
			else:
				_branch_canidates.erase(current)
				dungeon[current.x][current.y] = 0
				current -= direction
		direction = Vector2(direction.y, -direction.x)
	return false
func _generate_branches () -> void:
	pass
func _mapSetup () -> void:
	pass
func _placeMapTest() -> void:
	var tempRoom
	for y in range(_dimensions.y -1, -1, -1):
		for x in range(_dimensions.x):
			if dungeon[x][y] != 0:
				match randi_range(0,1):
					0:
						dungeonMap[x][y] = $Room_1
					1:
						dungeonMap[x][y] = $Room_2
	for y in range(_dimensions.y -1, -1, -1):
		for x in range(_dimensions.x):
			tempRoom = dungeonMap[x][y]
			add_child(tempRoom)
			tempRoom.position = validPos[x][y]
			
func _placeMap () -> void:
	if dungeon[0][1] != 0:
		match randi_range(0,1):
			0:
				var topLeft = $Room_1.duplicate()
				add_child(topLeft)
				topLeft.position = Vector2(-160,-160)
			1:
				var topLeft = $Room_2.duplicate()
				add_child(topLeft)
				topLeft.position = Vector2(-160,-160)

	if dungeon[0][0] != 0:
		match randi_range(0,1):
			0:
				var botLeft = $Room_1.duplicate()
				add_child(botLeft)
				botLeft.position = Vector2(-160,160)
			1:
				var botLeft = $Room_2.duplicate()
				add_child(botLeft)
				botLeft.position = Vector2(-160,160)
		
	if dungeon[1][0] != 0:
		match randi_range(0,1):
			0:
				var botRight = $Room_1.duplicate()
				add_child(botRight)
				botRight.position = Vector2(160,160)
			1:
				var botRight = $Room_2.duplicate()
				add_child(botRight)
				botRight.position = Vector2(160,160)
		
	if dungeon[1][1] != 0:
		match randi_range(0,1):
			0:
				var topRight = $Room_1.duplicate()
				add_child(topRight)
				topRight.position = Vector2(160,-160)
			1:
				var topRight = $Room_2.duplicate()
				add_child(topRight)
				topRight.position = Vector2(160,-160)
func _exitCalc (_exitNum: int) -> void:
	pass
