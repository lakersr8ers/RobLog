//
//  StatsViewController.m
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import "StatsViewController.h"

@implementation StatsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeTableData];
}

- (void)initializeTableData
{
    greekGroup = @[@"Phi Sigma Kappa", @"Kappa Alpha Theta", @"Delta Sigma Phi", @"Kappa Sigma", @"Phi Kappa Psi", @"Chi Omega"];
    sportsGroup = @[@"Woman's Basketball", @"Men's Basketball", @"Men's Football", @"Woman's tennis"];
    sectionLabel = @[@"", @"Greek Houses", @"Sports Teams"];
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionLabel objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return greekGroup.count;
    }
    else if (section == 2) {
        return sportsGroup.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.section == 0) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StatsTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    else if (indexPath.section == 1) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        cell.textLabel.text = [greekGroup objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"7 hours";
    }
    else if (indexPath.section == 2) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = [sportsGroup objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"4 hours";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
