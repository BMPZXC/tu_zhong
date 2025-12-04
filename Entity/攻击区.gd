extends Area2D
@export var a:生物
@export var 击飞强度:float=1
signal 命中
func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		

func _on_body_entered(body: Node2D) -> void:
	if body is 生物:
		var b=(body.global_position-a.global_position).normalized()
		body.velocity+=b*击飞强度/body.质量*200
		body.受击(a)
		命中.emit()
