//
//  StudyStreamViewController.m
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import "StudyStreamViewController.h"

@implementation StudyStreamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"Hey there";

    return cell;
}

@end
