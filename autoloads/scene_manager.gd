extends Node

## Preloaded transitions (as PackedScene) for use with transition_to_scene
const transitions: Dictionary = {
	
}


## Replace old_scene in-place by the scene at filepath new_scene_path
## Sets properties of new scene based on init_args
## e.g. swap_scene(old_scene, new_scene_path, {&"global_position": old_scene.global_position})
func swap_scene(old_scene: Node, new_scene_path: String, init_args: Dictionary= {}) -> Node:
	
	# Get info of old scene
	var parent: Node = old_scene.get_parent()
	var index: int = old_scene.get_index()
	
	# Create and initialize new scene
	var NewScene: PackedScene = load(new_scene_path)
	var new_scene: Node = NewScene.instantiate()
	for key in init_args:
		new_scene.set(key, init_args[key])
	
	# Swap the scenes in the scene tree
	old_scene.queue_free()
	parent.remove_child(old_scene)
	parent.add_child(new_scene)
	parent.move_child(new_scene, index)
	
	return new_scene


## Similar to swap_scene, but uses threaded loading and a screen transition.
## Setting old_scene to null defaults to get_tree().current_scene
## NOTE: Processing of old_scene is not automatically paused during transition
## WARNING: Calling twice on the same old_scene will break this
func transition_to_scene(old_scene: Node, new_scene_path: String, transition_packed: PackedScene, init_args: Dictionary = {}) -> Node:
	
	# Set fallback case
	if not old_scene:
		old_scene = get_tree().current_scene
	
	# Get info of old scene
	var parent: Node = old_scene.get_parent()
	var index: int = old_scene.get_index()
	
	# Start loading new scene
	ResourceLoader.load_threaded_request(new_scene_path)
	
	# Create and begin transition
	var transition: Transition = transition_packed.instantiate()
	parent.add_child(transition)
	transition.transition_in()
	
	# Wait for transition at midpoint and loading complete
	await transition.screen_hidden
	while ResourceLoader.load_threaded_get_status(new_scene_path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	assert(ResourceLoader.load_threaded_get_status(new_scene_path) == ResourceLoader.THREAD_LOAD_LOADED)
	
	# Create and initialize new scene
	var NewScene: PackedScene = ResourceLoader.load_threaded_get(new_scene_path)
	var new_scene: Node = NewScene.instantiate()
	for key in init_args:
		new_scene.set(key, init_args[key])
	
	# Swap the scenes in the scene tree
	old_scene.queue_free()
	parent.remove_child(old_scene)
	parent.add_child(new_scene)
	parent.move_child(new_scene, index)
	
	# End transition
	transition.transition_out()
	await transition.ended
	transition.queue_free()
	
	return new_scene
