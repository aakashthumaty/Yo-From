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
#import <UIKit/UIGestureRecognizerSubclass.h>
@interface PlacesViewController ()

@end

@implementation PlacesViewController {
    CLLocationManager *locationManager;
    CLLocation *location;

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
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
//                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
   // longPress.state = UIGestureRecognizerStateBegan;
   /// [self longPressGestureRecognized:longPress];
 
   // [longPress setAllowableMovement:500.f];
    
  //  [self.placesTableView addGestureRecognizer:longPress];
    

    
}

- (void)viewWillAppear:(BOOL)animated {
//    [placesTableView reloadData];
//    NSIndexPath *indexPath = [self.placesTableView indexPathForRowAtPoint:_tapLocation];
//    [self.placesTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];

    [super viewWillAppear:animated];
    [self fetchPlacesWithLat:_lat andLong:_lng completionBlock:^(BOOL success) {
        [self.placesTableView reloadData];
    }];
}

-(void)fetchPlacesWithLat:(float)lat andLong:(float)lng completionBlock:(void (^)(BOOL success))completionBlock{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&limit=11&sort_by_distance=1&client_id=S3TSP5JASASQ0HFTVEB0ZUFHBFJUTUB25JTIGNWVC5XUYTCT&client_secret=40I4A04HECJL3ZPKCZDZBQSYF2EVU4PM5B1PKJTXH55EZDED&v=20140719",lat,lng]]];
    NSLog(@"%@",[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&limit=11&sort_by_distance=1&client_id=S3TSP5JASASQ0HFTVEB0ZUFHBFJUTUB25JTIGNWVC5XUYTCT&client_secret=40I4A04HECJL3ZPKCZDZBQSYF2EVU4PM5B1PKJTXH55EZDED&v=20140719",lat,lng]);
    
    if(data == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Oops."
                              message:@"Looks like we can't find any places, sorry. Check if location services is turned on in Settings or check your network connection!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
    }
    else{
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _places = [[[object objectForKey:@"response"] objectForKey:@"venues"]mutableCopy];
        [_places insertObject:[[[_places objectAtIndex:0] objectForKey:@"location"] objectForKey:@"city"] atIndex:0];
        NSLog(@"places: %@", _places);
        completionBlock(YES);
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_places != nil)
    {
    if([_places count] >= 12){
        return 13;
    }
    else{
        return [_places count]+1;
    }
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [_places count]){
        return 70;
    }else{
        return 50;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //if(_places != nil){
    if(indexPath.row == [_places count]){
        
        static NSString *CellIdentifier = @"cancelCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
      
        return cell;
        
    }else{
        static NSString *CellIdentifier = @"placeCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
    
        if (indexPath.row != 0) {

            UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
            nameLabel.adjustsFontSizeToFitWidth = YES;
            NSDictionary *place = [_places objectAtIndex:indexPath.row];
            NSString *lowercase = [[place objectForKey:@"name"] lowercaseString];
            nameLabel.text = lowercase;
                
                
            UIImageView *iconImage = (UIImageView *)[cell viewWithTag:102];
            iconImage.contentMode = UIViewContentModeScaleAspectFill;

            NSString *prefix = [[[[place objectForKey:@"categories"]firstObject]objectForKey:@"icon"]objectForKey:@"prefix"];

            NSString *suffix = [[[[place objectForKey:@"categories"]firstObject]objectForKey:@"icon"]objectForKey:@"suffix"];
            
            NSString *url = [prefix stringByReplacingOccurrencesOfString:@"ss1.4sqi.net" withString:@"foursquare.com"];
            
            [iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@bg_64%@",url,suffix]] placeholderImage:[UIImage imageNamed:@"icon-60.png"]];
        }
    else{
            UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
            nameLabel.adjustsFontSizeToFitWidth = YES;
            NSString *lowercase = [[_places objectAtIndex:indexPath.row] lowercaseString];
            nameLabel.text = lowercase;
            UIImageView *iconImage = (UIImageView *)[cell viewWithTag:102];
            iconImage.contentMode = UIViewContentModeScaleAspectFill;
            [iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://foursquare.com/img/categories_v2/building/cityhall_bg_64.png"]] placeholderImage:[UIImage imageNamed:@"icon-60.png"]];


    }
        return cell;

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == [_places count]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        if(indexPath.row != 0){
    NSLog(@"send to %@ from %@", _recipient, [[_places objectAtIndex:indexPath.row]objectForKey:@"name"]);
    
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"username" equalTo:_recipient];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"preferenceName"];
    NSString *string = [NSString stringWithFormat:@"%@ @ %@", savedValue, [[_places objectAtIndex:indexPath.row]objectForKey:@"name"]];
            
            [push setMessage:string];
            [push sendPushInBackground];
    }
        else if(indexPath.row == 0)
        {
            NSLog(@"send to %@ from %@", _recipient, [_places objectAtIndex:0]);
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"username" equalTo:_recipient];
            
            // Send push notification to query
            PFPush *push = [[PFPush alloc] init];
            [push setQuery:pushQuery];
            NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                    stringForKey:@"preferenceName"];
            NSString *string = [NSString stringWithFormat:@"%@ @ %@", savedValue, [_places objectAtIndex:0]];
            
            [push setMessage:string];
            [push sendPushInBackground];


        }

    UILabel *sentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 180, 50)];
    sentLabel.center = self.view.center;
    sentLabel.text = @"Yo Sent!";
    sentLabel.font = [UIFont systemFontOfSize:35.0];
    sentLabel.backgroundColor = [UIColor lightGrayColor];
    sentLabel.textColor = [UIColor whiteColor];
    sentLabel.textAlignment = NSTextAlignmentCenter;
    sentLabel.alpha = 0.f;
    [self.view addSubview:sentLabel];

    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [sentLabel setAlpha:0.8f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [sentLabel setAlpha:0.f];
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
    }
}

