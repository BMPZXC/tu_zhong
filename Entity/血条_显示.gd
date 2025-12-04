@tool
extends Node2D
class_name 血条
@export var 目标:生物
func _ready() -> void:
	if Engine.is_editor_hint():return
	if not 目标.生命_.is_connected(刷新):
		目标.生命_.connect(刷新)
func 刷新():
	queue_redraw()

const _血条_长度=3
func _draw() -> void:
	var q:int=0
	if Engine.is_editor_hint():
		q=目标.生命_上线
	else :
		q=目标.生命
	if q<=0:return
	var a=Vector2(0,0)
	画线(Vector2(0,0),Vector2.RIGHT)
	while -a.y<q*_血条_长度:
		画框(a)
		a.y-=_血条_长度
	
func 画线(f:Vector2,t:Vector2)->Vector2:
	draw_line(f,f+t*_血条_长度,Color.AZURE,1)
	return f+t*_血条_长度
func 画框(a:Vector2):
	a=画线(a,Vector2.UP)
	a=画线(a,Vector2.RIGHT)
	画线(a,Vector2.DOWN)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if 目标:
			queue_redraw()
	else :
		set_process(false)
