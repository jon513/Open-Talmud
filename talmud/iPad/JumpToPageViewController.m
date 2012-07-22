//
//  JumpToPageViewController.m
//  iTalmud
//
//  Created by Jonathan Rose on 1/26/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "JumpToPageViewController.h"
#import "Mesektah.h"
#import "Daf.h"
@implementation JumpToPageViewController
@synthesize delegate, currentBook;
@synthesize startPages;
@synthesize pageListTableView;
-(int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.currentBook.dafim count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MyCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment=UITextAlignmentCenter;
    }
    Daf *thisDaf=[self.currentBook.dafim objectAtIndex:indexPath.row];
    cell.textLabel.text=thisDaf.displayName;
   
    if ([self.startPages containsObject:[NSNumber numberWithInt: indexPath.row]]) {
        cell.textLabel.textColor=[UIColor blueColor];
    }else{
        cell.textLabel.textColor=[UIColor blackColor];
    }
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Daf *thisDaf=[self.currentBook.dafim objectAtIndex:indexPath.row];
    [self.delegate jumpToPageController:self didFinishWithPage:thisDaf];
}
-(void) viewWillAppear:(BOOL)animated{
    
    [self.pageListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.startPages anyObject] intValue] inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [super viewWillAppear:animated];
}
- (void)viewDidUnload {
    [self setPageListTableView:nil];
    [super viewDidUnload];
}

@end
