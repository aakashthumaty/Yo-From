//
//  UsersViewController.m
//  Yo From
//
//  Created by Spencer Yen on 7/16/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import "UsersViewController.h"
#import "LoginViewController.h"
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
    
    //if(![[NSUserDefaults standardUserDefaults] boolForKey:@"logged_in"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:loginVC animated:NO completion:nil];
    //}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [friends count]+2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *friendCellIdentifier = @"FriendCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:friendCellIdentifier];
    }
    
    UILabel *label = (UILabel*) [cell viewWithTag:101];
    label.text = [friends objectAtIndex:indexPath.row];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //ChatTableViewController *chatVC = (ChatTableViewController*)[storyboard instantiateViewControllerWithIdentifier:@"chatVC"];
    
    
    //NSString *conversationIdentifier = [message conversationForType:LYRConversationTypeParticipants].identifier;
    
    //[[self navigationController] pushViewController:chatVC animated:YES];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