- (IBAction)longPressGestureRecognized:(id)sender {

//    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
//    UIGestureRecognizerState state = longPress.state;
//    
//    CGPoint locations = [longPress locationInView:self.placesTableView];
//    NSIndexPath *indexPath = [self.placesTableView indexPathForRowAtPoint:locations];
//    
//    switch (state) {
//        case UIGestureRecognizerStateBegan: {
//            if (indexPath) {
//                [self.placesTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//             
//            }
//            break;
//        }
//        case UIGestureRecognizerStateChanged: {
//                [self.placesTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//            break;
//        }
//        default: {
//            [self.placesTableView deselectRowAtIndexPath:indexPath animated:YES];
//            NSLog(@"send to %@ from %@", _recipient, [[places objectAtIndex:indexPath.row]objectForKey:@"name"]);
//            
//            // Create our Installation query
//            PFQuery *pushQuery = [PFInstallation query];
//            [pushQuery whereKey:@"username" equalTo:_recipient];
//            
//            // Send push notification to query
//            PFPush *push = [[PFPush alloc] init];
//            [push setQuery:pushQuery];
//            NSString *savedValue = [[NSUserDefaults standardUserDefaults]
//                                    stringForKey:@"preferenceName"];
//            NSString *string = [NSString stringWithFormat:@"%@ @ %@", savedValue, [[places objectAtIndex:indexPath.row]objectForKey:@"name"]];
//            
//            [push setMessage:string];
//            [push sendPushInBackground];
//            UILabel *sentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 150, 50)];
//            sentLabel.center = self.view.center;
//            sentLabel.text = @"Yo Sent!";
//            sentLabel.font = [UIFont systemFontOfSize:30.0];
//            sentLabel.backgroundColor = [UIColor lightGrayColor];
//            sentLabel.textColor = [UIColor whiteColor];
//            sentLabel.textAlignment = NSTextAlignmentCenter;
//            sentLabel.alpha = 0.f;
//            [self.view addSubview:sentLabel];
//            
//            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
//                [sentLabel setAlpha:0.7f];
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.2f delay:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    [sentLabel setAlpha:0.f];
//                } completion:^(BOOL finished) {
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }];
//            }];
//            break;
//        }
//    }
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
