extends AnimationPlayer

@onready var animation_player: AnimationPlayer = $CanvasLayer2/Panel/AnimationPlayer

func 保存成功(a:bool):
	if a==true:
		animation_player.play("保存")

func _on_color_rect_focus_entered() -> void:
	play_backwards("入场")


@onready var control: Control = $CanvasLayer/CenterContainer/Panel/Control/Control
@onready var canvas_layer_2: CanvasLayer = $CanvasLayer2

const 主场景路径="res://Scene/主页/主页.tscn"
func _是否为主页(_a=null):
	if _是否为主页_2():
		control.visible=false
		canvas_layer_2.visible=false
	else :
		control.visible=true
		canvas_layer_2.visible=true
	
func _是否为主页_2()->bool:
	if not get_tree() or get_tree().root.get_child_count()==0:return false
	return get_tree().root.get_child(-1).get_scene_file_path()==主场景路径


func _on_button_pressed() -> void:
	play_backwards("入场")
	await animation_finished
	转场.加载完毕.connect(func (a):clear_nonglobal_from_root(a))
	转场.切换章节(主场景路径)
	

# 清除场景树 root 中所有“非全局”子节点
func clear_nonglobal_from_root(a) -> void:
	var root := get_tree().root
	for child in root.get_children():
		if child.is_in_group("全局脚本") or child==a:continue
		for conn in child.tree_exited.get_connections():
			child.tree_exited.disconnect(conn.callable)
		child.queue_free() 
	
	
	
@onready var h_slider: HSlider = $CanvasLayer/CenterContainer/Panel/Control/Label/HSlider
@onready var h_slider_2: HSlider = $CanvasLayer/CenterContainer/Panel/Control/Label2/HSlider

var 音量_音效_基础=AudioServer.get_bus_volume_db(AudioServer.get_bus_index("ui音效"))
var 音量_背景音乐=AudioServer.get_bus_volume_db(AudioServer.get_bus_index("音乐"))
func _ready() -> void:
	get_tree().root.child_order_changed.connect(_是否为主页)
	_是否为主页()
	var a=ConfigFile.new()
	a.load(存档.路径)
	h_slider.value=a.get_value("设置","音量_音效",50)
	h_slider_2.value=a.get_value("设置","音量_背景音乐",50)

func _on_h_slider_value_changed(value: float) -> void:
	_改音量("ui音效",value,音量_音效_基础)
func _on_h_slider_value_changed_2(value: float) -> void:
	_改音量("音乐",value,音量_背景音乐)

@export var curve: Curve
func _改音量(a,b:float,c):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(a),
		pct_to_db(curve.sample(b/100))+c
)
func pct_to_db(pct: float) -> float:
	if pct <= 0.0:
		return -80.0
	return 20.0 * log(pct) / log(10.0)
	
func _存储(b,c):
	var a=ConfigFile.new()
	a.load(存档.路径)
	a.set_value("设置",b,c)
	a.save(存档.路径)


func _on_h_slider_changed() -> void:
	_存储("音量_音效",h_slider.value)
func _on_h_slider_changed_2() -> void:
	_存储("音量_背景音乐",h_slider_2.value)


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed:return
	_存储("音量_音效",h_slider.value)
func _on_h_slider_drag_ended_2(value_changed: bool) -> void:
	if not value_changed:return
	_存储("音量_背景音乐",h_slider_2.value)


func _on_texture_rect_pressed() -> void:
	play("入场")
