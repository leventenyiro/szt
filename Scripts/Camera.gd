extends KinematicBody2D

var dragging = false

func _ready():
	set_process_input(true)
## Controls the camera.
## @desc:
## 		Controls the camera movement.
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = get_global_mouse_position()
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			$Camera2D.zoom.x -=0.10
			$Camera2D.zoom.y -=0.10
			if $Camera2D.zoom.x < 0.20 and $Camera2D.zoom.y <0.20:
					$Camera2D.zoom = Vector2(0.20,0.20)
		elif event.button_index == BUTTON_WHEEL_DOWN:
				$Camera2D.zoom.x +=0.10
				$Camera2D.zoom.y +=0.10
				if $Camera2D.zoom.x > 1 and $Camera2D.zoom.y >1:
					$Camera2D.zoom = Vector2(1,1)
