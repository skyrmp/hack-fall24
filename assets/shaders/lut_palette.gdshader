shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen: hint_screen_texture, source_color;
uniform sampler2D lut: source_color;
uniform float divisor: hint_range(1.0, 255.0, 1.0) = 32.0;

void fragment() {
	float current_a = COLOR.a;

	vec3 old_color = texture(screen, SCREEN_UV).rgb;
	vec3 index = round(old_color * divisor);
	vec2 position = vec2(index.r + (index.b * (divisor + 1.0)), index.g);
	ivec2 iposition = ivec2(position);

	COLOR = texelFetch(lut, iposition, 0);

	COLOR.a = current_a;
}