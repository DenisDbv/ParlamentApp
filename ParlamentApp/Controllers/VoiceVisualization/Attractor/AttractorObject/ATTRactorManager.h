//
//  ATTRactorManager.h
//  AttractorParlamenta
//
//  Created by DenisDbv on 03.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATTRactorObject.h"

@interface ATTRactorManager : NSObject

-(void) addAttractor:(ATTRactorObject*)attr_object;

-(void) attractorsRender:(GLuint)programHandle withTimeOffset:(CGFloat)timeOffset context:(EAGLContext*)context;

-(NSInteger) attractorsDepth;
-(ATTRactorObject*) attractorAccess:(NSInteger)index;
-(void) removeAll;

@end
