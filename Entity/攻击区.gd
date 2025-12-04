extends Area2D

@export var 击飞强度:Vector2  =Vector2(2,1)
signal 命中
func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		

func _on_body_entered(body: Node2D) -> void:
	if body is 生物:
		body.受击()
		命中.emit()
