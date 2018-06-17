shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform vec4 albedo : hint_color;

uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);

varying vec3 uv1_triplanar_pos;
uniform float uv1_blend_sharpness;
varying vec3 uv1_power_normal;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

uniform vec4 below_water : hint_color;
uniform vec4 low_mountain : hint_color;
uniform vec4 high_mountain : hint_color;
uniform vec4 low_land : hint_color;
uniform vec4 high_land : hint_color;

uniform float water_level;


void vertex() {
	TANGENT = vec3(0.0,0.0,-1.0) * abs(NORMAL.x);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.y);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.z);
	TANGENT = normalize(TANGENT);
	BINORMAL = vec3(0.0,1.0,0.0) * abs(NORMAL.x);
	BINORMAL+= vec3(0.0,0.0,-1.0) * abs(NORMAL.y);
	BINORMAL+= vec3(0.0,1.0,0.0) * abs(NORMAL.z);
	BINORMAL = normalize(BINORMAL);
	uv1_power_normal=pow(abs(NORMAL),vec3(uv1_blend_sharpness));
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
	uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
	
	COLOR = vec4(0.5 * (VERTEX + 1.0), 1.0);
	
	float height = length(COLOR);
	
	float multi = 0.0;
	if(height < 0.1) {
		multi = 10.0;
	}
	else if(height < 0.25) {
		multi = 8.0;
	}
	else if(height < 0.32) {
		multi = 7.5;
	}
	else if(height < 0.37){
		multi = 7.0;
	}
	else {
		multi = 4.0;
	}
	
	VERTEX = VERTEX + normalize(VERTEX) * height / multi;
}


vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	// use model normal to generate height map
	
	vec4 albedo_tex = triplanar_texture(texture_albedo,uv1_power_normal,uv1_triplanar_pos);
	float height = albedo_tex.r;
	
	if(height < 0.23) {
		ALBEDO = below_water.rgb;
	}
	else if(height < 0.25) {
		ALBEDO = low_land.rgb;
	}
	else if(height < 0.28) {
		ALBEDO = high_land.rgb;
	}
	else if(height < 0.30){
		ALBEDO = low_mountain.rgb;
	}
	else {
		ALBEDO = high_mountain.rgb;
	}
	
	if(height < water_level) {
		//ALBEDO = below_water.rgb;
	}
	//color += sea(height);
}
