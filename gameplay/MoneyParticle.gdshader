shader_type particles;

uniform vec3 destination;

float random(float x) {
	return fract(sin(x)*100000.0);
}

void start() {
	TRANSFORM = EMISSION_TRANSFORM;
	TRANSFORM[0].x = 1.0;
	TRANSFORM[1].y = 1.0;
	
	vec3 start_velocity = vec3(0.0);
	start_velocity.x = (random(TIME + float(NUMBER)) - 0.5) * 2.0 * 500.0;
	start_velocity.y = (random(TIME + float(NUMBER)+ 1.0) - 0.5) * 2.0 * 500.0;
	VELOCITY = start_velocity; 
	
	CUSTOM.x = 0.0;
}

void process() {
	CUSTOM.x += DELTA;
	if (CUSTOM.x < LIFETIME / 2.0) {
		VELOCITY = VELOCITY * .85;
	}
	else {
		vec3 target_velocity = (destination - TRANSFORM[3].xyz) / vec3(tan((LIFETIME - CUSTOM.x) / (LIFETIME)));
		VELOCITY = target_velocity;
		
		float target_scale_factor = (LIFETIME - CUSTOM.x) / (LIFETIME / 2.0);
		TRANSFORM[0].x = target_scale_factor;
		TRANSFORM[1].y = target_scale_factor;
		
		if (distance(destination, TRANSFORM[3].xyz) < 16.0) {
			ACTIVE = false;
		}
	}
}

