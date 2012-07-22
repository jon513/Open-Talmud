//
//  FlipsideViewController.m
//  Hebrew Date
//
//  Created by Jonathan Rose on 1/23/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "AboutAppStudioViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface AboutAppStudioViewController()
@property (nonatomic, retain) NSArray* schemesInPlist;
@end;

@implementation AboutAppStudioViewController

@synthesize delegate = _delegate;

- (IBAction)visitWebsite:(id)sender {
    NSURL* url=[NSURL URLWithString:@"http://appstudio.co.il?ref=italmud"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {

        [[UIApplication sharedApplication] openURL:url];
    }else{
        
        
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 460.0);
    }
    return self;
}
		

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
