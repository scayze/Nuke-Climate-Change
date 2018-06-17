shader_type spatial;
render_mode cull_disabled;

uniform vec4 low : hint_color;
uniform vec4 mid : hint_color;
uniform vec4 high : hint_color;

vec3 random3(vec3 c) 
{
    float j = 4096.0 * sin(dot(c,vec3(17.0, 59.4, 15.0)));
    vec3 r;
    r.z = fract(512.0 * j);
    j *= 0.125;
    r.x = fract(512.0 * j);
    j *= 0.125;
    r.y = fract(512.0 * j);
    return r - 0.5;
}

float simplex_noise(vec3 p) 
{
    vec3 s = floor(p + dot(p, vec3(0.3333333)));
    vec3 x = p - s + dot(s, vec3(0.1666667));

    vec3 e = step(vec3(0.0), x - x.yzx);
    vec3 i1 = e * (1.0 - e.zxy);
    vec3 i2 = 1.0 - e.zxy * (1.0 - e);

    vec3 x1 = x - i1 + 0.1666667;
    vec3 x2 = x - i2 + 2.0 * 0.1666667;
    vec3 x3 = x - 1.0 + 3.0 * 0.1666667;

    vec4 w, d;

    w.x = dot(x, x);
    w.y = dot(x1, x1);
    w.z = dot(x2, x2);
    w.w = dot(x3, x3);

    w = max(0.6 - w, vec4(0.0));

    d.x = dot(random3(s), x);
    d.y = dot(random3(s + i1), x1);
    d.z = dot(random3(s + i2), x2);
    d.w = dot(random3(s + 1.0), x3);

    w *= w;
    w *= w;
    d *= w;

    return dot(d, vec4(52.0));
}

float height_map(in vec3 position)
{
	return simplex_noise(position)
		+ simplex_noise(2.0 * position) / 2.0 
		+ simplex_noise(4.0 * position) / 4.0
		+ simplex_noise(8.0 * position) / 8.0
		+ simplex_noise(16.0 * position) / 16.0
		+ simplex_noise(32.0 * position) / 32.0;
}

void vertex()
{
	// store model normal(not transformed) to color
	COLOR = vec4(0.5 * (VERTEX + 1.0), 1.0);
	float height = height_map(COLOR.rgb);
	
	float multi = 0.0;
	if(height < 0.1) {
		multi = 10.0;
	}
	else if(height < 0.25) {
		multi = 8.0;
	}
	else {
		multi = 7.5;
	}
}

vec4 cloud(in vec3 position, in float time)
{
	float height = clamp(height_map(position * 3.0 + time / 20.0), 0.0, 1.0) * 0.9;
	
	return vec4(height, height, height, height);
}

void fragment()
{
	// use model normal to generate height map
	float height = clamp(height_map(COLOR.xyz * 3.0 + TIME / 50.0), 0.0, 1.0) * 0.9;
	
	if(height > 0.4) {
		ALBEDO = high.rgb;
		ALPHA = high.a;
	}
	else if(height > 0.3) {
		ALBEDO = mid.rgb;
		ALPHA = mid.a;
	}
	else if(height > 0.2) {
		ALBEDO = low.rgb;
		ALPHA = low.a;
	}
	else {
		ALBEDO = vec3(0,0,0);
		ALPHA = 0.0;
	}
}