//
//  RootViewController.m
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "MesektahViewController.h"

#import "ModelController.h"

#import "DafViewController.h"
#import "Mesektah.h"
#import "JumpToPageViewController.h"
#import "Daf.h"

@interface MesektahViewController ()
@property (readonly, strong, nonatomic) ModelController *modelController;
@end

@implementation MesektahViewController
@synthesize pageControllerArea = _pageControllerArea;
@synthesize pageViewController = _pageViewController;
@synthesize modelController = _modelController;
@synthesize currentBook=_currentBook;
@synthesize titleBarButtonItem = _titleBarButtonItem;
@synthesize JumpToPagePopoverController = _JumpToPagePopoverController;
-(BOOL) onePageInLandscape{
    NSNumber *number=[[NSUserDefaults standardUserDefaults] objectForKey:@"onePageInLandscape"];
    if (!number) {
        return NO;
    }
    return [number boolValue];
}
-(void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload
{
    [self setPageControllerArea:nil];
    [self setTitleBarButtonItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (ModelController *)modelController
{
    /*
     Return the model controller object, creating it if necessary.
     In more complex implementations, the model controller may be passed to the view controller.
     */
    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
        _modelController.currentBook=self.currentBook;
    }
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods

/*
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation) || self.onePageInLandscape) {
        
        DafViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
        if (![currentViewController.dataObject isKindOfClass:[Daf class]]) {
            @try {
                currentViewController = [self.pageViewController.viewControllers objectAtIndex:1];
            }
            @catch (NSException *exception) {}   
        }
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }
    
    DafViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
    
    [currentViewController zoomOut];
    Daf* thisDaf=nil;
    if ([currentViewController.dataObject isKindOfClass:[Daf class]]) {
        thisDaf=currentViewController.dataObject;
    }
    NSArray *viewControllers = nil;
    if (thisDaf) { //Rotating from Daf Page
        
        
        if (thisDaf.relativePage % 2 == 0 ) {
            UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
            viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
        } else {
            UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
            viewControllers = [NSArray arrayWithObjects:previousViewController, currentViewController, nil];
        }
    }else{ //Rotating from starting page or ending page
        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        if (previousViewController) {
            viewControllers = [NSArray arrayWithObjects:previousViewController, currentViewController, nil];
        }else if (nextViewController) {
            viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
        }else{
            //Fail
            return UIPageViewControllerSpineLocationMin;
        }

    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];


    return UIPageViewControllerSpineLocationMid;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *options = nil;
    if (UIInterfaceOrientationIsLandscape( self.interfaceOrientation) && !self.onePageInLandscape) {
        options=[NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey: UIPageViewControllerOptionSpineLocationKey];     
    }
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageViewController.delegate = self;
    

    int startingpage=self.currentBook.rangeOfDafim.length;
    if (self.currentBook.rangeOfDafim.length %2) {
        startingpage=self.currentBook.rangeOfDafim.length-1;
    }
    if ([self.currentBook lastLoadedPage] && [self.currentBook.lastLoadedPage intValue] < startingpage) {
        startingpage=[self.currentBook.lastLoadedPage intValue];
    }
    
    DafViewController *startingViewController = [self.modelController viewControllerAtIndex:startingpage storyboard:self.storyboard];
    NSArray *viewControllers =[NSArray arrayWithObject:startingViewController];
    if (UIInterfaceOrientationIsLandscape( self.interfaceOrientation) && !self.onePageInLandscape) {
        DafViewController *startingViewController2 = [self.modelController viewControllerAtIndex:startingpage+1 storyboard:self.storyboard];
        viewControllers =[NSArray arrayWithObjects: startingViewController, startingViewController2, nil];

        
    }
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    self.pageViewController.dataSource = self.modelController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    self.pageViewController.view.frame = self.pageControllerArea.frame;
    [self.pageViewController didMoveToParentViewController:self];
    //[self.pageViewController willRotateToInterfaceOrientation:self.interfaceOrientation duration:0.0];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
     
    // [self.pageViewController didRotateFromInterfaceOrientation:self.interfaceOrientation];
    self.titleBarButtonItem.title=NSLocalizedString( self.currentBook.name, @"");
}
- (IBAction)back:(id)sender {
    if(  self.JumpToPagePopoverController){
        [self.JumpToPagePopoverController dismissPopoverAnimated:NO];
        self.JumpToPagePopoverController=nil;
    }
    @try {
        self.currentBook.lastLoadedPage=[NSNumber numberWithInt: [self.modelController indexOfViewController:[self.pageViewController.viewControllers objectAtIndex:0]]];
    }
    @catch (NSException *exception) {
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (self.JumpToPagePopoverController) {
        if ([self.JumpToPagePopoverController.contentViewController isKindOfClass:[JumpToPageViewController class]]) {
            NSMutableSet* set=[NSMutableSet setWithCapacity:2];
            for (DafViewController* viewcontroller in self.pageViewController.viewControllers) {
                if ([viewcontroller.dataObject isKindOfClass:[Daf class]]) {
                    [set addObject:[NSNumber numberWithInt: viewcontroller.dataObject.relativePage]];

                }
            }
            ((JumpToPageViewController*)self.JumpToPagePopoverController.contentViewController).startPages=set;
            [((JumpToPageViewController*)self.JumpToPagePopoverController.contentViewController).pageListTableView reloadData];
        }
     
    }
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[JumpToPageViewController class]]) {
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setCurrentBook:self.currentBook];
        
        @try {
            NSMutableSet* set=[NSMutableSet setWithCapacity:2];
            for (DafViewController* viewcontroller in self.pageViewController.viewControllers) {
                if ([viewcontroller.dataObject isKindOfClass:[Daf class]]) {

                    [set addObject:[NSNumber numberWithInt: viewcontroller.dataObject.relativePage]];
                }
            }
            ((JumpToPageViewController*)[segue destinationViewController]).startPages=set;
            
        }
        @catch (NSException *exception) {}
    }
    if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
        UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.JumpToPagePopoverController = popoverController;
        popoverController.delegate = self;
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.JumpToPagePopoverController) {
        [self.JumpToPagePopoverController dismissPopoverAnimated:YES];
        self.JumpToPagePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"jumpToPage" sender:sender];
    }
}
-(IBAction)showNotes:(id)sender{
    for (DafViewController* viewcontroller in self.pageViewController.viewControllers) {
        if ([viewcontroller.dataObject isKindOfClass:[Daf class]]) {
            [viewcontroller toggleNotes:nil];
            break;
        }
    }
}
-(void) jumpToPageController:(UIViewController*) controller didFinishWithPage:(Daf*) daf{
    
    
    DafViewController *selectedPage = [self.storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    selectedPage.dataObject = daf;
    int PageNumber= [self.modelController indexOfViewController:selectedPage];
    
    @try {
        self.currentBook.lastLoadedPage=[NSNumber numberWithInt: PageNumber];
    }
    @catch (NSException *exception) {}
    [self.JumpToPagePopoverController dismissPopoverAnimated:YES];
    self.JumpToPagePopoverController = nil;
    
    
    UIPageViewControllerNavigationDirection direction=UIPageViewControllerNavigationDirectionForward;
    @try {
        Daf* currentDaf=[[self.pageViewController.viewControllers objectAtIndex:0] dataObject];
        if ([currentDaf isKindOfClass:[Daf class]]) {
            if (currentDaf.relativePage < daf.relativePage) {
                direction=UIPageViewControllerNavigationDirectionReverse;
            }
            if (currentDaf.relativePage ==daf.relativePage) {
                return;
            }
        }
    }
    @catch (NSException *exception) {}

    
    if (selectedPage) {
        
        
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ||self.onePageInLandscape) {
            
            NSArray *viewControllers = [NSArray arrayWithObject:selectedPage];
                       [self.pageViewController setViewControllers:viewControllers direction:direction  animated:YES completion:NULL];
            
            self.pageViewController.doubleSided = NO;
            return;
        }
        
        NSArray *viewControllers = nil;
        
        if (daf.relativePage % 2 == 0) {
            UIViewController *nextViewController = [self.modelController viewControllerAtIndex:PageNumber+1 storyboard:self.storyboard];
                viewControllers = [NSArray arrayWithObjects:selectedPage, nextViewController, nil];
            
        } else{
            UIViewController *previousViewController =  [self.modelController viewControllerAtIndex:PageNumber-1 storyboard:self.storyboard]; 
            viewControllers = [NSArray arrayWithObjects:previousViewController, selectedPage, nil];
        }
        
        @try {
            Daf* currentDaf=[[self.pageViewController.viewControllers objectAtIndex:0] dataObject];
            if ([currentDaf isKindOfClass:[Daf class]]) {
              
                if (currentDaf.relativePage +1 == daf.relativePage && daf.relativePage %2 ==0) {
                    return;
                }
                if (currentDaf.relativePage -1 == daf.relativePage && daf.relativePage %2 ) {
                    return;
                }
            }
        }
        @catch (NSException *exception) {}
        [self.pageViewController setViewControllers:viewControllers direction:direction animated:YES completion:NULL];
        
    }

}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.JumpToPagePopoverController = nil;
}

@end
