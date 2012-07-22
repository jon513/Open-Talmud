//
//  Folio.m
//  iTalmud
//
//  Created by Jonathan Rose on 1/25/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//
#import "Mesektah.h"
#import "Daf.h"
#include <sys/xattr.h>

@implementation Daf
@synthesize pageOfTalmud;
@synthesize isDownloading;
@synthesize tractate;
@synthesize connection;
@synthesize data;
@synthesize downloadURLIndex;
-(int) relativePage{
    return self.pageOfTalmud  -self.tractate.rangeOfDafim.location;
}
-(BOOL) deleteLocalFile{
  return  [[NSFileManager defaultManager] removeItemAtURL:self.localURL error:nil];
}
-(NSString*) HebrewStringForInt:(int) number{
    if (number ==15) {
        return @"טו";
    }
    if (number==16) {
        return @"טז";
    }
    
    
    NSMutableString* toReturn=[NSMutableString string];
    while (number > 400) {
        number-=100;
        [toReturn appendString:@"ת"];
    }
    
    if (number >= 300) {
        [toReturn appendString:@"ש"];
        number-=300;
    }else if (number >= 200) {
        [toReturn appendString:@"ר"];
        number-=200;
    }else if (number >= 100) {
        [toReturn appendString:@"ק"];
        number-=100;
    }
    
    if (number >= 90) {
        [toReturn appendString:@"צ"];
    }else if (number >= 80) {
        [toReturn appendString:@"פ"];
    }else if (number >= 70) {
        [toReturn appendString:@"ע"];
    }else if (number >= 60) {
        [toReturn appendString:@"ס"];
    }else if (number >= 50) {
        [toReturn appendString:@"נ"];
    }else if (number >= 40) {
        [toReturn appendString:@"מ"];
    }else if (number >= 30) {
        [toReturn appendString:@"ל"];
    }else if (number >= 20) {
        [toReturn appendString:@"כ"];
    }else if (number >= 10) {
        [toReturn appendString:@"י"];
    }
    
    
    if (number %10 ==9) {
        [toReturn appendString:@"ט"];
    }else if (number %10 ==8) {
        [toReturn appendString:@"ח"];
    }else if (number %10 ==7) {
        [toReturn appendString:@"ז"];
    }else if (number %10 ==6) {
        [toReturn appendString:@"ו"];
    }else if (number %10 ==5) {
        [toReturn appendString:@"ה"];
    }else if (number %10 ==4) {
        [toReturn appendString:@"ד"];
    }else if (number %10 ==3) {
        [toReturn appendString:@"ג"];
    }else if (number %10 ==2) {
        [toReturn appendString:@"ב"];
    }else if (number %10 ==1) {
        [toReturn appendString:@"א"];
    }
      
    return toReturn;
}
-(NSString*) displayName{
    int daf=(self.relativePage/2)+2;
    NSString *amud=(self.relativePage % 2)? @":": @".";
    
    return [NSString stringWithFormat:@"%@ - %@%@", NSLocalizedString(self.tractate.name, @""), [self   HebrewStringForInt: daf], amud];
}
-(NSString*) description{
    return [self displayName];
}
-(NSString*) fileName{
    return [NSString stringWithFormat:@"%d.pdf", self.pageOfTalmud];
}
-(NSArray*) downloadURLs{
    NSString* fileName=self.fileName;
    return [NSArray arrayWithObjects:
            [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", PDF_DAF_CACHE_SERVER, fileName]],   
            [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", PDF_DAF_PRIMARY_SERVER, fileName]],
             nil];
}
-(NSURL*) downloadURL{
    NSURL* toReturn=nil;
    @try {
        toReturn=[self.downloadURLs objectAtIndex:downloadURLIndex];;
    }
    @catch (NSException *exception) {}
    
    return toReturn;
    
}
-(NSURL*) localURL{
   return  [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"talmud" isDirectory:YES] URLByAppendingPathComponent:self.fileName];
}

-(BOOL) isDownloaded{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self.localURL path]];
    int fileSize=0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.localURL path]] ) {
        NSDictionary* attributes=[[NSFileManager defaultManager] attributesOfItemAtPath:[self.localURL path] error:NULL];
        fileSize=[attributes fileSize];
    }
    return (fileSize!=0);
}
-(id) initWithPage:(int) page{
    self=[super init];
    if (self){
        self.pageOfTalmud=page;
    }
    return self;
}
+(id) folioWithPage:(int) page{
    return [[Daf alloc] initWithPage:page];
}
-(void) downloadFailed{
  //  NSLog(@"download failed of %@", self.downloadURL);
    NSArray* downloadURLS=self.downloadURLs;
    downloadURLIndex++;
    if (downloadURLIndex < [downloadURLS count]){
        [self download]; // try again with new index
    }else{
        downloadURLIndex=0; //reset to try again
        [self.tractate dafFailedToDownload:self error:nil];

    }
}
-(BOOL) download{
    if (!self.isDownloaded) { 
        if (!self.connection) {
            
            NSURLRequest* request=[NSURLRequest requestWithURL:self.downloadURL];
          //  NSLog(@"starting download of %@", self.downloadURL);
            self.connection=[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
            if (self.connection) {
                self.data=[NSMutableData data];
            }else{
                [self downloadFailed];
               
                NSLog(@"count not create connection for %@", self.displayName);
            }
        }else{
           // NSLog(@"download request on downloading object %@", self.displayName);
        }
        return YES;
    }
    
    return NO;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response.MIMEType isEqualToString:@"application/pdf"]) {
        [self.data setLength:0];
    }else{
        [self.connection cancel];
        self.connection=nil;
        [self downloadFailed];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)rdata
{
    [self.data appendData:rdata];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.data=nil;
    self.connection=nil;
    /*
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
     */
    [self downloadFailed];

}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.connection=nil;

    [[NSFileManager defaultManager] createDirectoryAtPath:[[self.localURL path] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:NULL];
     
     if ([self.data writeToURL:self.localURL atomically:YES]) {
        const char* filePath = [[self.localURL path ] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        result=result; //result is whether it set this bit correctly;  do this setting to suppress warning;
        [self.tractate dafDownloaded:self];
        
    } else{
        [self downloadFailed];        
    }
  
}
-(NSURL*) notesURL{
    NSString* notesName=[NSString stringWithFormat:@"NOTES_For_%@.txt", self.displayName];
    return  [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:notesName];

}
-(NSString*) notes{
    NSString* toReturn=nil;
    toReturn=[NSString stringWithContentsOfURL:[self notesURL] encoding:NSUTF8StringEncoding error:NULL];
    return toReturn;
}
-(void) setNotes:(NSString *)notes{
    if ([notes length]>0) {
        [notes writeToURL:[self notesURL] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }else{
        [[NSFileManager defaultManager] removeItemAtURL:[self notesURL] error:NULL];
    }
    
     
     
}
-(BOOL) isEqual:(id)object{
    if ([object isKindOfClass:[Daf class]]) {
        return  ( ((Daf*) object).pageOfTalmud==self.pageOfTalmud);
    }
    return [super isEqual:object];
}
-(Daf*) nextDaf{
    NSArray* dafim=self.tractate.dafim;
    int index=[dafim indexOfObject:self];
    Daf* toReturn=nil;
    @try {
        toReturn=[dafim objectAtIndex:index+1];
    }
    @catch (NSException *exception) {}
    
    return toReturn;
}
-(Daf*) previousDaf{
    NSArray* dafim=self.tractate.dafim;
    int index=[dafim indexOfObject:self];
    Daf* toReturn=nil;
    @try {
        toReturn=[dafim objectAtIndex:index-1];
    }
    @catch (NSException *exception) {}
    
    return toReturn;
}
@end
