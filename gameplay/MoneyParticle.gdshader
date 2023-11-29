shader_type particles;

uniform vec3 destination;

float random(float x) {
	return fract(sin(x)*100000.0);
}

void start() {
	TRANSFORM = EMISSION_TRANSFORM;
	vec3 start_velocity = vec3(0.0);
	start_velocity.x = (random(TIME + float(NUMBER)) - 0.5) * 2.0 * 1000.0;
	start_velocity.y = (random(TIME + float(NUMBER)+ 1.0) - 0.5) * 2.0 * 1000.0;
	VELOCITY = start_velocity; 
	
	CUSTOM.x = 0.0;
}

void process() {
	CUSTOM.x += DELTA;
	if (CUSTOM.x < LIFETIME / 2.0) {
		VELOCITY = VELOCITY * .85;
	}
	else {
		vec3 target_velocity = (destination - TRANSFORM[3].xyz) / vec3(tan(LIFETIME - CUSTOM.x) / (LIFETIME)) * 2.0;
		VELOCITY = target_velocity;
		
		if (distance(destination, TRANSFORM[3].xyz) < 32.0) {
			ACTIVE = false;
		}
	}
}

