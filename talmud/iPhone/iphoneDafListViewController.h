//
//  iphoneDafListViewController.h
//  iTalmud
//
//  Created by Jonathan Rose on 2/1/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Mesektah;
#import "BaseViewController.h"
@interface iphoneDafListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong) Mesektah* mesektah;
- (IBAction)downloadAll:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIToolbar *progressTooBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *downloadAllButton;
@property (strong, nonatomic) IBOutlet UIProgressView *progressbar;
@end
