//
//  ATTRactorManager.m
//  AttractorParlamenta
//
//  Created by DenisDbv on 03.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "ATTRactorManager.h"
#import "ATTRactorObject.h"

#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface ATTRactorManager()
@property (nonatomic, strong) NSMutableArray *attractorArray;
@end

@implementation ATTRactorManager
@synthesize attractorArray;

-(id) init
{
    self = [super init];
    if(self)
    {
        attractorArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void) addAttractor:(ATTRactorObject*)attr_object
{
    if(attr_object == nil)
        attr_object = [[ATTRactorObject alloc] init];
    
    //attr_object.index = attractorArray.count+1;
    
    [attractorArray addObject:attr_object];
    
    [attr_object attractorInfo];
}

-(void) attractorsRender:(GLuint)programHandle withTimeOffset:(CGFloat)timeOffset context:(EAGLContext*)context
{
    for(ATTRactorObject *attr_object in attractorArray)
    {
        float grid[] = {(float)attr_object.g_side, (float)attr_object.g_side};
        
        GLuint loc;
        // bind vertex buffer
        loc = glGetAttribLocation(programHandle, "inPosition");
        glBindBuffer(GL_ARRAY_BUFFER, attr_object.g_vbo);
        glEnableVertexAttribArray(loc);
        glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 0, NULL);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        // bind color buffer
        loc = glGetAttribLocation(programHandle, "inColor");
        glBindBuffer(GL_ARRAY_BUFFER, attr_object.g_cbo);
        glEnableVertexAttribArray(loc);
        glVertexAttribPointer(loc, 4, GL_FLOAT, GL_FALSE, 0, NULL);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        // common variables for all attractors
        glUniform2fv(glGetUniformLocation(programHandle, "GRID"), 1, grid);
        glUniform1f(glGetUniformLocation(programHandle, "T"), timeOffset*attr_object.dTime);
        
        glUniform1f(glGetUniformLocation(programHandle, "Index"), attr_object.index);
        glUniform4fv(glGetUniformLocation(programHandle, "Color"), 1, [attr_object colorArray]);
        glUniform1f(glGetUniformLocation(programHandle, "Fade"), attr_object.fade);
        glUniform1f(glGetUniformLocation(programHandle, "Phase"), attr_object.phase);
        glUniform1f(glGetUniformLocation(programHandle, "Word"), attr_object.word);
        glUniform1f(glGetUniformLocation(programHandle, "Spherize"), attr_object.spherize);
        glUniformMatrix4fv(glGetUniformLocation(programHandle, "tr"), 1, GL_FALSE, [attr_object trArray]);
        
        glUniform1f(glGetUniformLocation(programHandle, "Zoomer"), attr_object.zoomer);
        glUniform1f(glGetUniformLocation(programHandle, "HoldFade"), attr_object.holdFade);
        glUniform1f(glGetUniformLocation(programHandle, "PointSize"), attr_object.pointSize);
        
        glDrawArrays(GL_POINTS, 0, attr_object.g_side * attr_object.g_side);
    }
}

-(NSInteger) attractorsDepth
{
    return attractorArray.count;
}

-(ATTRactorObject*) attractorAccess:(NSInteger)index
{
    if(index < 0 || index > attractorArray.count-1)
        return nil;
    
    return [attractorArray objectAtIndex:index];
}

-(void) removeAll
{
    [attractorArray removeAllObjects];
    attractorArray = nil;
    attractorArray = [[NSMutableArray alloc] init];
}

@end
