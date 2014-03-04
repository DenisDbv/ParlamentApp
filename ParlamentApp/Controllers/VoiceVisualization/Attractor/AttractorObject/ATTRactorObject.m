//
//  ATTRactorObject.m
//  AttractorParlamenta
//
//  Created by DenisDbv on 03.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "ATTRactorObject.h"

#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES2/glext.h>

#include <stdlib.h>
#include <memory.h>
#include <math.h>

#define attractor_random(smallNumber, bigNumber) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (bigNumber - smallNumber)) + smallNumber)
#define round_tr(attractorRandomNumber) (floorf(attractorRandomNumber * 10)/10)

#define path_random ((arc4random() % 2 ? 0.01 : -0.01))

#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

#define MIN_ATTRACTOR_LINE  0.8f //0.7f
#define MAX_ATTRACTOR_LINE  1.2f //1.4f

#define NEAR_DELTA  0.01f

@interface ATTRactorObject()

@end

@implementation ATTRactorObject
{
    float dAt0, dAt5, dAt10;
    
    BOOL lastWasFarNoice;
    float limMinNearAt0, limMaxNearAt0;
    float limMinNearAt5, limMaxNearAt5;
    float limMinNearAt10, limMaxNearAt10;
    
    NSTimer *_timer;
}
@synthesize g_side, index, fade, phase, word, spherize, zoomer, holdFade, pointSize;
@synthesize g_cbo, g_vbo;
@synthesize tr0 = _tr0, tr5 = _tr5, tr10 = _tr10;
@synthesize dTime;

-(id) init
{
    self = [super init];
    if(self)
    {
        [self initialize];
        
        [self createVertexAndColorMatrix];
    }
    
    return self;
}

-(id) initWithSide:(NSInteger)sideCount
{
    self = [super init];
    if(self)
    {
        [self initialize];
        
        g_side = sideCount;
        
        [self createVertexAndColorMatrix];
    }
    
    return self;
}

- (void) startTimer
{
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                  target:self
                                                selector:@selector(_timerFired)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void) stopTimer
{
    if (_timer != nil)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)_timerFired
{
    self.fade -= 0.01;
    
    if(self.fade <= 0.2)
        [self stopTimer];
}

-(float*) trArray
{
    return tr;
}

-(float*) colorArray
{
    return color;
}

-(void) attractorNoiceFar
{
    /*float tr0_new = CLAMP(_tr0 + path_random, MIN_ATTRACTOR_LINE, MAX_ATTRACTOR_LINE);
    float tr5_new = CLAMP(_tr5 + path_random, 0.9, 1.1);
    float tr10_new = CLAMP(_tr10 + path_random, MIN_ATTRACTOR_LINE, MAX_ATTRACTOR_LINE);
    
    [self setTr0:tr0_new];
    [self setTr5:tr5_new];
    [self setTr10:tr10_new];*/
    
    float tr0_new = CLAMP(_tr0 + dAt0, MIN_ATTRACTOR_LINE, MAX_ATTRACTOR_LINE);
    float tr5_new = CLAMP(_tr5 + dAt5, 0.9, 1.1);
    float tr10_new = CLAMP(_tr10 + dAt10, MIN_ATTRACTOR_LINE, MAX_ATTRACTOR_LINE);
    
    if(tr0_new >= MAX_ATTRACTOR_LINE || tr0_new <= MIN_ATTRACTOR_LINE) dAt0 *= -1;
    if(tr5_new >= 1.1 || tr5_new <= 0.9) dAt5 *= -1;
    if(tr10_new >= MAX_ATTRACTOR_LINE || tr10_new <= MIN_ATTRACTOR_LINE) dAt10 *= -1;
    
    [self setTr0:tr0_new];
    [self setTr5:tr5_new];
    [self setTr10:tr10_new];
    
    //lastWasFarNoice = YES;
}

