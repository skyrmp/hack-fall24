shader_type canvas_item;

global uniform vec4 dirt: source_color;
global uniform vec4 dirt_detail: source_color;
global uniform vec4 grass_inner: source_color;
global uniform vec4 grass_outer: source_color;
global uniform vec4 replace_dirt: source_color;
global uniform vec4 replace_dirt_detail: source_color;
global uniform vec4 replace_grass_inner: source_color;
global uniform vec4 replace_grass_outer: source_color;


vec4 swap_color(vec4 color) {
	vec4 original_colors[4] = vec4[4] (dirt, dirt_detail, grass_inner, grass_outer);
	vec4 replace_colors[4] = vec4[4] (replace_dirt, replace_dirt_detail, replace_grass_inner, replace_grass_outer);
	for (int i = 0; i < 4; i++) {
		if (distance(color, original_colors[i]) <= 0.1) {
			return replace_colors[i];
		}
	}
	return color;
}


void fragment() {
	COLOR = swap_color(texture(TEXTURE, UV));
}