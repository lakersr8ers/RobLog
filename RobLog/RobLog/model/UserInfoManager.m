//
//  UserInfoManager.m
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

@synthesize checkInID;

static int initialized = 0;
static UserInfoManager *userInfoManager;

+ (UserInfoManager *)sharedManager
{
    if (!initialized) {
        userInfoManager = [[UserInfoManager alloc] init];
        initialized = 1;
        userInfoManager.checkInID = nil;
    }
    
    return userInfoManager;
}

- (void)initFBData:(void (^)(bool, NSString *))completion
{
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            
            if (userData[@"name"]) {
                userProfile[@"name"] = userData[@"name"];
            }
            
            if (userData[@"location"][@"name"]) {
                userProfile[@"location"] = userData[@"location"][@"name"];
            }
            
            if (userData[@"gender"]) {
                userProfile[@"gender"] = userData[@"gender"];
            }
            
            if ([pictureURL absoluteString]) {
                userProfile[@"pictureURL"] = [pictureURL absoluteString];
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            completion(false, @"");
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            completion(true, @"The facebook session was invalidated");
            
        } else {
            completion(true, [NSString stringWithFormat:@"Some other error: %@", error]);
        }
    }];
}

- (void)checkInCheckOut:(void (^)(NSString *))completion
{
    NSLog(@"Check id: %@", checkInID);
    if (checkInID == nil) {
        NSLog(@"Check in");
        completion([self checkIn]);
    }
    else {
        NSLog(@"Check out");
        completion([self checkout]);
    }
}

- (NSString *)checkIn
{
    NSDate *date = [[NSDate alloc] init];
    PFObject *object = [PFObject objectWithClassName:@"CheckInCheckOut"];
    object[@"checkin"] = date;
    object[@"user"] = [PFUser currentUser];
    object[@"checkout"] = date;
    [object save];
    
    checkInID = [object objectId];
    NSLog(@"checkin id: %@", checkInID);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, hh:mm a"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

- (NSString *)checkout
{
    PFQuery *query = [PFQuery queryWithClassName:@"CheckInCheckOut"];
    PFObject *object = [query getObjectWithId:checkInID];
    
    NSDate *date = [[NSDate alloc] init];
    
    object[@"checkout"] = date;
    [object saveInBackground];
    
    checkInID = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, hh:mm a"];
    NSString *dateStr = [formatter stringFromDate:date];

    return dateStr;
}

@end
