//
//  iphoneDafListViewController.m
//  iTalmud
//
//  Created by Jonathan Rose on 2/1/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "iphoneDafListViewController.h"
#import "Mesektah.h"
#import "Daf.h"
@implementation iphoneDafListViewController
@synthesize mesektah;
@synthesize tableview;
@synthesize progressTooBar;
@synthesize downloadAllButton;
@synthesize progressbar;

-(int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mesektah.dafim count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MyCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    Daf* thisDaf=[self.mesektah.dafim objectAtIndex:indexPath.row];
    cell.textLabel.text=thisDaf.displayName;
    if (thisDaf.isDownloaded){
        cell.textLabel.textColor=[UIColor blackColor];// @"✓";
    }else{
        cell.textLabel.textColor=[UIColor grayColor];// @"✓";
    }
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue destinationViewController] respondsToSelector:@selector(setDaf:)] && [sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath=[self.tableview indexPathForCell:sender];
        Daf* thisDaf=[self.mesektah.dafim objectAtIndex:indexPath.row];
        [segue.destinationViewController performSelector:@selector(setDaf:) withObject:thisDaf];
    }
    if ([[segue destinationViewController] respondsToSelector:@selector(setMesektah:)] && [sender isKindOfClass:[Mesektah class]]) {
        [segue.destinationViewController performSelector:@selector(setMesektah:) withObject:sender];
    }
}
-(void) viewDidLoad{
    [super viewDidLoad];
    self.mesektah.progressDelegate=self;
    self.downloadAllButton.title=NSLocalizedString(self.downloadAllButton.title, @"");
    self.title=NSLocalizedString(self.mesektah.name, @"");
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [tableview reloadData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setTableview:nil];
    [self setProgressTooBar:nil];
    [self setProgressbar:nil];
    [self setDownloadAllButton:nil];
    [super viewDidUnload];
}
-(void) dealloc{
    self.mesektah.progressDelegate=nil;
}

-(void) setProgress:(CGFloat) progress{
    self.progressbar.progress=progress;
    [self.tableview reloadData];
}
-(void) setHidden:(BOOL) hidden{
    self.progressTooBar.hidden=hidden;
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        [self.mesektah downloadIfNeed];
    }
}
- (IBAction)downloadAll:(id)sender {
    
    if ([self.mesektah isDownloaded]) {

    }else{
        float fileSize=(122.0*self.mesektah.rangeOfDafim.length)/1024.0;
        fileSize=roundf(fileSize);
        NSString* tractateName= self.mesektah.name;
        if  ([NSLocalizedString(@"CURRENT_LANGUAGE", @"") isEqualToString:@"he"]){
            tractateName=NSLocalizedString(  self.mesektah.name, @"");
        }
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: NSLocalizedString( @"%@ is not downloaded. Would you like to download now? (requires Internet - not recommend on 3G, file size approximately:%g MB)",@""), tractateName, fileSize] delegate:self cancelButtonTitle:NSLocalizedString( @"NO",@"") otherButtonTitles:NSLocalizedString( @"YES",@""), nil];
        
        
        alert.tag=[sender tag];
        [alert show];
    }
}
@end
