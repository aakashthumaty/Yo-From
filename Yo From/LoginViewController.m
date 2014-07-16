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

@synthesize usernameTextField;

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
- (IBAction)signup:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged_in"];
    
    PFObject *user = [PFObject objectWithClassName:@"user"];
    NSString *string = usernameTextField.text;
    user[@"username"] = @"%@",string;
    [user saveInBackground];

    
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
