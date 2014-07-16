//
//  PlacesViewController.m
//  Yo From
//
//  Created by Spencer Yen on 7/16/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import "PlacesViewController.h"
#import "UIImageView+WebCache.h"
#import <Parse/Parse.h>
#import "UsersViewController.h"
@interface PlacesViewController ()

@end

@implementation PlacesViewController {
    CLLocationManager *locationManager;
    CLLocation *location;
    NSMutableArray *places;
}
@synthesize placesTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    [locationManager stopUpdatingLocation];
    location = [locationManager location];
    
    places = [self fetchPlacesNearby];
    [placesTableView reloadData];
    
}

-(NSMutableArray *)fetchPlacesNearby{
    float longitude = location.coordinate.longitude;
    float latitude = location.coordinate.latitude;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&key=AIzaSyBu2QJmZD81jJuvQ_62eXlYxZFknx3wpKU",latitude,longitude]]];
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [[object objectForKey:@"results"]mutableCopy];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([places count] >= 9){
        return 9;
    }
    else{
        return [places count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"placeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [[places objectAtIndex:indexPath.row]objectForKey:@"name"];

    UIImageView *iconImage = (UIImageView *)[cell viewWithTag:102];
    iconImage.contentMode = UIViewContentModeScaleAspectFill;
    iconImage.clipsToBounds = YES;
    iconImage.layer.cornerRadius =  iconImage.frame.size.height / 2;
    [iconImage setImageWithURL:[NSURL URLWithString:[[places objectAtIndex:indexPath.row]objectForKey:@"icon"]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"send to %@ from %@", _recipient, [[places objectAtIndex:indexPath.row]objectForKey:@"name"]);
    
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"username" equalTo:_recipient];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"preferenceName"];
    NSString *string = [NSString stringWithFormat:@"%@ @ %@", savedValue, [[places objectAtIndex:indexPath.row]objectForKey:@"name"]];

    [push setMessage:string];
    [push sendPushInBackground];
    UILabel *sentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 300, 50)];
    sentLabel.center = self.view.center;
    sentLabel.text = @"Yo Sent!";
    sentLabel.font = [UIFont systemFontOfSize:40.0];
    
    sentLabel.textColor = [UIColor blackColor];
    sentLabel.textAlignment = NSTextAlignmentCenter;
    sentLabel.alpha = 0;
    [self.view addSubview:sentLabel];
    
    sentLabel.transform = CGAffineTransformMakeScale(0.01, 0.01);
    sentLabel.alpha = 1;
    [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        sentLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            sentLabel.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished){
            sentLabel.alpha = 0;
         
            [self dismissViewControllerAnimated:YES completion:nil];
    }];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