-(void) attractorNoiceNear
{
    /*if(lastWasFarNoice) {
        limMinNearAt0 = _tr0 - NEAR_DELTA;
        limMaxNearAt0 = _tr0 + NEAR_DELTA;
        limMinNearAt5 = _tr5 - NEAR_DELTA;
        limMaxNearAt5 = _tr5 + NEAR_DELTA;
        limMinNearAt10 = _tr10 - NEAR_DELTA;
        limMaxNearAt10 = _tr10 + NEAR_DELTA;
        lastWasFarNoice = NO;
    }
    
    float tr0_new = CLAMP(_tr0 + dAt0, limMinNearAt0, limMaxNearAt0);
    //float tr5_new = CLAMP(_tr5 + dAt5, 0.9, 1.1);
    float tr10_new = CLAMP(_tr10 + dAt10, limMinNearAt10, limMaxNearAt10);
    
    if(tr0_new >= limMaxNearAt0 || tr0_new <= limMinNearAt0) dAt0 *= -1;
    //if(tr5_new >= 1.1 || tr5_new <= 0.9) dAt5 *= -1;
    if(tr10_new >= limMaxNearAt10 || tr10_new <= limMinNearAt10) dAt10 *= -1;
    
    [self setTr0:tr0_new];
    //[self setTr5:tr5_new];
    [self setTr10:tr10_new];*/
    
}

-(void) setHueColor:(CGFloat)hueColor
{
    // Width parameter from RandomSpread object in VVVV
    float randomWidth = 0.05f;
    
    // hsv color [0.53, 0.18, 0.96]
    float hue = hueColor;
    float hsvColor[] = { 0, 0.18f, 0.96f };
    
    hsvColor[0] = _randomInRadius(hue, randomWidth / 2.0f);
    _hsv2rgb(hsvColor, color);
    color[3] = 0.01f;
}

-(void) setRGBColor:(CGFloat*)component
{
    color[0] = component[0];
    color[1] = component[1];
    color[2] = component[2];
}

-(void) setTr0:(float)trZero
{
    _tr0 = trZero;
    tr[0] = _tr0;
}

-(void) setTr5:(float)trFive
{
    _tr5 = trFive;
    tr[5] = _tr5;
}

-(void) setTr10:(float)trTen
{
    _tr10 = trTen;
    tr[10] = _tr10;
}

-(float) tr0
{
    return _tr0;
}

-(float) tr5
{
    return _tr5;
}

-(float) tr10
{
    return _tr10;
}

-(void) initialize
{
    g_side = 256;
    
    _tr0 = round_tr(attractor_random(MIN_ATTRACTOR_LINE, MAX_ATTRACTOR_LINE));
    _tr5 = 1.0f;
    _tr10 = round_tr(attractor_random(MIN_ATTRACTOR_LINE, MAX_ATTRACTOR_LINE));
    
    dAt0 = path_random;
    dAt5 = path_random;
    dAt10 = path_random;
    
    dTime = 1.0f;
    
    limMinNearAt0 = _tr0 - 1.0;
    limMaxNearAt0 = _tr0 + 1.0;
    limMinNearAt5 = _tr5 - 1.0;
    limMaxNearAt5 = _tr5 + 1.0;
    limMinNearAt10 = _tr10 - 1.0;
    limMaxNearAt10 = _tr10 + 1.0;
    
    float trDef[16] = {
        _tr0, 0.0f, 0.0f, 0.0f,
        0.0f, _tr5, 0.0f, 0.0f,
        0.0f, 0.0f, _tr10, 0.0f,
        0.0f, 0.0f, 0.0f, 0.0f,
    };
    
    // Width parameter from RandomSpread object in VVVV
    float randomWidth = 0.05f;
    
    // hsv color [0.53, 0.18, 0.96]
    float hue = 0.53f;
    float hsvColor[] = { 0.53f, 0.18f, 0.96f }; //{0.99, 1.0f, 0.75f};   //0.51 //1.0f - даст светло синий как в картинке
    
    //hsvColor[0] = _randomInRadius(hue, randomWidth / 2.0f);
    _hsv2rgb(hsvColor, color);
    NSLog(@"==> %f %f %f", color[0], color[1], color[2]);
    /*color[0] = 1.0;
    color[1] = 1.0;
    color[2] = 1.0;*/
    //color[3] = 0.01f;
    fade = 1.0f;
    phase = 0.0f;
    word = 1.0f;
    spherize = 0.96f;

    /*UIColor *colorMetal = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shiny-metal-background.jpg"]];
    CGFloat components[3];
    [self getRGBComponents:components forColor:colorMetal];
    color[0] = components[0];
    color[1] = components[1];
    color[2] = components[2];
    color[3] = components[3];*/
    
    /*color[0] = 1.0;
    color[1] = 0.0;
    color[2] = 0.0;
    color[3] = 1.0;*/
    
    zoomer = 1.23;
    holdFade = 0.15;
    pointSize = 1.0;
    
    memcpy(tr, trDef, sizeof(trDef));
    
    //[self startTimer];
}

- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

-(void) createVertexAndColorMatrix
{
    [self CreateVertexBuffer];
    [self CreateColorBuffer];
}

float _clamp(float value, float min, float max) {
	return value < min ? min : (value > max ? max : value);
}


// found it here http://stackoverflow.com/a/8208967/2944735
void _hsv2rgb(const float* hsv, float* rgb)
{
	float h = hsv[0] * 6;
	float f = h - floorf(h);
	float p = hsv[2] * (1 - hsv[1]);
	float q = hsv[2] * (1 - f * hsv[1]);
	float t = hsv[2] * (1 - (1 - f) * hsv[1]);
    
	if( h < 1 ) {
		rgb[0] = hsv[2];
		rgb[1] = t;
		rgb[2] = p;
	}
	else if( h < 2 ) {
		rgb[0] = q;
		rgb[1] = hsv[2];
		rgb[2] = p;
	}
	else if( h < 3 ) {
		rgb[0] = p;
		rgb[1] = hsv[2];
		rgb[2] = t;
	}
	else if( h < 4 ) {
		rgb[0] = p;
		rgb[1] = q;
		rgb[2] = hsv[2];
	}
	else if( h < 5 ) {
		rgb[0] = t;
		rgb[1] = p;
		rgb[2] = hsv[2];
	}
	else {
		rgb[0] = hsv[2];
		rgb[1] = p;
		rgb[2] = q;
	}
}


float _randomInRadius(float center, float radius)
{
	return center + (float)rand() / RAND_MAX * radius * 2 - radius;
}

-(void) attractorInfo
{
    NSLog(@"tr0:%f tr5:%f tr10:%f", _tr0, _tr5, _tr10);
}

//
// Функция CreateColorBuffer нужна на случай задания
// цвета каждой точки в отдельности.
//
-(void) CreateColorBuffer
{
	int i, j;
	int bufSize = sizeof(float)* 4 * g_side * g_side;
	float* data = (float*)malloc(bufSize);
    
	for( i = 0; i < g_side; i++ )
        for( j = 0; j < g_side; j++ )
        {
            data[(j * g_side + i) * 4 + 0] = 1.0f;
            data[(j * g_side + i) * 4 + 1] = 1.0f;
            data[(j * g_side + i) * 4 + 2] = 1.0f;
            data[(j * g_side + i) * 4 + 3] = 1.0f;
        }
    
	glGenBuffers(1, &g_cbo);
	glBindBuffer(GL_ARRAY_BUFFER, g_cbo);
	glBufferData(GL_ARRAY_BUFFER, bufSize, data, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
    
	free(data);
}

-(void) CreateVertexBuffer
{
	int i, j;
	int bufSize = sizeof(float)* 3 * g_side * g_side;
	float* data = (float*)malloc(bufSize);
    
	for( i = 0; i < g_side; i++ )
        for( j = 0; j < g_side; j++ )
        {
            data[(j * g_side + i) * 3 + 0] = (float)i; // x
            data[(j * g_side + i) * 3 + 1] = (float)j; // y
            data[(j * g_side + i) * 3 + 2] = 0.0f;     // z
        }
    
	glGenBuffers(1, &g_vbo);
	glBindBuffer(GL_ARRAY_BUFFER, g_vbo);
	glBufferData(GL_ARRAY_BUFFER, bufSize, data, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
    
	free(data);
}

@end
