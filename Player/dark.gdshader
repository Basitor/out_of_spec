shader_type canvas_item;

uniform float radius = 0.4;
uniform float softness = 0.2;
uniform vec4 color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec2 uv = UV - vec2(0.5);
	float dist = length(uv);

	float alpha = 1.0 - smoothstep(radius, radius - softness, dist);
	COLOR = vec4(color.rgb, alpha * color.a);
}
