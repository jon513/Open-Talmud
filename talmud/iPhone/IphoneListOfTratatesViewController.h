//
//  listOfTratatesViewController.h
//  iTalmud
//
//  Created by Jonathan Rose on 2/1/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface IphoneListOfTratatesViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *dafYomiButton;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)rateApp:(id)sender;
- (IBAction)likeOnFacebook:(id)sender ;
- (IBAction)more:(id)sender;

- (IBAction)donate:(id)sender;
@end
