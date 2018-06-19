shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;


void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	VERTEX = VERTEX + NORMAL * ( sin(TIME + VERTEX.y*10.0 + VERTEX.x*10.0 + VERTEX.z*10.0) - 1.0) * 0.0004;
}

void fragment() {
	vec2 base_uv = UV;
	ALBEDO = albedo.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = albedo.a;
}
