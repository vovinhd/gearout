shader_type canvas_item;

uniform float v_offset; 

void fragment() {
	COLOR = texture(TEXTURE, vec2(UV.x, UV.y + v_offset));
	
}