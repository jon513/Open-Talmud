//
//  LandscapeModeSettings.m
//  iTalmud
//
//  Created by Jonathan Rose on 2/29/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "LandscapeModeSettingsViewController.h"

@implementation LandscapeModeSettingsViewController
@synthesize HeaderLabels;
@synthesize LandscapeTwoPagesSegementedControl;

-(BOOL) onePageInLandscape{
    NSNumber *number=[[NSUserDefaults standardUserDefaults] objectForKey:@"onePageInLandscape"];
    if (!number) {
        return NO;
    }
    return [number boolValue];
    
}
-(void) setOnePageInLandscape:(BOOL)onePageInLandscape{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:onePageInLandscape] forKey:@"onePageInLandscape"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidUnload {
    [self setLandscapeTwoPagesSegementedControl:nil];
    [self setHeaderLabels:nil];
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.onePageInLandscape) {
        [self.LandscapeTwoPagesSegementedControl setSelectedSegmentIndex:1];

    }else{
        [self.LandscapeTwoPagesSegementedControl setSelectedSegmentIndex:0];

    }
    if  ([NSLocalizedString(@"CURRENT_LANGUAGE", @"") isEqualToString:@"he"]){
        for (UILabel* headerlabel in self.HeaderLabels) {
            headerlabel.textAlignment=UITextAlignmentRight;
        }
    }else{
        for (UILabel* headerlabel in self.HeaderLabels) {
            headerlabel.textAlignment=UITextAlignmentLeft;
        }
    }

}
- (IBAction)LandscapeTwoPagesChanged:(id)sender {
    if (self.LandscapeTwoPagesSegementedControl.selectedSegmentIndex ==0) {
        self.onePageInLandscape=NO;
    }else{
        self.onePageInLandscape=YES;
    }
}
@end
