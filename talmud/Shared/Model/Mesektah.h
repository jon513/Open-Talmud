//
//  tractate.h
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Daf;

@protocol ProgressProtocol;
@interface Mesektah : NSObject{
  
}
@property (nonatomic, retain) NSNumber* LastDownloadCheck;
@property (nonatomic, readonly) BOOL isDownloaded;
@property( nonatomic, assign) int DownloadedPages;
@property (nonatomic, strong) NSString* name;
@property (nonatomic) NSRange rangeOfDafim;
@property (nonatomic, readonly, strong) NSArray* dafim;
+(id) mesektahWithDictionary:(NSDictionary*) dict;
-(id) initWithDictionary:(NSDictionary*) dict;
-(BOOL) downloadIfNeed;
-(void) dafDownloaded:(Daf*) sender;
-(void) dafFailedToDownload:(Daf*) sender error:(NSError*) error;
@property (nonatomic, weak) UIProgressView* progressDelegate;
@property (readonly) UIImage* firstPageThumb;

@property (nonatomic, assign) NSNumber* lastLoadedPage;
@end

@protocol ProgressProtocol <NSObject>
-(void) setProgress:(float) progress;
@property (nonatomic, assign) BOOL hidden;


@end