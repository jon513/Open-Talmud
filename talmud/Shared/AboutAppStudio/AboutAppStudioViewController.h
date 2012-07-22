//
//  FlipsideViewController.h
//  Hebrew Date
//
//  Created by Jonathan Rose on 1/23/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewControllerDelegate.h"

@interface AboutAppStudioViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) IBOutlet id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)visitWebsite:(id)sender;


@end

/*
 appSTUDIO Israel is a dynamic team of young professionals living in Jerusalem.
 
 Our current development focus is creating apps for iPhone and Android. For more information contact us at +972 52 541 9106. Or visit our Website at http://www.appstudio.co.il



*/