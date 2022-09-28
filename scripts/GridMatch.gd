class_name GridMatch
extends Node2D

export (int) var row_number:= 0
export (int) var column_number:= 0
export (int) var space_pieces:= 0
export (int) var position_x:= 0
export (int) var position_y:= 0
export (Array) var main_grid:= []

var pieces: Array = [
	preload("res://scenes/pieces/HeartPiece.tscn"), 
	preload("res://scenes/pieces/EnergyPiece.tscn"),
	preload("res://scenes/pieces/BagPiece.tscn"),
	preload("res://scenes/pieces/BadgePiece.tscn")]

var piece_one: Piece
var piece_two: Piece

func _ready() -> void:
	randomize()
	main_grid = make_2d_array()

func make_2d_array() -> Array:
	var grid_array:= []
	var last_type:= 0
	for i in row_number:
		grid_array.append([])
		for j in column_number:
			var piece = create_random_piece(i, j)
			while(last_type == piece.type):
				piece = create_random_piece(i, j)
			grid_array[i].append(piece)
			add_child(piece)
			last_type = piece.type
	return grid_array
	
func grid_piece_position(row_position: int, column_position: int) -> Vector2:
	var new_position_x = position_x + space_pieces * column_position
	var new_position_y = position_y + space_pieces * row_position
	return Vector2(new_position_x, new_position_y)
	# return Vector2(position_x + column_position * space_pieces, position_y - row_position * space_pieces)
	#return Vector2((position_x + (column_position * space_pieces)), (position_y - (row_position * space_pieces)))

func create_random_piece(row: int, column: int) -> Piece:
	var new_piece = pieces[randi() % pieces.size()].instance() as Piece
	new_piece.connect("piece_selected", self, "on_piece_selected")
	new_piece.position = grid_piece_position(row, column)
	new_piece.row_column = Vector2(row, column)
	return new_piece
	
func should_switch_piece(other_piece: Piece) -> bool:
	if (other_piece.is_blocked):
		return false
	
	var up_piece:= Vector2(piece_one.row_column.x - 1, piece_one.row_column.y)
	var down_piece:= Vector2(piece_one.row_column.x + 1, piece_one.row_column.y)
	var left_piece:= Vector2(piece_one.row_column.x, piece_one.row_column.y - 1)
	var right_piece:= Vector2(piece_one.row_column.x, piece_one.row_column.y + 1)

	if (up_piece == other_piece.row_column || down_piece == other_piece.row_column 
	|| left_piece == other_piece.row_column || right_piece == other_piece.row_column):
		print("it is possible")
		return true
		
	return false

func swap_piece_position() -> void:	
	var temp_position = piece_one.position
	var temp_row_column = piece_one.row_column
	var temp_arr_piece = main_grid[piece_one.row_column.x][piece_one.row_column.y]

	main_grid[piece_one.row_column.x][piece_one.row_column.y] = main_grid[piece_two.row_column.x][piece_two.row_column.y]
	main_grid[piece_two.row_column.x][piece_two.row_column.y] = temp_arr_piece
	
	piece_one.position = piece_two.position
	piece_two.position = temp_position
	piece_one.row_column = piece_two.row_column
	piece_two.row_column = temp_row_column

	#piece_one = null
	#piece_two = null

func on_piece_selected(selected_piece: Piece) -> void:
	print("grid row %s x column %s" % [selected_piece.row_column.x, selected_piece.row_column.y])
	if (piece_one == null):
		piece_one = selected_piece
		selected_piece.piece_selected(true)
	elif (piece_one == selected_piece):
		piece_one = null
		selected_piece.piece_selected(false)
	elif (piece_two == null && should_switch_piece(selected_piece)):
		piece_two = selected_piece
		piece_one.piece_selected(true)
		swap_piece_position()
		yield(get_tree().create_timer(0.5), "timeout")
		swap_piece_position()
		piece_one = null
		piece_two = null
	else:
		piece_one = selected_piece
		piece_two = null
		selected_piece.piece_selected(true)
