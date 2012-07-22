//
//  DataViewController.h
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class Daf;
@interface DafViewController : BaseViewController<UIWebViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) Daf* dataObject;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) UIView* informationPage;
-(void) zoomOut;
@property (strong, nonatomic) IBOutlet UIImageView *firstPageImageView;
-(IBAction)didPan:(UIPanGestureRecognizer*)sender;
@property (strong, nonatomic) IBOutlet UIView *notesContainer;
- (IBAction)showNotes:(id)sender;
@property( strong, nonatomic) IBOutlet UITextView* notesView;
@property (strong, nonatomic) IBOutlet UIView *webViewContainer;
-(IBAction)toggleNotes:(id)sender;
@end
