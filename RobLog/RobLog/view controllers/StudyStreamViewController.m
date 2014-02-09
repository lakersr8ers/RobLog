//
//  StudyStreamViewController.m
//  RobLog
//
//  Created by Stephen Lakowske on 2/8/14.
//  Copyright (c) 2014 Cal Poly Hackathon. All rights reserved.
//

#import "StudyStreamViewController.h"
#import "UserInfoManager.h"

@implementation StudyStreamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self initTableData];
    
}

- (void)initTableData
{
    [[UserInfoManager sharedManager] retrievePosts:^(bool success, NSMutableArray *objects) {
        postObjects = [[NSMutableArray alloc] initWithArray:objects];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView reloadData];
        //[self initProfileImages];
    }];
}

- (void)initProfileImages
{
    for (PFObject *object in postObjects) {
        PFUser *user = object[@"user"];
        
        NSMutableData *imageData = [[NSMutableData alloc] init];
        [userImages addObject:imageData];
        
        if ([user objectForKey:@"profile"][@"pictureURL"]) {
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
    
}

#pragma mark - NSConnection

/*
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [self.profileImageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // All data has been downloaded, now we can set the image in the header image view
    self.profileImage = [UIImage imageWithData:self.profileImageData];
    [profileTableView reloadData];
}
 */

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [postObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //if (cell == nil) {
    //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    //}
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StudyStreamTableViewCell" owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
    
    PFObject *object  = [postObjects objectAtIndex:indexPath.row];
    NSString *userNameStr = object[@"name"];
    NSString *activityStr = object[@"text"];
    
    UILabel *labelName = (UILabel *)[cell viewWithTag:1];
    UILabel *labelDate = (UILabel *)[cell viewWithTag:2];
    UILabel *postLabel = (UILabel *)[cell viewWithTag:3];
    
    labelName.text = userNameStr;
    NSDate *date = [object createdAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, hh:mm a"];
    NSString *dateStr = [formatter stringFromDate:date];
    labelDate.text = dateStr;
    postLabel.text = activityStr;
    
    /*
    PFObject *object  = [postObjects objectAtIndex:indexPath.row];
    NSString *userNameStr = object[@"name"];
    NSString *activityStr = object[@"text"];
    
    //cell.imageView.image = [UIImage imageNamed:@"profile_before.png"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ is %@", userNameStr, activityStr];
    NSDate *date = [object createdAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, hh:mm a"];
    NSString *dateStr = [formatter stringFromDate:date];
    cell.detailTextLabel.text = dateStr;
     */

    return cell;
}

#pragma mark - refresh control

- (void)refresh:(UIRefreshControl *)sender
{
    [self initTableData];
    [sender endRefreshing];
}


@end
