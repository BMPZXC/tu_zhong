extends CharacterBody2D
class_name 生物

signal 生命_
@export var 生命_上线:int=1
@onready var 生命:int=生命_上线:
	set(a):
		生命=a
		生命_.emit()
##用于击退
@export var 质量:float=1  

signal 死亡
signal 受击_攻击方(生物)
func 受击(a:生物):
	生命-=1
	if 生命<=0:
		死亡.emit()
	else :
		受击_攻击方.emit(a)
		
