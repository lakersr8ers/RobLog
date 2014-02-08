//
//  HomeScreenViewController.m
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "UserInfoManager.h"

@implementation HomeScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkLogin];
}

- (void)checkLogin
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self initFacebookData];
    }
    else {
        NSLog(@"Not logged in yet");
        [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:NULL];
    }
}

- (void)initFacebookData
{
    [[UserInfoManager sharedManager] initFBData:^(bool error, NSString *errorMessage) {
        if (!error) {
            NSLog(@"User info added to ParseDB");
        }
        else {
            NSLog(@"%@", errorMessage);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
