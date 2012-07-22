//
//  iphoneDafViewController.h
//  iTalmud
//
//  Created by Jonathan Rose on 2/1/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class Daf;
@interface iphoneDafViewController : BaseViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property(strong, nonatomic) Daf* daf;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)PressNextOrPreviousPage:(id)sender;

-(void) tryDownloadDaf:(Daf*) page;

@end
