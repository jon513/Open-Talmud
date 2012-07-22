//
//  BaseViewController.m
//  iTalmud
//
//  Created by Jonathan Rose on 1/30/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController
-(void) translateView:(UIView*) viewToTranslate{
    
    NSMutableSet* SetToTranslate=[NSMutableSet setWithObject:viewToTranslate];
    // [SetToTranslate addObjectsFromArray:self.ViewsToCheckForTranslations];
    while ([SetToTranslate count] >0) {
        //Take this one out of the set 
        UIView* toTranslate=[SetToTranslate anyObject];
        [SetToTranslate removeObject:toTranslate];
        
        if ([toTranslate isKindOfClass:[UILabel class]]) {
            ((UILabel*) toTranslate).text=NSLocalizedString(((UILabel*) toTranslate).text, @"");
        }else if ([toTranslate isKindOfClass:[UIButton class]]) {
            for (UIControlState state=0; state <16; state++) {
                [((UIButton*) toTranslate) setTitle:NSLocalizedString([((UIButton*) toTranslate) titleForState:state],@"") forState:state];
            }
        }else if ([toTranslate isKindOfClass:[UISegmentedControl class]]) {
            int numberOfSegments=[((UISegmentedControl*) toTranslate) numberOfSegments];
            for (int segment=0; segment < numberOfSegments; segment++) {
                [((UISegmentedControl*) toTranslate) setTitle:NSLocalizedString( [((UISegmentedControl*) toTranslate)  titleForSegmentAtIndex:segment], @"") forSegmentAtIndex:segment];
            }
        }else if ([toTranslate isKindOfClass:[UITextField class]]){
            ((UITextField*) toTranslate).placeholder=NSLocalizedString(((UITextField*) toTranslate).placeholder, @"");
        }else if ([toTranslate isKindOfClass:[UITextView class]]){
            ((UITextView*) toTranslate).text=NSLocalizedString(((UITextView*) toTranslate).text, @"");
        }else if([toTranslate isKindOfClass:[UIToolbar class]]){
            for (UIBarButtonItem* item in ((UIToolbar*)toTranslate).items) {
                item.title=NSLocalizedString(item.title, @"");
            }
        }else  if([toTranslate isKindOfClass:[UIPickerView class]]){
            //Don't look at subviews
        }else if ([toTranslate isKindOfClass:[UIDatePicker class]]){
            //don't look at subviews
        }else{  //Otherwise it might have subview
            for (UIView* view in toTranslate.subviews) {
                [SetToTranslate addObject:view];
            }
        }
        
        
        
        
    }

}
-(void) viewDidLoad{
    [super viewDidLoad];
    [self translateView:self.view];
    for (UIBarButtonItem* button in self.navigationItem.leftBarButtonItems) {
        button.title=NSLocalizedString(button.title, @"");
    }
    for (UIBarButtonItem* button in self.navigationItem.rightBarButtonItems) {
        button.title=NSLocalizedString(button.title, @"");
    }
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
