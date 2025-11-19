class_name RedGreenButton extends Button


signal emit_contents

func _on_toggled(toggled_on: bool) -> void:
	emit_contents.emit(text,toggled_on)
