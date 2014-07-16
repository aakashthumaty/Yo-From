//
//  PlacesViewController.m
//  Yo From
//
//  Created by Spencer Yen on 7/16/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import "PlacesViewController.h"
#import "UIImageView+WebCache.h"
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
    
}

-(NSMutableArray *)fetchPlacesNearby{
    float longitude = location.coordinate.longitude;
    float latitude = location.coordinate.latitude;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-%f,%f&radius=100&key=AIzaSyBu2QJmZD81jJuvQ_62eXlYxZFknx3wpKU",longitude,latitude]]];
    NSLog(@"request: %@", [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-%f,%f&radius=100&key=AIzaSyBu2QJmZD81jJuvQ_62eXlYxZFknx3wpKU",longitude,latitude]);
   __block NSMutableArray *results = [[NSMutableArray alloc]init];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        results = [[object objectForKey:@"results"]mutableCopy];
        
    }];
    NSLog(@"results: %@", results);
    return results.mutableCopy;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
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
    static NSString *CellIdentifier = @"PlaceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [[places objectAtIndex:indexPath.row]objectForKey:@"name"];

    UIImageView *iconImage = (UIImageView *)[cell viewWithTag:100];
    iconImage.contentMode = UIViewContentModeScaleAspectFill;
    iconImage.clipsToBounds = YES;
    iconImage.layer.cornerRadius =  iconImage.frame.size.height / 2;
    [iconImage setImageWithURL:[NSURL URLWithString:[[places objectAtIndex:indexPath.row]objectForKey:@"icon"]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //ChatTableViewController *chatVC = (ChatTableViewController*)[storyboard instantiateViewControllerWithIdentifier:@"chatVC"];
    //[[self navigationController] pushViewController:chatVC animated:YES];
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
