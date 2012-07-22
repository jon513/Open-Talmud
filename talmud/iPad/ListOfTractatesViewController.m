//
//  ListOfTractatesViewController.m
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "ListOfTractatesViewController.h"
#import "TalmudBavli.h"
#import "Mesektah.h"
#import "MesektahViewController.h"
#import "Daf.h"
#import <QuartzCore/QuartzCore.h>
@implementation ListOfTractatesViewController
@synthesize aboutPortalDafYomiPopup;
@synthesize settingsPopup;
@synthesize cachePopup;
@synthesize jumpToDafYomiButton;
@synthesize talmudTableview;
@synthesize imageOfSelectedTractate;
@synthesize aboutAppStudioPopup=_aboutPopup;
@synthesize FindDafYomiShirumPopup=_FindDafYomiShirumPopup;
-(void) dissmissAllPopups{
    if (self.aboutAppStudioPopup) {
        [self.aboutAppStudioPopup dismissPopoverAnimated:YES];
        self.aboutAppStudioPopup=nil;
    }
    if (self.aboutPortalDafYomiPopup) {
        [self.aboutPortalDafYomiPopup dismissPopoverAnimated:YES];
        self.aboutPortalDafYomiPopup=nil;
    }
    if (self.cachePopup) {
        [self.cachePopup dismissPopoverAnimated:YES];
        self.cachePopup=nil;
    }
    if (self.settingsPopup) {
        [self.settingsPopup dismissPopoverAnimated:YES];
        self.settingsPopup=nil;
    }
    if (self.FindDafYomiShirumPopup) {
        [self.FindDafYomiShirumPopup dismissPopoverAnimated:YES];
        self.FindDafYomiShirumPopup=nil;
    }
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self dissmissAllPopups];
}
-(int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ceil( ( (float)[[[TalmudBavli sharedTalmudBavli] listOfBooks] count] /3) ) ;
}
-(void) setUpView:(UIView*) viewToChange forTractate:(Mesektah*) book{
    int indexOfBook=[[TalmudBavli sharedTalmudBavli].listOfBooks indexOfObject:book];
    for (UIView* subView in viewToChange.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            ((UILabel*) subView).text=NSLocalizedString(book.name, @"");
            
        }
        if ([subView isKindOfClass:[UIButton class]]) {
            
            subView.userInteractionEnabled=(indexOfBook !=NSNotFound);
            subView.tag=indexOfBook;
        }
        if ([subView isKindOfClass:[UIProgressView class]]){
            if (book) {
                book.progressDelegate  =(UIProgressView*)subView;
            }else{
                subView.hidden=YES;
            }
        }
        if ([subView isKindOfClass:[UIImageView class]]) {
            if (subView.tag ==101) {
                if(book.isDownloaded){
                    subView.alpha=1.0;
                }else{
                    subView.alpha=0.5;
                }
                ((UIImageView*)subView).image=(book.firstPageThumb);

            }else{
                subView.hidden=!book.isDownloaded;
            }
                
        }
    }
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"Three Tractates"];
    
    Mesektah* one=nil;
    Mesektah* two=nil;
    Mesektah* three=nil;
    @try {
        three=[[[TalmudBavli sharedTalmudBavli] listOfBooks] objectAtIndex:indexPath.row*3];
        two=[[[TalmudBavli sharedTalmudBavli] listOfBooks] objectAtIndex:indexPath.row*3+1 ];
         one=[[[TalmudBavli sharedTalmudBavli] listOfBooks] objectAtIndex:indexPath.row*3+2 ];
        

    }
    @catch (NSException *exception) {}
    
    [self setUpView:[cell viewWithTag:9999901] forTractate:one];
    [self setUpView:[cell viewWithTag:9999902] forTractate:two];
    [self setUpView:[cell viewWithTag:9999903] forTractate:three];
    
    return cell;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.settingsPopup dismissPopoverAnimated:NO];
    [self.cachePopup dismissPopoverAnimated:YES];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[Mesektah class]] && [[segue destinationViewController] isKindOfClass:[MesektahViewController class]] ) {
        ((MesektahViewController*)[segue destinationViewController]).currentBook=sender;
        
    }
    if([segue.identifier isEqualToString:@"aboutAppStudio"]){
        
        ((AboutUsViewController*)[segue destinationViewController]).delegate=self;
        UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.aboutAppStudioPopup = popoverController;
        popoverController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"cache"]) {
        UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.cachePopup = popoverController;
        popoverController.delegate = self;
        
    }
    if ([segue.identifier isEqualToString:@"settings"]) {
        UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.settingsPopup = popoverController;
        popoverController.delegate = self;
        
    }else if ([segue.identifier isEqualToString:@"FindDafYomi"]) {
        UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.FindDafYomiShirumPopup = popoverController;
        popoverController.delegate = self;
    }else{
        [self.settingsPopup dismissPopoverAnimated:NO];
        [self.cachePopup dismissPopoverAnimated:YES];
        
        
    }
    
}

