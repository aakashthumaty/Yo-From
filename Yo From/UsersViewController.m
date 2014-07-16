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
@interface UsersViewController ()

@end

@implementation UsersViewController{
    NSMutableArray *friends;
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
    friends = [[NSMutableArray alloc]init];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"logged_in"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:loginVC animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (buttonIndex == 1) {
    
    UITextField *textField = [actionSheet textFieldAtIndex:0];
    NSLog(@"textfield text: %@", textField.text);
    [friends addObject:textField.text];
    
    [_friendsTableView reloadData];
    }
}
//hi
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
    NSLog(@"friends: %@", friends);
        if([friends count] > indexPath.row){
        label.text = [friends objectAtIndex:indexPath.row];
    }
    
    if(indexPath.row == [friends count]){
        
        label.text = @"+";
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([friends count] > indexPath.row)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlacesViewController *placesVC = (PlacesViewController*)[storyboard instantiateViewControllerWithIdentifier:@"placesVC"];
        [self presentViewController:placesVC animated:YES completion:nil];
        

    }
    else if(indexPath.row == [friends count]){
    
        [self addFriend];
    }

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setRecipients:friends];
}



@end
