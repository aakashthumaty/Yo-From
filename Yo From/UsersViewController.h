//
//  UsersViewController.h
//  Yo From
//
//  Created by Spencer Yen on 7/16/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface UsersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (nonatomic, retain) NSString *username;

@end
