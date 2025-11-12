class_name RedGreenButton extends Button

var contents

signal emit_contents

func _on_toggled(toggled_on: bool) -> void:
	emit_contents.emit(contents,toggled_on)
