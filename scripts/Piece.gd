class_name Piece
extends Node2D

onready var selection_sprite: Sprite = $SelectionSprite

enum TYPES { heart, energy, badge, bag }
signal piece_selected(Piece)

export(TYPES) var type: int = 0
export(bool) var is_blocked: bool = false

var row_column: Vector2
var is_selected: bool = false

func _on_selected_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventScreenTouch && event.is_pressed()):
		#piece_selected(!is_selected)
		emit_signal("piece_selected", self)

func piece_selected(selection: bool) -> void:
	if (selection):
		get_tree().call_group("selected", "piece_selected", false)
		add_to_group("selected")
	else:
		remove_from_group("selected")
	selection_sprite.visible = selection
	is_selected = selection
