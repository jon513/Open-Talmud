//
//  talmud.h
//  talmud
//
//  Created by Jonathan Rose on 10/23/11.
//  Copyright (c) 2011 APPstudio Israel. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Daf;
@interface TalmudBavli : NSObject
@property (nonatomic, strong) NSArray* listOfBooks;
+ (TalmudBavli *)sharedTalmudBavli;
+(Daf*) dafYomi;

@end
