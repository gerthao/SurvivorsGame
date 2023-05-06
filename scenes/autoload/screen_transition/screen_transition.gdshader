shader_type canvas_item;

uniform vec4 transition_color: source_color;
uniform sampler2D transtion_texture: filter_nearest;
uniform float percent: hint_range(0.0, 1.0, 0.1);

void fragment() {
	vec4 transtion_texture_color = texture(transtion_texture, UV);
	
	if (transtion_texture_color.r > percent) {
		COLOR.a = 0.0;
	} else {
		COLOR = transition_color;
	}
}
