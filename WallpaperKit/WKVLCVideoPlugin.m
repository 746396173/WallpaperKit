//
//  WKVLCVideoPlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 20/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import "WKVLCVideoPlugin.h"

@implementation WKVLCVideoPlugin{
    VLCMediaPlayer* VMP;
    NSURL* URL;
}
-(instancetype)initWithWindow:(WKDesktop *)window andArguments:(NSDictionary *)args{
    self=[super initWithFrame:window.frame];
    self->VMP=[[VLCMediaPlayer alloc] initWithVideoView:self];
    self->VMP.delegate=self;
    self->URL=[args objectForKey:@"Path"];
    [self->VMP setMedia:[VLCMedia mediaWithURL:self->URL]];
    self.requiresConsistentAccess=YES;
    return self;
}
-(void)play{
    [self->VMP play];
}
-(void)pause{
    [self->VMP pause];
}
-(NSString*)description{
    return [@"WKVideoPlugin " stringByAppendingString:self->URL.path];
}
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification{
    //Loop 4ever
    VLCMediaPlayer* obj=[aNotification object];
    if([obj state]==VLCMediaPlayerStateOpening||[obj state]==VLCMediaPlayerStateBuffering){
        return ;
    }
    if([obj state]==VLCMediaPlayerStateEnded||[obj state]==VLCMediaPlayerStateStopped||[obj remainingTime].intValue==0){
        NSLog(@"Restarting");
        [self->VMP setMedia:[VLCMedia mediaWithURL:self->URL]];
        [self->VMP play];
    }
}

#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+(NSMutableDictionary*)convertArgument:(NSDictionary *)args Operation:(RenderConvertOperation)op{
    NSMutableDictionary* returnValue=[NSMutableDictionary dictionaryWithDictionary:args];
    if(op==TOJSON){
        returnValue[@"Render"]=@"WKVLCVideoPlugin";
        if([returnValue.allKeys containsObject:@"Path"]){
            returnValue[@"Path"]=[(NSURL*)returnValue[@"Path"] path];
        }
    }
    else if(op==FROMJSON){
        returnValue[@"Render"]=NSClassFromString(@"WKVLCVideoPlugin");
        if([returnValue.allKeys containsObject:@"Path"]){
            NSMutableString* url=[[args objectForKey:@"Path"] mutableCopy];
            if([url hasPrefix:@"/"]){
                [url insertString:@"file://" atIndex:0];
            }
            returnValue[@"Path"]=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return returnValue;
}
@end
