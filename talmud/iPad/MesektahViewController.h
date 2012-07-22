//
//  RootViewController.h
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class Mesektah;
@interface MesektahViewController : BaseViewController <UIPageViewControllerDelegate, UIPopoverControllerDelegate>
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *pageControllerArea;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) Mesektah* currentBook;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;

@property (strong, nonatomic) UIPopoverController *JumpToPagePopoverController;
@property (readonly, nonatomic) BOOL onePageInLandscape;


@end
