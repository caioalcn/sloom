class_name GridMatch
extends Node2D

onready var heart_piece: PackedScene = preload("res://scenes/HeartPiece.tscn")

export (int) var column:= 0
export (int) var row:= 0
export (int) var space_pieces:= 0
export (int) var position_x:= 0
export (int) var position_y:= 0

func _ready() -> void:
	print_debug(make_2d_array())

func make_2d_array() -> Array:
	var grid_array:= []
	for i in row:
		grid_array.append([])
		for j in column:
			var piece = heart_piece.instance()
			piece.position = grid_piece_position(i, j)
			grid_array[i].append(piece)
			add_child(piece)
	return grid_array
	
func grid_piece_position(column_position: int, row_position: int) -> Vector2:
	#	return Vector2(position_x + space_pieces * column_position, position_y + space_pieces * row_position)
	#  Vector2(position_x + column_position * space_pieces, position_y - row_position * space_pieces)
	return Vector2((position_x + (column_position * space_pieces)), (position_y - (row_position * space_pieces)))
