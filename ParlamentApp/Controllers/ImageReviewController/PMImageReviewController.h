//
//  PMImageReviewController.h
//  ParlamentApp
//
//  Created by DenisDbv on 20.02.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMParentController.h"

@protocol PMImageReviewControllerDelegate <NSObject>
-(void) sendSuccessfulFromReviewController;
-(void) backFromReviewController;
@end

@interface PMImageReviewController : PMParentController <PMImageReviewControllerDelegate>

@property (nonatomic, strong) id <PMImageReviewControllerDelegate> delegate;

-(id) initWithImage:(UIImage*)imageReview :(NSString*)text :(NSString*)fileName :(MailToEnums)mailEnum;
-(id) initWithImage2:(UIImage*)imageReview :(NSString*)text :(NSString*)fileName :(MailToEnums)mailEnum;

@end
