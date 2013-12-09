
#version 100

float PI = acos(-1.0);

uniform mat4 Projection;
uniform mat4 Modelview;

attribute  vec3 inPosition;
attribute  vec4 inColor;
varying vec4 exColor;

// эти параметры общие для всех фигур
// они меняются из программы
uniform vec2 GRID;// = vec2(256.0);
uniform float T;// = 0.0;

// эти параметры индивидуальны для каждой фигуры
// они тоже меняются из программы
uniform vec4 Color;
uniform float Index;
uniform float Phase;// = 0.0;
uniform float Word;// = 1.0;
uniform float Fade;// = 1.0;
uniform float Spherize;// = 0.96;
uniform mat4 tr;// = mat4(
   /* 1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 0.0);*/

// эти три параметра не меняются из программы
// их нужно задавать здесь в шейдере
uniform float Zoomer;// = 1.23;
uniform float HoldFade;// = 0.15; // [0; 1]
uniform float PointSize;// = 1.19;


vec2 r2d(vec2 x, float a)
{
    a *= PI * 2.0;
    return vec2( cos(a)*x.x + sin(a)*x.y, cos(a)*x.y - sin(a)*x.x );
}

float mx(vec3 x) {
    return max( x.x, max(x.y, x.z) );
}


void main(void)
{
    /*Zoomer = 1.23;
    HoldFade = 0.15;
    PointSize = 0.4;*/
    
    vec2 ip = inPosition.xy;
    vec4 vp = vec4(inPosition, 1.0);
    
    /*if( Fade == 0.0 ) {
        gl_PointSize = 0.0;
        gl_Position = vec4(8.0, 8.0, 8.0, 0.0);
        return;
    }*/
    vec2 uv = vec2(0.5 * 0.99 * (vp.x / GRID.x - 0.5), vp.y / GRID.y - 0.5);
    vp.xz = r2d(vec2(0.0, 1.0), uv.x);
    vp.yz = r2d(vec2(0.0, vp.z), uv.y);

    vec3 p = vp.xyz * 0.5;
    vec3 pv = vec3(0.1, 0.7, 0.0);

    for(float i = 0.0; i < min(50.0, Index) + 3.0; i+=1.0)
    {
        p = (tr * vec4(p.xyz, 1)).xyz;
        p -= pv;
        p += sin(p.yzx * 6.0 + Phase * 0.2 + T * 0.05) * 0.1;
        p += pv;
    }
    p *= pow(Word + 0.001, (0.2 - Fade*0.04) * Zoomer) * clamp(pow(Word, 0.5) * 9.0 - Zoomer*length(sin( p*3.0 - 5.4/length(p) + T + Index*vec3(5,6,7) )), 0.0, 1.0);
    p.xyz = normalize(p.xyz) * pow(length(p.xyz) * 2.0, 1.0 - Spherize) * 0.5;
    vp.xyz = p;
    //vp = Modelview * vp; //gl_ModelViewProjectionMatrix * vp;
    vp = Projection * Modelview * vp;

    float ps = 3.0 * pow( 2.0, sin(Phase + uv.x * PI * 2.0 * 3.0) );
    ps = min(228.0, ps * PointSize * Projection[1][1] / vp.w); //gl_ProjectionMatrix[1][1] / vp.w);

    float fd = smoothstep(0.0, max(0.00001, 1.0 - HoldFade), Fade);
    fd = pow( fd, pow(2.0, sin(T * 0.3 * (18.0 + Index) + ip.x * 0.1)) );

    vec4 vc = vec4(fd);
    ps *= clamp(fd * 4.0, 0.0, 1.0);
    vc *= clamp(ps, 0.0, 1.0);

    gl_PointSize = ps;
    gl_Position = vp;
    exColor = vc;
}