//
//  PMMailManager.h
//  ParlamentApp
//
//  Created by DenisDbv on 17.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    eToUser = 0,
    eToPhotoPerson,
    eToOperator
    
} MailToEnums;

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
-(void) sendMessageWithTitle:(NSString*)title
                         text:(NSString*)text
                        image:(UIImage*)image
                     filename:(NSString*)filename
                    toPerson:(MailToEnums)toEnum;

@end
