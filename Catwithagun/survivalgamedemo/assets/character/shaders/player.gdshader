shader_type canvas_item;

uniform float width : hint_range(0.0, 15.0);
uniform vec4 outline_color : source_color ;
uniform bool flash = false;
uniform vec4 flash_color : source_color;

void fragment()
{
	float size = width * 1.0 / float(textureSize(TEXTURE,0).x);
	vec4 sprite = texture(TEXTURE,UV);
	float alpha = -4.0 * sprite.a;
	if (flash == true)
	{
		COLOR = mix(sprite,flash_color,flash_color.a) * sprite.a;
	}
	else
	{
	alpha += texture(TEXTURE,UV + vec2(size,0.0)).a;
	alpha += texture(TEXTURE,UV + vec2(-size,0.0)).a;
	alpha += texture(TEXTURE,UV + vec2(0.0,size)).a;
	alpha += texture(TEXTURE,UV + vec2(0.0,-size)).a;

	vec4 final = mix(sprite,outline_color,clamp(alpha,0.0,1.0));
	COLOR = vec4(final.rgb,clamp(abs(alpha)+sprite.a,0.0,1.0));
	}
}
