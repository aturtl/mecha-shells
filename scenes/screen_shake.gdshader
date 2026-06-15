shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable;

uniform float intensity : hint_range(0.0, 50.0, 0.1) = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 displaced = texture(screen_texture, SCREEN_UV+(.01*vec2(sin(TIME*intensity),cos(TIME*intensity))));
	COLOR = displaced;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
