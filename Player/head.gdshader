shader_type canvas_item;
render_mode blend_mix;

uniform bool reverse = false;
uniform bool disable = false;

void fragment() { 
	vec4 c = texture(TEXTURE, UV); 
	vec3 rgb = reverse ? (1.0 - c.rgb) : c.rgb;
	rgb = disable ? (rgb * 0.3) : rgb;
	COLOR = vec4(rgb, c.a);
}
