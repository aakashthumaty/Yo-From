//
//  LoginViewController.h
//  Yo From
//
//  Created by Aakash on 7/15/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *unTextField;

- (IBAction)signUpUser:(id)sender;
@end
