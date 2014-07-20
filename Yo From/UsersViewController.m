//
//  UsersViewController.m
//  Yo From
//
//  Created by Spencer Yen on 7/16/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import "UsersViewController.h"
#import "LoginViewController.h"
#import "PlacesViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "HistoryViewController.h"
#import "UserData.h"

@interface UsersViewController () {
    CLLocationManager *locationManager;
    CLLocation *location;
    NSMutableArray *places;
}


@end

@implementation UsersViewController{
    NSMutableArray *friends;
    NSString *recipient;
}

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
    TBTableView *tableView = (TBTableView *)[self friendsTableView];
    tableView.tbDelegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    [locationManager stopUpdatingLocation];

    friends = [[NSMutableArray alloc]init];
    _username = [[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"preferenceName"];
    _userLabel.text = [NSString stringWithFormat:@"user: %@",_username];
    _userLabel.adjustsFontSizeToFitWidth = YES;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"logged_in"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:loginVC animated:NO completion:nil];
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"friends"]){
            friends = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"friends"] mutableCopy];
            [self.friendsTableView reloadData];
        }
    }
}

-(void)addFriend{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Add Friend"
                              message:@"Enter username"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Add", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && actionSheet.alertViewStyle == UIAlertViewStylePlainTextInput) {
    
    UITextField *textField = [actionSheet textFieldAtIndex:0];
    //NSLog(@"textfield text: %@, %@", textField.text, _username);
    if(![friends containsObject:textField.text]){
        PFQuery *query = [PFQuery queryWithClassName:@"user"];
        [query whereKey:@"username" equalTo:textField.text];
        if([query countObjects] == 0){
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Oops!"
                                      message:@"No such username"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        else if([textField.text isEqualToString:_username]){
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Oops!"
                                      message:@"Can't add yourself ;)"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        else{
        [friends insertObject:textField.text atIndex:0];
        [_friendsTableView reloadData];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:friends forKey:@"friends"];
        [userDefaults synchronize];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message:@"Username already added!"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    
    }
}
-(void)tableViewTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSArray *touchesArray = [touches allObjects];
//    
//    UITouch *touch = (UITouch *)[touchesArray lastObject];
//    CGPoint touchLocation = [touch locationInView:nil];
//    NSIndexPath *indexPath = [self.friendsTableView indexPathForRowAtPoint:touchLocation];
//    
//    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
//        NSInteger friendCount = (NSInteger)[friends count];
//        if(friendCount > (int)indexPath.row){
//            location = [locationManager location];
//            
//            recipient = [friends objectAtIndex:indexPath.row];
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            PlacesViewController *placesVC = (PlacesViewController*)[storyboard instantiateViewControllerWithIdentifier:@"placesVC"];
//            placesVC.tapLocation = touchLocation;
//            placesVC.recipient = recipient;
//            placesVC.latitude = location.coordinate.latitude;
//            placesVC.longitude = location.coordinate.longitude;
//            NSLog(@"%f, %f ", placesVC.latitude, placesVC.longitude);
//            placesVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            [self presentViewController:placesVC animated:YES completion:nil];
//            
//        }
//        
//    }
    

}

 #pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [friends count]+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    static NSString *friendCellIdentifier = @"friendCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:friendCellIdentifier];
    }

    UILabel *label = (UILabel*) [cell viewWithTag:101];
    NSInteger friendCount = (NSInteger)[friends count];
    //NSLog(@"friendcount: %d", friendCount -1 == (int)indexPath.row);
    if(friendCount > (int)indexPath.row){
        label.text = [friends objectAtIndex:indexPath.row];
        if(indexPath.row % 2 == 0){//rgb(52, 152, 219)
            cell.backgroundColor = [AppDelegate myColor1];
            label.textColor = [UIColor whiteColor];
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
            label.textColor = [AppDelegate myColor1];
        }
    }
    else if(friendCount == (int)indexPath.row ){
        label.text = @"+";
        cell.backgroundColor = [AppDelegate myColor2];
        label.textColor = [UIColor whiteColor];
    }
//    else if(friendCount < (int)indexPath.row ){
//        label.text = @"History";
//        label.textColor = [UIColor whiteColor];
//        cell.backgroundColor = [AppDelegate myColor1];
//
//    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger friendCount = (NSInteger)[friends count];
    if(friendCount > (int)indexPath.row){
        location = [locationManager location];
        
        _latitude = location.coordinate.latitude;
        _longitude = location.coordinate.longitude;
        
        
        recipient = [friends objectAtIndex:indexPath.row];
      
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlacesViewController *placesVC = (PlacesViewController*)[storyboard instantiateViewControllerWithIdentifier:@"placesVC"];
        placesVC.recipient = recipient;
        placesVC.lat = _latitude;
        placesVC.lng = _longitude;
        placesVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        [self presentViewController:placesVC animated:YES completion:nil];
    
    }
    else if(friendCount == (int)indexPath.row ){
        [self addFriend];
    }
//    else if(friendCount < (int)indexPath.row ){
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        HistoryViewController *historyVC = (HistoryViewController*)[storyboard instantiateViewControllerWithIdentifier:@"historyVC"];
//        UserData *userData =[UserData sharedManager];
//        historyVC.yofromHistory = userData.history;
//        
//        [self presentViewController:historyVC animated:YES completion:nil];
//
//    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}



@end
