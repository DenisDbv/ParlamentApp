//
//  PMMailManager.h
//  ParlamentApp
//
//  Created by DenisDbv on 17.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMMailManagerDelegate <NSObject>
-(void) mailSendSuccessfully;
-(void) mailSendFailed;
@end

@interface PMMailManager : NSObject

@property (nonatomic, strong) id <PMMailManagerDelegate> delegate;

-(void) sendMessageWithImage:(UIImage*)image
                   imageName:(NSString*)imageName
                     andText:(NSString*)text;

-(void) sendMessageWithImage:(UIImage*)image imageName:(NSString*)imageName
                    andTitle:(NSString*)title
                     andText:(NSString*)text;

-(void) sendMessageToPhotoPersonWithSubject:(NSString*)subject
                                    andDesc:(NSString*)desc;

-(void) sendTestMessage;

@end
