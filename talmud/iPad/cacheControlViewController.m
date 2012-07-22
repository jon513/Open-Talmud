//
//  cacheControlViewController.m
//  iTalmud
//
//  Created by Jonathan Rose on 2/28/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "cacheControlViewController.h"
#import "Daf.h"
#import "Mesektah.h"
#import "TalmudBavli.h"
@implementation cacheControlViewController
@synthesize downloadedBooks;
@synthesize TableViewListOfDownloadedPages;
@synthesize numberOfPagesPerMesektah;

-(NSCountedSet*) downloadedBooks{
    if (!downloadedBooks) {
        NSURL* downloadDirectory=[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"talmud" isDirectory:YES];
        NSArray* urlsInDownloadDirectory=[[NSFileManager defaultManager] contentsOfDirectoryAtURL:downloadDirectory includingPropertiesForKeys:nil options:0 error:nil];
        
        
        NSArray* Mesektot=[[TalmudBavli sharedTalmudBavli] listOfBooks];
        NSCountedSet* mutableArrar=[NSCountedSet set ];
        for (Mesektah* book in Mesektot) {
            for (NSURL* url in urlsInDownloadDirectory) {
                NSRange range=NSMakeRange([[[url lastPathComponent] stringByDeletingPathExtension] intValue], 1);
                NSRange intercetion=NSIntersectionRange(book.rangeOfDafim, range);
                if (intercetion.length !=0) {
                    [mutableArrar addObject:book];
                }
                
            }
            
        }
        downloadedBooks =mutableArrar;

    }
    return downloadedBooks;
}
-(int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.downloadedBooks allObjects] count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MyCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] ;
    }
    Mesektah* tractate=[[self.downloadedBooks allObjects] objectAtIndex:indexPath.row];
    NSString* tractateName= tractate.name;
    if  ([NSLocalizedString(@"CURRENT_LANGUAGE", @"") isEqualToString:@"he"]){
        tractateName=NSLocalizedString(  tractateName, @"");
    }
    cell.textLabel.text=tractateName;
    int dafCount=[self.downloadedBooks countForObject:tractate];
    if  (dafCount >1){
        cell.detailTextLabel.text=[NSString stringWithFormat:NSLocalizedString(@"%d pages", @""),dafCount ];
    }else{
        cell.detailTextLabel.text=[NSString stringWithFormat:NSLocalizedString(@"1 page", @""),dafCount ];
        
    }
    
    return cell;
}
-(void) viewDidLoad{
    [super viewDidLoad];
    self.TableViewListOfDownloadedPages.editing=YES;
    self.title=NSLocalizedString(@"Cache", @"");

}
- (void)viewDidUnload {
    [self setTableViewListOfDownloadedPages:nil];
    [super viewDidUnload];
}
-(void) deleteMesktah:(Mesektah*) booktoDelete{
    for (Daf* daftodelete in booktoDelete.dafim) {
        [daftodelete deleteLocalFile];
    }
}
- (IBAction)deleteAllCache:(id)sender {
    for ( Mesektah* booktoDelete in [self.downloadedBooks allObjects]) {
        [self deleteMesktah:booktoDelete];       
    }
    self.downloadedBooks=nil;
    [self.TableViewListOfDownloadedPages reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DAFIM_WERE_DELETED" object:nil];


}
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        Mesektah* booktoDelete=[[self.downloadedBooks allObjects] objectAtIndex:indexPath.row];
        [self deleteMesktah:booktoDelete];       
        self.downloadedBooks=nil;
        [self.TableViewListOfDownloadedPages reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DAFIM_WERE_DELETED" object:nil];
         
    }
}
@end
