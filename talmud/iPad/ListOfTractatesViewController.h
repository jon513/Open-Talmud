//
//  ListOfTractatesViewController.h
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutUsViewController.h"
#import "BaseViewController.h"
@interface ListOfTractatesViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, FlipsideViewControllerDelegate, UIPopoverControllerDelegate>{
    
}
@property( strong, nonatomic) UIImageView* imageOfSelectedTractate;
- (IBAction)LoadTractate:(id)sender;
@property (strong, nonatomic) UIPopoverController *aboutAppStudioPopup;
- (IBAction)ToggleAboutAppStudio:(id)sender;

@property (strong, nonatomic) UIPopoverController *aboutPortalDafYomiPopup;
@property (strong, nonatomic) UIPopoverController *settingsPopup;
@property (strong, nonatomic) UIPopoverController *FindDafYomiShirumPopup;

@property (strong, nonatomic) UIPopoverController  *cachePopup;
- (IBAction)ToggleAboutPortalDafYomi:(id)sender;

- (IBAction)DafYomi:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *jumpToDafYomiButton;
- (IBAction)rateApp:(id)sender;
- (IBAction)likeOnFacebook:(id)sender;

- (IBAction)donate:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *talmudTableview;
- (IBAction)toggleSettings:(id)sender;
@end
