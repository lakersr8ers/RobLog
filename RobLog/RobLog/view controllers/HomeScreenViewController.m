//
//  HomeScreenViewController.m
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import "HomeScreenViewController.h"

@implementation HomeScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkLogin];
}

- (void)checkLogin
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
    }
    else {
        NSLog(@"Not logged in yet");
        [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:NULL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
