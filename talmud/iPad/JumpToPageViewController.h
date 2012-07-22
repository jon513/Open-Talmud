//
//  JumpToPageViewController.h
//  iTalmud
//
//  Created by Jonathan Rose on 1/26/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JumpToPageViewController, Mesektah, Daf;
@protocol JumpToPageViewControllerDelegate <NSObject>
-(void) jumpToPageController:(UIViewController*) controller didFinishWithPage:(Daf*) pageNumber;

@end

@interface JumpToPageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) Mesektah* currentBook;
@property (weak, nonatomic) IBOutlet id <JumpToPageViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *pageListTableView;
@property (nonatomic, retain) NSSet* startPages;
@end

