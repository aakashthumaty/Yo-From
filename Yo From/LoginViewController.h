//
//  LoginViewController.h
//  Yo From
//
//  Created by Aakash on 7/15/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *unTextField;

- (IBAction)signUpUser:(id)sender;
@end
