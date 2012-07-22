//
//  cacheControlViewController.h
//  iTalmud
//
//  Created by Jonathan Rose on 2/28/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface cacheControlViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>{
    
}
@property (nonatomic, strong) NSCountedSet* downloadedBooks;
@property (strong, nonatomic) IBOutlet UITableView *TableViewListOfDownloadedPages;
@property (strong, nonatomic) NSMutableDictionary* numberOfPagesPerMesektah;
- (IBAction)deleteAllCache:(id)sender;

@end
