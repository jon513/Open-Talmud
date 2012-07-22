//
//  iphoneDafViewController.m
//  iTalmud
//
//  Created by Jonathan Rose on 2/1/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "iphoneDafViewController.h"
#import "Daf.h"
#include <sys/xattr.h>

@implementation iphoneDafViewController
@synthesize webview;
@synthesize daf;
@synthesize segmentedControl;

-(void) downloadFailedForDaf:(Daf*) page{
    NSArray* downloadURLS=page.downloadURLs;

    page.downloadURLIndex++;
    if (page.downloadURLIndex < [downloadURLS count]){
        [self tryDownloadDaf:page]; // try again with new index
    }else{
        page.downloadURLIndex=0; //reset to try again      
        NSURLRequest* requestForWebview=[NSURLRequest requestWithURL:self.daf.downloadURL];  
        [self.webview loadRequest:requestForWebview];

    }
}
-(void) tryDownloadDaf:(Daf*) page{
    //NSLog(@"downloading page at %@", page.downloadURL);
    NSURLRequest *urlRequest = urlRequest=[NSURLRequest requestWithURL:page.downloadURL];  
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *responce, NSData *data, NSError *error) {
        NSURLRequest *requestForWebview = nil;
        
        if ([responce.MIMEType isEqualToString:@"application/pdf"]) {
            if (!error) {
                [[NSFileManager defaultManager] createDirectoryAtPath:[[self.daf.localURL path] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL];
                
                if ([data writeToURL:self.daf.localURL atomically:YES]) {
                    const char* filePath = [[self.daf.localURL path ] fileSystemRepresentation];
                    const char* attrName = "com.apple.MobileBackup";
                    u_int8_t attrValue = 1;
                    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
                    result=result; //result is whether it set this bit correctly;  do this setting to suppress warning;
                    requestForWebview=[NSURLRequest requestWithURL:self.daf.localURL]; 
                    [self.webview loadRequest:requestForWebview];
                } else{
                    [self downloadFailedForDaf:page];
                }
            }else{
                [self downloadFailedForDaf:page];                
            }
        }else{
            [self downloadFailedForDaf:page];
        }
        
    }];

}
-(void) loadDaf{
    self.title=NSLocalizedString(@"Loading...", @"");

    if ([self.daf isDownloaded]) {
        NSURLRequest *urlRequest =[NSURLRequest requestWithURL:self.daf.localURL];  
        [self.webview loadRequest:urlRequest];
    }else{
        self.daf.downloadURLIndex=0;
        [self tryDownloadDaf:self.daf];
       
    }


    
    Daf* nextDaf=[self.daf nextDaf];
    Daf* previousDaf=[self.daf previousDaf];
    
    [self.segmentedControl setEnabled:(nextDaf !=nil) forSegmentAtIndex:0];
    [self.segmentedControl setEnabled:(previousDaf !=nil) forSegmentAtIndex:1];

}
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void) ToggleFullScreen:(UITapGestureRecognizer*) recognizer{
    [[UIApplication sharedApplication] setStatusBarHidden:!([UIApplication sharedApplication].statusBarHidden) withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    
}
-(void) viewDidLoad{
    [super viewDidLoad];
    [self loadDaf];
    
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ToggleFullScreen:)];
    [self.webview addGestureRecognizer:tap];
    tap.delegate=self;
    
}
-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"Error",@"") message:NSLocalizedString( @"Could not download Daf - Please check your Internet and try again",@"") delegate:nil cancelButtonTitle:NSLocalizedString( @"OK",@"") otherButtonTitles: nil];
    [alert show];
    webView.hidden=NO;
    self.title=daf.displayName;

}
-(void) webViewDidFinishLoad:(UIWebView *)webView{
    webView.hidden=NO;
    self.title=daf.displayName;

}
-(void) webViewDidStartLoad:(UIWebView *)webView{
    webView.hidden=YES;
}
- (void)viewDidUnload
{
    [self setWebview:nil];
    [self setSegmentedControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)PressNextOrPreviousPage:(id)sender {
    self.title=NSLocalizedString(@"Loading...", @"");


    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        if( [((UISegmentedControl*) sender) selectedSegmentIndex]==0){
            Daf* nextDaf=[self.daf nextDaf];

            if (nextDaf) {
                self.daf=nextDaf;
                [self performSelector:@selector(loadDaf) withObject:nil afterDelay:0.0];
            }
        }else{
            Daf* prevoiusDaf=[self.daf previousDaf];
            
            if (prevoiusDaf) {
                self.daf=prevoiusDaf;
                [self performSelector:@selector(loadDaf) withObject:nil afterDelay:0.0];
            }
        }
    }
    
}
@end
