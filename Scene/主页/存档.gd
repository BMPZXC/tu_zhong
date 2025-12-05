extends RefCounted
class_name 存档

const 路径="user://save.cfg"

static  func 读取_剧情进度()->int:
	var a= ConfigFile.new()
	a.load(路径)
	return a.get_value("存档","剧情进度",0)
	
static  func 存储_剧情进度(q:int)->bool:
	var a= ConfigFile.new()
	a.load(路径)
	if a.get_value("存档","剧情进度",0)>=q:return false
	a.set_value("存档","剧情进度",q)
	a.save(路径)
	return true
