uniform sampler2D tex0;
uniform sampler2D tex1;
uniform vec2 resolution;
varying vec2 tcoord;
varying vec4 color;
uniform float time;



const float INTENSITY = 0.0;


//RADIUS of our vignette, where 0.5 results in a circle fitting the screen
const float RADIUS = 0.75;

//softness of our vignette, between 0.0 and 1.0
const float SOFTNESS = 0.45;

//sepia colour, adjust to taste
const vec3 SEPIA = vec3(1.2, 1.0, 0.8); 



vec3 blendOverlay(vec3 base, vec3 blend) {
    return mix(1.0 - 2.0 * (1.0 - base) * (1.0 - blend), 2.0 * base * blend, step(base, vec3(0.5)));
}

vec3 RGBsampleSplit(sampler2D tex, vec2 coord)
{
	vec3 frag;
	frag.r = texture2D(tex, vec2((coord.x -(0.008*INTENSITY)+0.006) - (0.0005* sin(time)), coord.y)).r;
	frag.g = texture2D(tex, vec2(coord.x                          , coord.y)).g;
	frag.b = texture2D(tex, vec2((coord.x +(0.008*INTENSITY)-0.006) + (0.0005* sin(time)), coord.y)).b;

	return mix(frag,texture2D(tex,coord).rgb,0.5);
}



void main() {


    vec4 texcolor = vec4(RGBsampleSplit(tex0, tcoord),1.); //our program output
    // vec3 texcolor1 = RGBsampleSplit(tex1, tcoord); //our texture
    
    // vec4 texcolor = texture2D(tex0, tcoord).rgba; //our texture
    vec3 texcolor1 = texture2D(tex1, tcoord).rgb; //our overlay texture

    //texture overlay
    vec3 color = blendOverlay(texcolor.rgb, texcolor1.rgb);// blend mode

    vec4 texColor = vec4(color, texcolor.a);
    //1. VIGNETTE

    //determine center position
    vec2 position = (gl_FragCoord.xy / resolution.xy) - vec2(0.5);

    //determine the vector length of the center position
    float len = length(position);

    //use smoothstep to create a smooth vignette
    float vignette = smoothstep(RADIUS, RADIUS-SOFTNESS, len);

    //apply the vignette with 50% opacity
    texColor.rgb = mix(texColor.rgb, texColor.rgb * vignette, 0.5);


    gl_FragColor = texColor;

    // gl_FragColor = color * texcolor;
}