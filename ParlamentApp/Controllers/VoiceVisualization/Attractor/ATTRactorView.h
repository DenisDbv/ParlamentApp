//
//  ATTRactorView.h
//  AttractorParlamenta
//
//  Created by DenisDbv on 01.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <GLKit/GLKView.h>

@protocol ATTRactorViewDelegate <NSObject>
-(void) attractorScaleValue:(CGFloat)scale;
-(void) createFirstAttractor;
@end

@interface ATTRactorView : UIView

@property (nonatomic, strong) IBOutlet id<ATTRactorViewDelegate> delegate;
@property (nonatomic, strong) UIImage *snapshotImage;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat lastScale;

-(void) initialization;
-(void) snapShoting;
-(void) releaseView;
-(void) resetAttractors;

@end
