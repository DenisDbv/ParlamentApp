//
//  ATTRactorObject.h
//  AttractorParlamenta
//
//  Created by DenisDbv on 03.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ATTRactorObject : NSObject
{
    
    int g_side;
    float fade;
    float phase;
    float word;
    float spherize;
    float zoomer;
    float holdFade;
    float pointSize;
    float color[4];
    float tr[16];
    
    GLuint g_vbo;
    GLuint g_cbo;
}

@property (nonatomic) int g_side;
@property (nonatomic) int index;
@property (nonatomic) float fade;
@property (nonatomic) float phase;
@property (nonatomic) float word;
@property (nonatomic) float spherize;
@property (nonatomic) float zoomer;
@property (nonatomic) float holdFade;
@property (nonatomic) float pointSize;

@property (nonatomic) GLuint g_vbo;
@property (nonatomic) GLuint g_cbo;

@property (nonatomic) float tr0;
@property (nonatomic) float tr5;
@property (nonatomic) float tr10;

@property (nonatomic) float dTime;

-(float*) trArray;
-(float*) colorArray;
-(void) setHueColor:(CGFloat)hueColor;
-(void) attractorInfo;

-(void) attractorNoiceFar;
-(void) attractorNoiceNear;

@end

