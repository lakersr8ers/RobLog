//
//  ProfileViewController.h
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>
{
    IBOutlet UITableView *profileTableView;
    
    NSString *userName;
    NSArray *weekLabels;
    NSArray *timeLabels;
}

@property (nonatomic, strong) NSMutableData *profileImageData;
@property (nonatomic, strong) UIImage *profileImage;


@end

