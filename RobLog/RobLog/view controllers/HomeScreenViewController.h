//
//  HomeScreenViewController.h
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "StudyStreamViewController.h"
#import "StatsViewController.h"
#import "ProfileViewController.h"
#import "AddPostViewController.h"

@class StudyStreamViewController;
@class StatsViewController;

@interface HomeScreenViewController : UIViewController
<UITabBarDelegate, UIAlertViewDelegate>
{
    IBOutlet UITabBar *homeTabBar;
    IBOutlet UIView *mainView;
    UIViewController *selectedController;
    
    NSArray *viewControllers;
    NSArray *titles;
}

@property (nonatomic, strong) StudyStreamViewController *studyStreamVC;
@property (nonatomic, strong) StatsViewController *statsVC;
@property (nonatomic, strong) ProfileViewController *profileVC;


@end
