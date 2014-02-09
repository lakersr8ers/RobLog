//
//  StatsViewController.h
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *statsTableView;
    NSArray *sectionLabel;
    NSArray *greekGroup;
    NSArray *sportsGroup;
}
@end
