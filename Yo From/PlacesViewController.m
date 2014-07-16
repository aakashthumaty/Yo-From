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
    
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    [locationManager startUpdatingLocation];
//    [locationManager stopUpdatingLocation];
    NSLog(@"latlong: %f %f", _latitude, _longitude);
    [self fetchPlacesWithLat:_latitude andLong:_longitude completionBlock:^(BOOL success) {
        NSLog(@"places: %@", places);
        [placesTableView reloadData];

    }];
    
}

-(void)fetchPlacesWithLat:(float)lat andLong:(float)lng completionBlock:(void (^)(BOOL success))completionBlock{

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&key=AIzaSyBu2QJmZD81jJuvQ_62eXlYxZFknx3wpKU",lat,lng]]];
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    places = [[object objectForKey:@"results"]mutableCopy];
    
    completionBlock(YES);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([places count] >= 20){
        return 20;
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
    UILabel *sentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 100, 50)];
    sentLabel.center = self.view.center;
    sentLabel.text = @"Yo Sent!";
    sentLabel.font = [UIFont systemFontOfSize:40.0];
    sentLabel.backgroundColor = [UIColor lightGrayColor];
    sentLabel.textColor = [UIColor blackColor];
    sentLabel.textAlignment = NSTextAlignmentCenter;
    sentLabel.alpha = 0.f;
    [self.view addSubview:sentLabel];

    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [sentLabel setAlpha:0.7f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [sentLabel setAlpha:0.f];
        } completion:^(BOOL finished) {
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
