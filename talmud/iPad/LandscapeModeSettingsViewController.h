//
//  LandscapeModeSettings.h
//  iTalmud
//
//  Created by Jonathan Rose on 2/29/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LandscapeModeSettingsViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *LandscapeTwoPagesSegementedControl;
- (IBAction)LandscapeTwoPagesChanged:(id)sender;
@property (nonatomic, assign) BOOL onePageInLandscape;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *HeaderLabels;
@end
