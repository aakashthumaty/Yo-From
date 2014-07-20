//
//  UsersViewController.h
//  Yo From
//
//  Created by Spencer Yen on 7/16/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TBTableView.h"
@interface UsersViewController : UIViewController <UITableViewDataSource, TBTableViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet TBTableView *friendsTableView;
@property (nonatomic, strong) NSString *username;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@end
