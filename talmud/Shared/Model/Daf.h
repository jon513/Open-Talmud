//
//  Folio.h
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Mesektah;
@interface Daf : NSObject{
    int downloadURLIndex;
}
@property (nonatomic, assign) int downloadURLIndex;

@property (nonatomic,strong) NSMutableData* data;
@property (nonatomic, strong) NSURLConnection* connection;
@property(nonatomic) int pageOfTalmud;
@property (nonatomic, readonly) NSURL* downloadURL;
@property (nonatomic, readonly) NSArray* downloadURLs;

@property (readonly) BOOL isDownloaded;
@property (readonly) NSURL* localURL;
@property (nonatomic, assign) BOOL isDownloading;
@property  (nonatomic, weak) Mesektah* tractate;
-(BOOL) download;
@property (nonatomic, readonly) NSString* fileName;
@property (nonatomic, readonly) NSString* displayName;
@property (nonatomic, readonly) int relativePage;
-(id) initWithPage:(int) page;
+(id) folioWithPage:(int) page;
@property (nonatomic, assign, readwrite) NSString* notes;

-(Daf*) nextDaf;

-(Daf*) previousDaf;
-(BOOL) deleteLocalFile;

@end
