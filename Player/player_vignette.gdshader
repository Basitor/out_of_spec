shader_type canvas_item;

uniform float radius = 0.5;
uniform float softness = 0.4;
uniform vec4 color = vec4(0, 0, 0, 1);

void fragment() {
	float dist = abs(UV.y - 0.5);
	float alpha = smoothstep(radius, radius - softness, dist);
	COLOR = vec4(color.rgb, 1.0 - alpha * color.a);
}