- (IBAction)DafYomi:(id)sender {
    
    Daf* dafYomi=[TalmudBavli dafYomi];
    if (dafYomi.tractate.rangeOfDafim.length %2 ==1) {
        dafYomi.tractate.lastLoadedPage=[NSNumber numberWithInt: dafYomi.tractate.rangeOfDafim.length- dafYomi.relativePage-1];

    }else{
        dafYomi.tractate.lastLoadedPage=[NSNumber numberWithInt: dafYomi.tractate.rangeOfDafim.length- dafYomi.relativePage];

    }
    

    int indexInTable=[[[TalmudBavli sharedTalmudBavli] listOfBooks] indexOfObject:dafYomi.tractate ];
    
    [self.talmudTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexInTable/3 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    if ([dafYomi.tractate isDownloaded]) {
        [self performSegueWithIdentifier:@"LoadBook" sender:dafYomi.tractate];
    }else{
        float fileSize=(122.0*dafYomi.tractate.rangeOfDafim.length)/1024.0;
        fileSize=roundf(fileSize);
        NSString* tractateName= dafYomi.tractate.name;        
        if  ([NSLocalizedString(@"CURRENT_LANGUAGE", @"") isEqualToString:@"he"]){
            tractateName=NSLocalizedString(   dafYomi.tractate.name, @"");
        }
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: NSLocalizedString( @"%@ is not downloaded. Would you like to download now? (requires Internet - not recommend on 3G, file size approximately:%g MB)",@""), tractateName, fileSize] delegate:self cancelButtonTitle:NSLocalizedString( @"NO",@"") otherButtonTitles:NSLocalizedString( @"YES",@""), nil];
        
        alert.tag=indexInTable;
        [alert show];

    }
   
}
- (IBAction)toggleSettings:(id)sender {
    if (self.settingsPopup) {
        [self.settingsPopup dismissPopoverAnimated:YES];
        self.settingsPopup = nil;
        [self dissmissAllPopups];
        
    } else {
        [self dissmissAllPopups];

        [self performSegueWithIdentifier:@"settings" sender:sender];
        
    }
}

- (IBAction)ToggleAboutAppStudio:(id)sender
{
    if (self.aboutAppStudioPopup) {
        [self.aboutAppStudioPopup dismissPopoverAnimated:YES];
        self.aboutAppStudioPopup = nil;
        [self dissmissAllPopups];

    } else {
        [self dissmissAllPopups];

        [self performSegueWithIdentifier:@"aboutAppStudio" sender:sender];
    }
}
-(IBAction)ToggleAboutPortalDafYomi:(id)sender{
    if (self.aboutPortalDafYomiPopup) {
        [self.aboutPortalDafYomiPopup dismissPopoverAnimated:YES];
        self.aboutPortalDafYomiPopup = nil;
        [self dissmissAllPopups];

    } else {
        [self dissmissAllPopups];

        [self performSegueWithIdentifier:@"aboutPortalDafYomi" sender:sender];

    }
}

-(IBAction)ToggleCache:(id)sender{
    
    if (self.cachePopup) {
        [self.cachePopup dismissPopoverAnimated:YES];
        self.cachePopup = nil;
        [self dissmissAllPopups];
        
    } else {
        [self dissmissAllPopups];
        
        [self performSegueWithIdentifier:@"cache" sender:sender];
    }
}

