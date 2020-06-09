shader_type canvas_item;

uniform float u_offset; 

void fragment() {
	COLOR = texture(TEXTURE, vec2(UV.x + u_offset, UV.y));
	
}