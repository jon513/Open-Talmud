//
//  talmud.m
//  talmud
//
//  Created by Jonathan Rose on 10/23/11.
//  Copyright (c) 2011 APPstudio Israel. All rights reserved.
//

#import "TalmudBavli.h"
#import "Mesektah.h"
#import "Daf.h"
@implementation TalmudBavli
@synthesize listOfBooks;
+ (TalmudBavli *)sharedTalmudBavli
{
    static TalmudBavli *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TalmudBavli alloc] init];
    });
    return sharedInstance;
}
-(NSArray*) listOfBooks{
    if (!listOfBooks) {
        NSDictionary* values=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"talmudBavli" ofType:@"plist"]];
        NSArray* arrayofdicts=[values objectForKey:@"talmud"];
        NSMutableArray* arrayOfObjects=[NSMutableArray arrayWithCapacity:[arrayofdicts count]];
        for (NSDictionary* dict in arrayofdicts) {
            [arrayOfObjects addObject:[Mesektah mesektahWithDictionary:dict]];
        }
        listOfBooks= arrayOfObjects;
        NSLog(@"creating talmud");
    }
    return listOfBooks;
}

+(Daf*) dafYomi{
    //march 1, 2005
    NSDate* startOfDafYomi=[NSDate dateWithTimeIntervalSince1970:1109628000];
    NSCalendar* gregorian=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* daysCompents=[gregorian components:NSDayCalendarUnit fromDate:startOfDafYomi toDate:[NSDate date] options:0];
    int DayInCycle=(daysCompents.day-1)%2711;
    int DafOfCycle=DayInCycle*2+1; //we start counting from 1 not 0

    for (Mesektah* book in [TalmudBavli sharedTalmudBavli].listOfBooks) {
        
        if (DafOfCycle < NSMaxRange(book.rangeOfDafim)   && DafOfCycle>=book.rangeOfDafim.location) {
    
            for (Daf* page in book.dafim) {
                if (page.pageOfTalmud == DafOfCycle) {
                    return page;
                }
            }
        }
        if (book.rangeOfDafim.length %2) { //only learn one amud when it is the end of a mesketa
            DafOfCycle --;
        }
    }
    
    return nil;      
    
}


@end
