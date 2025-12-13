extends 生物
class_name Player_2

@onready var camera_2d: Camera2D = $Camera2D

####

##用于 战败 中的 重来
func 重置():
	生命=生命_上线
	position=_初始位置
	#await get_tree().physics_frame  无法处理 受击 的 击飞
	#velocity=Vector2.ZERO

#func 禁用输入(a:bool):   ##用于剧情 以及 战斗
	#set_physics_process(!a)
	#禁用输入=a
	
#func 冻结(a:bool):###用于跳转场景,但保留当前
	#禁用输入=true
	#camera_2d.enabled=!a

var 初始缩放:Vector2
func 镜头至屏幕(a:Control):##用于剧情
	禁用输入=true
	camera_2d.enabled=true
	var 左上=a.global_position
	var 右下=a.scale*a.size+左上
	var 中间=0.5*(左上+右下)
	var 大小:Vector2=a.scale*a.size
	var 倍率=Vector2(get_viewport().get_visible_rect().size)/大小
	var aaa=max(倍率.x,倍率.y)
	var b =get_tree().create_tween()
	b.set_parallel(true)  
	b.tween_property(camera_2d,"global_position",中间,1) 
	b.tween_property(camera_2d,"zoom",Vector2(aaa,aaa),1)
	await b.finished
	
func 镜头至屏幕_复原():
	var b =get_tree().create_tween()
	b.set_parallel(true) 
	b.tween_property(camera_2d,"position",Vector2.ZERO,1)  
	b.tween_property(camera_2d,"zoom",初始缩放,1)
	await b.finished
	禁用输入=false
	
####

func _ready() -> void:
	_初始位置=position
	切换职业(切[0])
	鼠标右键.冷却时间=4
	鼠标右键.冷却结束.connect(func ():可_闪现=true)
	初始缩放=camera_2d.zoom
	
func 限制相机移动(a:Control):
	var b=a.global_position
	var c=a.scale*a.size+b
	camera_2d.limit_left=b.x
	camera_2d.limit_top=b.y
	camera_2d.limit_right=c.x
	camera_2d.limit_bottom=c.y
###
var _初始位置:Vector2

	
############
var 图片_方向=1
@onready var 切:Array[职业]=[$剑2,$弓,$盾]
@onready var 当前职业:职业
var 锁定:bool=false:
	set(a):
		锁定=a
		set_physics_process(!a)
		if a:velocity=Vector2.ZERO

func 切换职业(a:职业):
	当前职业=a
	鼠标左键.技能_图标=a.普攻_图标

var 禁用输入=false
@onready var 鼠标左键 = $CanvasLayer/右下/鼠标左键
func _process(_delta: float) -> void:
	if 锁定 or 禁用输入:return
	for i in 切:
		if Input.is_action_just_pressed(i.切换按键):
			切换职业(i)
			break
	if Input.is_action_just_pressed("attack"):
		var a=false
		if  is_on_floor():a=true
		elif not is_on_floor() and 空中只能攻击一次 :
			空中只能攻击一次=false
			a=true
		if a:
			锁定=true
			await  当前职业.普攻()
			锁定=false
	elif 可_闪现==true and Input.is_action_just_pressed("闪现"):
		锁定=true
		await  闪现()
		锁定=false

var 模式:Callable=空
func 空(_delta: float) -> void:pass
var 空中跳=true
var 空中只能攻击一次=true
func _physics_process(delta: float) -> void:
	if 禁用输入:return
	if 模式==空:
		var a=Input.get_axis("左","右")
		if a*图片_方向<0:
			scale.x=-scale.x
			图片_方向=-图片_方向
		velocity.x+=(100*sign(a)-velocity.x)*delta*7

		if not is_on_floor():
			velocity.y+=10*60*delta
			if 空中跳 and Input.is_action_just_pressed("跳"):
				空中跳=false
				velocity.y=-200
		else :
			if velocity.y<0:
				velocity.y+=(0-velocity.x)*delta*7
			else :
				velocity.y=0
			空中只能攻击一次=true
			空中跳=true
			if Input.is_action_just_pressed("跳"):
				velocity.y=-200
		move_and_slide()
	else :
		模式.call(delta)
	
func 闪现_(_delta: float) -> void:
	velocity=Vector2(400*图片_方向,0)
	move_and_slide()

var _金身_注册:Dictionary={} ##用于多个调用
func 金身(名字:String):
	_金身_注册.set(名字,true)
	set_collision_layer_value(2,false)
func 金身_取消(名字:String):
	_金身_注册.erase(名字)
	if _金身_注册.is_empty():
		set_collision_layer_value(2,true)

@onready var 鼠标右键 = $CanvasLayer/右下/鼠标右键
var 可_闪现:bool=true
func 闪现():
	可_闪现=false
	set_physics_process(true)
	模式=闪现_
	金身("闪现")
	await  get_tree().create_timer(0.25).timeout
	金身_取消("闪现")
	模式=空
	鼠标右键.冷却()
	#可_闪现=false
	print(可_闪现)


func _on_move_gravity_by_input_转向() -> void:
	scale.x=-scale.x
	图片_方向=-图片_方向

@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _减血() -> void:
	#if get_collision_layer_value(2):
	金身("减血")
	animation_player.play("受击")
	await animation_player.animation_finished
	金身_取消("减血")

func 受击(a:生物):
	if not get_collision_layer_value(2):return
	生命-=1
	if 生命<=0:
		死亡.emit()
	else :
		受击_攻击方.emit(a)
