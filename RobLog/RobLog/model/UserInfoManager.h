//
//  UserInfoManager.h
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserInfoManager : NSObject
{
    
}

+ (UserInfoManager *)sharedManager;

- (void)initFBData:(void (^)(bool error, NSString *errorMessage))completion;

@end
