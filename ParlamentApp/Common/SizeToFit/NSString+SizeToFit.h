//
//  NSString+SizeToFit.h
//  ParlamentApp
//
//  Created by DenisDbv on 10.02.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SizeToFit)

-(CGSize) sizeToFitWithFont:(UIFont*)font;
-(UIImage*) imageToFitWithFont:(UIFont*)font;

@end
