//
//  PlacesViewController.h
//  Yo From
//
//  Created by Spencer Yen on 7/16/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^completion)(BOOL);


@interface PlacesViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>{

}

@property (weak, nonatomic) IBOutlet UITableView *placesTableView;
@property (nonatomic, retain) NSString *recipient;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSMutableArray *places;
@property (nonatomic) CGPoint tapLocation;

@end
