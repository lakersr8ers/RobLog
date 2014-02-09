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

@synthesize studyStreamVC, statsVC, profileVC;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkLogin];
}

- (void)initNavigationBar
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:124/255.0f green:158/255.0f blue:70/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,
      shadow, NSShadowAttributeName,
      [UIFont fontWithName:@"HelveticaNeue" size:20.0],
      NSFontAttributeName, nil]];
    
    // Set buttons
    UIImage *clockImage = [UIImage imageNamed:@"clock.png"];
    UIImage *statusImage = [UIImage imageNamed:@"status.png"];
    UIBarButtonItem *statusButton = [[UIBarButtonItem alloc] initWithImage:statusImage style:UIBarButtonItemStyleBordered target:self action:@selector(statusButtonPressed:)];
    UIBarButtonItem *checkInButton = [[UIBarButtonItem alloc] initWithImage:clockImage style:UIBarButtonItemStyleBordered target:self action:@selector(checkInButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = statusButton;
    self.navigationItem.leftBarButtonItem = checkInButton;
}

- (void)checkLogin
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self initFacebookData];
        [self initializeViews];
    }
    else {
        NSLog(@"Not logged in yet");
        [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:NULL];
    }
}

- (void)initializeViews
{
    // Titles
    titles = @[@"Study Stream", @"Stats", @"Profile"];
    self.title = [titles objectAtIndex:0];
    
    // View controllers
    self.studyStreamVC = [[StudyStreamViewController alloc] init];
    self.statsVC = [[StatsViewController alloc] init];
    self.profileVC = [[ProfileViewController alloc] init];
    viewControllers = @[self.studyStreamVC, self.statsVC, self.profileVC];
    
    // tab bar items
    [homeTabBar setSelectedItem:[homeTabBar.items objectAtIndex:0]];
    
    // set view
    [mainView addSubview:self.studyStreamVC.view];
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

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    int index = [[tabBar items] indexOfObject:item];
    self.title = [titles objectAtIndex:index];
    UIViewController *viewController = [viewControllers objectAtIndex:index];
    [mainView addSubview:viewController.view];
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UserInfoManager sharedManager] checkInCheckOut:^(NSString *dateStr) {
        NSLog(@"%@", dateStr);
    }];
}

#pragma mark - action bar items

- (void)statusButtonPressed:(id)sender
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[AddPostViewController alloc] init]];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)checkInButtonPressed:(id)sender
{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, hh:mm a"];
    NSString *dateStr = [formatter stringFromDate:date];

    NSString *buttonText = ([[UserInfoManager sharedManager] checkInID] == nil) ? @"Check In" : @"Check Out";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Card" message:dateStr delegate:self cancelButtonTitle:buttonText otherButtonTitles:nil];
    
    [alert show];
}

@end
