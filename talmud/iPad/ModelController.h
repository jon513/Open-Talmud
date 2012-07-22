//
//  ModelController.h
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DafViewController;
@class Mesektah;

@interface ModelController : NSObject <UIPageViewControllerDataSource>
- (DafViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DafViewController *)viewController;
@property (nonatomic, retain) Mesektah* currentBook;
@end
