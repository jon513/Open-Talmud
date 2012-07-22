//
//  tractate.m
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "Mesektah.h"
#import "Daf.h"
@implementation Mesektah
@synthesize name,rangeOfDafim;
@synthesize dafim;
@synthesize progressDelegate;
@synthesize DownloadedPages;
@synthesize LastDownloadCheck;

-(UIImage*) firstPageThumb{
//You can customize a different thumb for each mesektah
    //    NSString* fileNmae=[NSString stringWithFormat:@"FirstPageThumb_%@.png", self.name];
    
    
    return [UIImage imageNamed:@"SamplePageThumbnail.png"];
}
-(id) initWithDictionary:(NSDictionary*) dict{
    self=[super init];
    if (self) {
        self.name=[dict objectForKey:@"name"];
        self.rangeOfDafim=NSMakeRange([[dict objectForKey:@"location"] intValue], [[dict objectForKey:@"length"] intValue]);
        
    }
    return self;
}
+(id) mesektahWithDictionary:(NSDictionary*) dict{
    return [[Mesektah alloc] initWithDictionary:dict];
}

-(NSArray*) dafim{
    if (!dafim) {
        NSMutableArray* array=[NSMutableArray arrayWithCapacity:self.rangeOfDafim.length];
        for (int i=self.rangeOfDafim.location; i<self.rangeOfDafim.location+self.rangeOfDafim.length; i++) {
            Daf* page =[Daf folioWithPage:i];
            page.tractate=self;
            [array addObject:page];
        }
        
        dafim=[NSArray arrayWithArray:array];
        
    }
    return dafim;
}
//Return YES if it in fact starts to download
-(BOOL) downloadIfNeed{
    BOOL toReturn=NO;
    self.DownloadedPages=0;
    for (Daf* page in self.dafim) {
        BOOL thisPageNeedDownload=[page download];
        if (thisPageNeedDownload) {
            toReturn=YES;
        }else{
            self.DownloadedPages+=1;
        }
    }
    if (toReturn) {
        self.LastDownloadCheck=nil;
        self.progressDelegate.hidden=NO;
        [self.progressDelegate setProgress:((float)self.DownloadedPages/(float)self.rangeOfDafim.length)];
    }
    return toReturn;
}
-(BOOL) isDownloaded{
    if (self.LastDownloadCheck) {
        return [self.LastDownloadCheck boolValue];
    }
    
    if (self.DownloadedPages !=self.rangeOfDafim.length && self.DownloadedPages!=0){
        return NO;
    }
    NSLog(@"doing long check to see if downloaded");
    for (Daf* page in self.dafim) {
        BOOL thisPageISDownload=[page isDownloaded];
        if (!thisPageISDownload) {
            self.LastDownloadCheck=[NSNumber numberWithBool:NO];
            return NO;
        }
    }
    self.LastDownloadCheck=[NSNumber numberWithBool: YES];
    return YES;
}

-(void) dafDownloaded:(Daf*) sender{
 //   NSLog(@"progress of %@ is %g",self.name, ((float)DownloadedPages/(float)self.rangeOfDafim.length));
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"updating to %d /%d", self.DownloadedPages, self.rangeOfDafim.length);
        self.DownloadedPages+=1;
        self.progressDelegate.hidden=NO;
        [self.progressDelegate setProgress:((float)self.DownloadedPages/(float)self.rangeOfDafim.length)];
        if (self.DownloadedPages ==self.rangeOfDafim.length) {
            self.progressDelegate.hidden=YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadComplete" object:nil];
        }
        self.LastDownloadCheck=nil;

    });
       
}
-(void) dafFailedToDownload:(Daf*) sender error:(NSError*) error{
 
    dispatch_async(dispatch_get_main_queue(), ^{
        self.LastDownloadCheck=nil;

        NSLog(@"page %d fail to download %@", sender.pageOfTalmud, [error localizedDescription]);
    });
                   
}
-(void) dealloc{
    NSLog(@"mesekta %@ is deallocing", self.name);
}
-(void) setProgressDelegate:(UIProgressView *)_progressDelegate{
    
    progressDelegate=_progressDelegate;
    
    progressDelegate.hidden=(self.DownloadedPages ==self.rangeOfDafim.length || self.DownloadedPages==0);

}
-(NSNumber*) lastLoadedPage{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-lastLoadedPage", self.name]];
}
-(void) setLastLoadedPage:(NSNumber *)lastLoadedPage{
    [[NSUserDefaults standardUserDefaults] setObject:lastLoadedPage forKey:[NSString stringWithFormat:@"%@-lastLoadedPage", self.name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
