## Singley-Linked List
extends Node

# Link Constructor
static func create_link() -> Link:
	return Link.new()

# List Constructor
static func create_list() -> List:
	return List.new()

# Link
class Link extends Object:
	var id: int = -1
	var owner: List = null
	var object: Variant = null
	var prev : Link = null
	var next : Link = null
	

# List
class List extends Object:
	# Global variables
	#static var _num_of_lists: int = 0
	#static var _list_links: Array[Link] = []
	#static var _trash: Link = null
	
	# Instantiated variables
	var head: Link = null
	var size: int = 0
	
	# Methods
	func get_size() -> int:
		return size
	
	func push_front(_object: Variant) -> void:
		#var _link: Link = _new_list_object(_object)
		pass
