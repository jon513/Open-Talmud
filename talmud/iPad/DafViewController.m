//
//  DataViewController.m
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "DafViewController.h"
#import "Daf.h"
#import "Mesektah.h"
@implementation DafViewController
@synthesize notesContainer = _notesContainer;
@synthesize firstPageImageView = _firstPageImageView;

@synthesize dataLabel = _dataLabel;
@synthesize dataObject = _dataObject;
@synthesize webview = _webview;
@synthesize informationPage=_informationPage;
@synthesize notesView=_notesView;
@synthesize webViewContainer = _webViewContainer;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)didPan:(UIPanGestureRecognizer*)sender{
    if (sender.state==UIGestureRecognizerStateBegan ||sender.state==UIGestureRecognizerStateChanged) {
        CGPoint transtion=[sender translationInView:self.notesContainer];
        CGRect frame=self.notesContainer.frame;
        frame.origin.y+=transtion.y;
        if (frame.origin.y>0) {
            frame.origin.y=0;
        }
        if (frame.origin.y < -200) {
            frame.origin.y=-200;
        }
        self.notesContainer.frame=frame;
        
        [sender setTranslation:CGPointZero inView:self.notesContainer];
    }else if(sender.state ==UIGestureRecognizerStateEnded ||sender.state ==UIGestureRecognizerStateCancelled) {
        CGRect frame=self.notesContainer.frame;

        if (self.notesContainer.frame.origin.y > -100) {
            frame.origin.y=0;
            [self.notesView becomeFirstResponder];
        }else{
            frame.origin.y=-200;
            [self.notesView resignFirstResponder];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.notesContainer.frame=frame;
        }];
    }
}

#pragma mark - View lifecycle
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(IBAction)toggleNotes:(id)sender{
    CGRect frame=self.notesContainer.frame;
    
    if (self.notesContainer.frame.origin.y < -100) {
        frame.origin.y=0;
        [self.notesView becomeFirstResponder];
    }else{
        frame.origin.y=-200;
        [self.notesView resignFirstResponder];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.notesContainer.frame=frame;
    }];
}

-(void) hideNotes:(NSNotification*) notification{
    CGRect frame=self.notesContainer.frame;
    frame.origin.y=-200;
    [UIView animateWithDuration:0.3 animations:^{
        self.notesContainer.frame=frame;
    }];
    [self.notesView resignFirstResponder];

    
}

- (IBAction)showNotes:(id)sender {
    CGRect frame=self.notesContainer.frame;
    frame.origin.y=0;
    [UIView animateWithDuration:0.3 animations:^{
        self.notesContainer.frame=frame;
    }];
    [self.notesView becomeFirstResponder];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNotes:) name:UIKeyboardDidHideNotification object:nil];
	// Do any additional setup after loading the view, typically from a nib.
    UIPanGestureRecognizer* panner=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.notesContainer addGestureRecognizer:panner];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
     
     
    [self setWebview:nil];
    [self setFirstPageImageView:nil];
    [self setNotesContainer:nil];
    self.notesView=nil;
    [self setWebViewContainer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
}
-(void) zoomOut{

    [self.webview.scrollView setZoomScale:self.webview.scrollView.minimumZoomScale animated:YES];
     
}
-(void) webViewDidFinishLoad:(UIWebView *)webView{

}
-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}
-(UIWebView*) webview{
    if (!_webview) {
        _webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 1004)];
        _webview.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        _webview.scalesPageToFit=YES;
        _webview.multipleTouchEnabled=YES;
        _webview.delegate=self;
    }
    return _webview;
}
-(void) setDataObject:(Daf *)dataObject{
    if (_dataObject != dataObject) {
        _dataObject=dataObject;
        if ([_dataObject isKindOfClass:[Daf class]]){
            NSURLRequest *urlRequest = nil;
            urlRequest=[NSURLRequest requestWithURL:dataObject.localURL];    
               [self.webview loadRequest:urlRequest];
        }
    }
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.dataObject isKindOfClass:[Daf class]]){
        
        if (!_webview) {
            NSLog(@"warning no webview!");
        }
        self.webview.frame=self.webViewContainer.bounds;
        [self.webViewContainer addSubview:self.webview];
        self.webview.hidden=NO;
        [self.informationPage removeFromSuperview];
        self.informationPage=nil;
        self.notesView.text=self.dataObject.notes;
       
    }else{
        self.webview.hidden=YES;
        if (!self.informationPage) {
            self.informationPage=[[[NSBundle mainBundle] loadNibNamed:@"InfomationPage" owner:nil options:nil] lastObject];
            [self translateView:self.informationPage];
            self.informationPage.frame=self.view.bounds;
            [self.view addSubview:self.informationPage];
        }
        self.informationPage.hidden=NO;
        
    }
}
-(void) textViewDidEndEditing:(UITextView *)textView{
    self.dataObject.notes=self.notesView.text;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   // NSLog(@"%@", NSStringFromCGRect(self.webview.frame));

    // Return YES for supported orientations
    return YES;
}


@end
