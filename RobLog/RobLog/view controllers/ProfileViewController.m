//
//  ProfileViewController.m
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initProfileView];
    [self tableData];
}

- (void)initProfileView
{
    if ([[PFUser currentUser] objectForKey:@"profile"][@"name"]) {
        userName = [[PFUser currentUser] objectForKey:@"profile"][@"name"];
    }
    
    
    // Download the user's facebook profile picture
    self.profileImageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]) {
        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
        // Run network request asynchronously
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        if (!urlConnection) {
            NSLog(@"Failed to download picture");
        }
    }
}

- (void)tableData
{
    weekLabels = @[@"Week 1", @"Week 2", @"Week 3", @"Week 4", @"Week 5", @"Week 6", @"Week 7", @"Week 8", @"Week 9", @"Week 10", @"Week 11", @"Week 12"];
    
    timeLabels = @[@"2 hours", @"3 hours", @"45 hours", @"6 hours", @"5 hours", @"6 hours", @"6 hours", @"5 hours", @"76 hours", @"16 hours", @"25 hours", @"32 hours"];
}

#pragma mark - NSConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [self.profileImageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // All data has been downloaded, now we can set the image in the header image view
    self.profileImage = [UIImage imageWithData:self.profileImageData];
    [profileTableView reloadData];
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 50;
    }
    return 190;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return weekLabels.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.section == 0) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserProfileTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
        // Profile name
        UILabel *profileName = (UILabel *)[cell viewWithTag:2];
        profileName.text = userName;
        
        // UIImage
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        imageView.layer.cornerRadius = 55.0f;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [imageView setImage:self.profileImage];
    }
    else if (indexPath.section == 1) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        cell.textLabel.text = [weekLabels objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:124/255.0f green:158/255.0f blue:70/255.0f alpha:1.0f];
        cell.detailTextLabel.text = [timeLabels objectAtIndex:indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


@end
