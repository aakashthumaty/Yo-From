//
//  TBTableView.h
//  Yo From
//
//  Created by Spencer Yen on 7/18/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TBTableViewDelegate;

@interface TBTableView : UITableView
@property (nonatomic, weak) id<TBTableViewDelegate> tbDelegate;
@end

@protocol TBTableViewDelegate<NSObject>
-(void)tableViewTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
@end
