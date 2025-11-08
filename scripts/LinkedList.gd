## Singley Linked List
class_name LinkedList extends Node


# LIST #########################################################################
## A higher level storage class for usage similar to an Array
## 
## Lists are higher level structures that holds a reference to a _head Link
## to represent the first item in a linked list and a size to tell the user
## how many items are currently in the list.
## Adding and removing links should to be handled via the provided functions.
class List extends Object:
	# Private: *****************************************************************
	## This should not be edited externally, i.e. outside of the class itself
	var _head: Link = null
	## This should not be edited externally, i.e. outside of the class itself
	var _size: int = 0
	
	# Public: ******************************************************************
	## Gets the current size of the list
	func get_size() -> int:
		return _size
	
	
	## Gets the current head of the list
	func get_head() -> Link:
		return _head
	
	
	## Adds a Link to the list at the head holding a reference to the provided
	## object and a next referencing the old head
	func add_to_head(object: Object) -> void:
		var link: Link = Link.new()
		link.set_object(object)
		link.set_next_link(_head)
		_head = link
		_size += 1
	
	
	## Removes the current head of the list. Returns the original head if one
	## existed, otherwise returns null
	func remove_from_head() -> Link:
		var tmp_link = _head
		_head = _head.get_next()
		return tmp_link
	
	func print_list() -> void:
		var curr: Link = get_head()
		while (curr):
			print(curr.get_object())
			curr = curr.get_next()


# LINK #########################################################################
## A helper class for Lists to reference in a chain
##
## All links contain an Object and a next Link, both initialized to null.
## Setting and removing objects or links should be handled via the proivided
## functions.
class Link extends Object:
	# Private: *****************************************************************
	var _object: Object = null
	var _next: Link = null
	
	# Public: ******************************************************************
	## Gets the object current held by this Link
	func get_object() -> Object:
		return _object
	
	## Gets the next Link pointed at by this Link
	func get_next() -> Link:
		return _next
	
	## Sets the object to be held by this link. Returns the original object
	## if it was already holding a reference to one, otherwise returns null
	func set_object(object: Object) -> Object:
		var tmp_obj: Object = _object
		_object = object
		return tmp_obj
	
	## Sets the next to be Link held by this Link. Returns the original next
	## if it was already holding a reference to one, otherwise returns null
	## 
	## Should not be used to create a Linked List. Instead, see List.
	func set_next_link(link: Link) -> Link:
		var tmp_link: Link = _next
		_next = link
		return tmp_link
	
	## Sets the next to be object held by this Link's next. Returns the original
	## next if it was already holding a reference to one, otherwise returns null
	## 
	## Should not be used to create a Linked List. Instead, see List.
	func set_next(object: Object) -> Link:
		var new_link: Link = Link.new()
		new_link.set_object(object)
		return null
	
	## Removes the object held by this link. Returns the object if it exists,
	## otherwise returns null
	func remove_object() -> Object:
		var tmp_obj: Object = _object
		_object = null
		return tmp_obj

## Constructors
func create_link(object: Object) -> Link:
	var link: Link = Link.new().set_object(object)
	return link
