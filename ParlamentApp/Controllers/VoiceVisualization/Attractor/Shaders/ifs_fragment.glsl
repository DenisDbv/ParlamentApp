
//#version 100

precision highp float;

varying vec4 exColor;

uniform vec4 Color;
//varying lowp vec4 color;
uniform float Index;
float SpriteSmooth;// = 0.1; // [0; 1]


void main(void)
{
    SpriteSmooth = 0.1;
    
    float g = length(gl_PointCoord.xy - 0.5);
    if( g > 0.5 ) discard;

    vec4 c = exColor * (vec4(1.0) - Color);
    float a = smoothstep( 0.5, 0.5 * (1.0 - SpriteSmooth) - 0.0001, g );
    c = mix(vec4(0.0), c, a);
    c.a = 0.0;

    gl_FragColor = c * 2.0;
}