-(void) flipsideViewControllerDidFinish:(AboutUsViewController *)controller{
    [self.aboutAppStudioPopup dismissPopoverAnimated:YES];
    self.aboutAppStudioPopup = nil;
    [self.aboutPortalDafYomiPopup dismissPopoverAnimated:YES];
    self.aboutPortalDafYomiPopup=nil;
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    Mesektah* tratateToLoad=[[TalmudBavli sharedTalmudBavli].listOfBooks objectAtIndex:[alertView tag]];
    if (buttonIndex==1) {
        [tratateToLoad downloadIfNeed];
    }
}
- (IBAction)LoadTractate:(id)sender {
    Mesektah* tratateToLoad=[[TalmudBavli sharedTalmudBavli].listOfBooks objectAtIndex:[sender tag]];
    
    if ([tratateToLoad isDownloaded]) {
        UIView* superviewOfButton=[sender superview];
        for (UIView* view in superviewOfButton.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                self.imageOfSelectedTractate=(UIImageView*)view;
            }
            
        }
        [self performSegueWithIdentifier:@"LoadBook" sender:tratateToLoad];
    }else{
        float fileSize=(122.0*tratateToLoad.rangeOfDafim.length)/1024.0;
        fileSize=roundf(fileSize);
        NSString* tractateName= tratateToLoad.name;
        if  ([NSLocalizedString(@"CURRENT_LANGUAGE", @"") isEqualToString:@"he"]){
            tractateName=NSLocalizedString(  tratateToLoad.name, @"");
        }

        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: NSLocalizedString( @"%@ is not downloaded. Would you like to download now? (requires Internet - not recommend on 3G, file size approximately:%g MB)",@""), tractateName, fileSize] delegate:self cancelButtonTitle:NSLocalizedString( @"NO",@"") otherButtonTitles:NSLocalizedString( @"YES",@""), nil];


        alert.tag=[sender tag];
        [alert performSelector:@selector(show) withObject:nil afterDelay:0.3];
    }
}
-(void)downloadFinished{
    [self.talmudTableview reloadData];        
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self.jumpToDafYomiButton setTitle:[TalmudBavli dafYomi].displayName forState:UIControlStateNormal];
    [self.jumpToDafYomiButton setTitle:[TalmudBavli dafYomi].displayName forState:UIControlStateHighlighted];

}
-(void) dafimWereDeleted:(NSNotification*) notification{
    for (Mesektah* book in [[TalmudBavli sharedTalmudBavli] listOfBooks]) {
        book.LastDownloadCheck=nil;
    }
    
    [self.talmudTableview reloadData];
}
-(void) viewDidLoad{
    [super viewDidLoad];
    
//    for (Mesektah* tratate in [TalmudBavli sharedTalmudBavli].listOfBooks) {
//        
//            
//            
//            Daf* firstPage=[tratate.dafim objectAtIndex:0];
//        if (firstPage.pageOfTalmud >4000) {
//            UIWebView* webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 512, 724)];
//            NSURLRequest* request=[NSURLRequest requestWithURL:firstPage.localURL];
//            [webview loadRequest:request];
//            [self.view addSubview:webview];
//            double delayInSeconds = 12.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                
//                UIGraphicsBeginImageContext(webview.frame.size);
//                
//                [webview.layer renderInContext:UIGraphicsGetCurrentContext()];
//                
//                UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//                [UIImagePNGRepresentation(backgroundImage) writeToURL:tratate.landScapeURL atomically:YES];
//            });
//        }
////        {768, 980}
////        {512, 724}}
//        
//        
//    }
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinished) name:@"downloadComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dafimWereDeleted:) name:@"DAFIM_WERE_DELETED" object:nil];
    
}
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidUnload {
    [self setTalmudTableview:nil];
    [self setJumpToDafYomiButton:nil];
    [super viewDidUnload];
}
- (IBAction)rateApp:(id)sender {

}

- (IBAction)likeOnFacebook:(id)sender {
    NSURL* fackbookLink=[NSURL URLWithString:@"fb://page/168136476631518"];
    if ([[UIApplication sharedApplication] canOpenURL:fackbookLink]) {
        [[UIApplication sharedApplication] openURL:fackbookLink];
    }else{
        NSURL* weblink=[NSURL URLWithString:@"https://www.facebook.com/pages/Open-Talmud/168136476631518"];
        if ([[UIApplication sharedApplication] canOpenURL:weblink]) {
            [[UIApplication sharedApplication] openURL:weblink];
        }
    }
}

- (IBAction)donate:(id)sender {
    NSURL* donatelink=[NSURL URLWithString:@"http://daf-yomi.com/donate.aspx"];
    if( [[UIApplication sharedApplication] canOpenURL:donatelink]){
        [[UIApplication sharedApplication] openURL:donatelink];
    }
}
@end
