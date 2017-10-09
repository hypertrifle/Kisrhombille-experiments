precision mediump float; // or lowp

uniform sampler2D tex0;
uniform sampler2D tex1;
uniform vec2 resolution;
varying vec2 tcoord;
varying vec4 color;
uniform float time;


//RADIUS of our vignette, where 0.5 results in a circle fitting the screen
const float RADIUS = 0.75;

//softness of our vignette, between 0.0 and 1.0
const float SOFTNESS = 0.45;

vec3 blendOverlay(vec3 base, vec3 blend) {
    return mix(1.0 - 2.0 * (1.0 - base) * (1.0 - blend), 2.0 * base * blend, step(base, vec3(0.5)));
}


void main() {

    vec4 col = color;
     float gradient = (tcoord.x+tcoord.y)/2.;
     vec4 gradColor = mix(col,vec4(0,0,0,1),gradient); 

    vec4 textureColor = texture2D(tex0, tcoord).rgba; //our texture


    //texture overlay
    vec3 color = blendOverlay(gradColor.rgb, textureColor.rgb);// blend mode

    vec4 texColor = vec4(color, 1.);


    //1. VIGNETTE

    //determine center position
    vec2 position = (gl_FragCoord.xy / resolution.xy) - vec2(0.5);

    //determine the vector length of the center position
    float len = length(position);

    //use smoothstep to create a smooth vignette
    float vignette = smoothstep(RADIUS, RADIUS-SOFTNESS, len);

    //apply the vignette with 50% opacity
    texColor.rgb = mix(texColor.rgb, texColor.rgb * vignette, .5);

    gl_FragColor = texColor;
    
}