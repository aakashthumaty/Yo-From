//
//  LoginViewController.m
//  Yo From
//
//  Created by Aakash on 7/15/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "UsersViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController


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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signUpUser:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"logged_in"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    PFQuery *query = [PFQuery queryWithClassName:@"user"];
    [query whereKey:@"username" equalTo:_unTextField.text];
    if([query countObjects] > 0){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message:@"Username already taken"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:nil];
        [alertView show];
    
    }else{
    PFObject *user = [PFObject objectWithClassName:@"user"];
    NSString *string = _unTextField.text;
    user[@"username"] = string;
    [user saveInBackground];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"username"] = string;
    [currentInstallation saveInBackground];
        NSLog(@"username: %@", string);

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UsersViewController *userVC = (UsersViewController*)[storyboard instantiateViewControllerWithIdentifier:@"usersVC"];
    [self presentViewController:userVC animated:YES completion:nil];
    }
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
