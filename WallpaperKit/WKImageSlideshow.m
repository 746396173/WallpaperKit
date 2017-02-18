//
//  WKImageSlideshow.m
//  WallpaperKit
//
//  Created by Naville Zhang on 15/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKImageSlideshow.h"
@implementation WKImageSlideshow{
    NSArray* ImageURLList;
    unsigned int interval;
    NSString* descript;
    NSOperationQueue* op;
}
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args{
    NSError* error;
    NSRect frameRect=window.frame;
    self=[super initWithFrame:frameRect];
    [window setOpaque:YES];
    [window setBackgroundColor:[NSColor blackColor]];
    [self setImageScaling:NSImageScaleProportionallyUpOrDown];
    self->ImageURLList=[args objectForKey:@"Images"];
    if(self->ImageURLList==nil){
        self->descript=[@"ImagePath: " stringByAppendingString:[[(NSURL*)[args objectForKey:@"ImagePath"]  absoluteString] stringByRemovingPercentEncoding] ];
        self->ImageURLList=[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[args objectForKey:@"ImagePath"] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    }
    else{
        self->descript=[self->ImageURLList componentsJoinedByString:@"\n"];
    }
    if(self->ImageURLList==0){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"ImageList is empty" userInfo:args];
    }
    
    if([args.allKeys containsObject:@"Interval"]){
        self->interval=[[args objectForKey:@"Interval"] unsignedIntValue];
    }
    else{
        self->interval=10;
    }
    self->op=[NSOperationQueue new];
    [self->op setMaxConcurrentOperationCount:1];//Single Thread
    if(error!=nil){
        [window setErr:error];
    }
    self.requiresConsistentAccess=NO;
    return self;
}
- (void)ImageUpdate{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOperation = operation;
    [operation addExecutionBlock: ^ {
        NSUInteger index=0;
        while(true){
            if ([weakOperation isCancelled]) return;
            [self performSelectorOnMainThread:@selector(setImage:) withObject:[[NSImage alloc] initWithContentsOfURL:ImageURLList[index]] waitUntilDone:YES];
            [self setNeedsDisplay];
            sleep(self->interval);
            index=(index+1)%ImageURLList.count;
        }
    }];
    [self->op addOperation:operation];
}
-(void)play{
    [self ImageUpdate];
}
-(void)pause{
    [self->op cancelAllOperations];
}
-(NSString*)description{
    return [@"WKImageSlideshow " stringByAppendingString:self->descript];
}
@end
