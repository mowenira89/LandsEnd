
class_name Camera extends Camera2D

const MIN_ZOOM=0.1
const MAX_ZOOM=1.5
const ZOOM_INCRIMENT=.1
const ZOOM_RATE=1.0

var _target_zoom:float=1
var dont_zoom=false

func _ready():
	GM.camera=self

func _unhandled_input(event: InputEvent) -> void:
	if !dont_zoom:
		if event.is_action_pressed("MWD"):
			zoom_in()
		elif event.is_action_pressed("MWU"):
			zoom_out()

func zoom_in():
	_target_zoom = max(_target_zoom-ZOOM_INCRIMENT,MIN_ZOOM)
	
func zoom_out():
	_target_zoom = min(_target_zoom+ZOOM_INCRIMENT,MAX_ZOOM)
	
func _physics_process(delta: float) -> void:
	var _target = Vector2(_target_zoom,_target_zoom)
	zoom = lerp(zoom,_target,ZOOM_RATE)
	
func find_cell(cell:Vector2i):
	var coord = GM.board.ground.map_to_local(cell)
	global_position=coord
