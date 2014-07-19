//
//  TBTableView.m
//  Yo From
//
//  Created by Spencer Yen on 7/18/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import "TBTableView.h"

@implementation TBTableView
@synthesize tbDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (tbDelegate){
        [tbDelegate tableViewTouchesBegan:touches withEvent:event];
    }
}

@end
