//
//  WKVideoPlugin.m
//  WallpaperKit
//
//  Created by Naville Zhang on 2017/1/9.
//  Copyright © 2017年 NavilleZhang. All rights reserved.
//

#import "WKVideoPlugin.h"
@implementation WKVideoPlugin {
        NSURL *URL;
}
- (instancetype)initWithWindow:(WKDesktop *)window
                  andArguments:(NSDictionary *)args {
        NSRect frameRect = window.frame;
        [window setBackgroundColor:[NSColor blackColor]];
        self = [super initWithFrame:frameRect];
        self->URL = [args objectForKey:@"Path"];
        self.player = [AVPlayer playerWithURL:[args objectForKey:@"Path"]];
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        self.showsSharingServiceButton = NO;
        self.showsFrameSteppingButtons = NO;
        self.showsFullScreenToggleButton = NO;
        self.controlsStyle = AVPlayerViewControlsStyleNone;
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(observer:)
                   name:AVPlayerItemDidPlayToEndTimeNotification
                 object:[self.player currentItem]];
        self.requiresConsistentAccess = YES;
        self.requiresExclusiveBackground = YES;
        self.arg=args;
        return self;
}
- (void)observer:(NSNotification *)notif {
        if ([notif.name
                isEqualToString:AVPlayerItemDidPlayToEndTimeNotification]) {
                AVPlayerItem *p = [notif object];
                [p seekToTime:kCMTimeZero];
        }
}
- (void)pause {
        [self.player pause];
}
- (void)play {
        [self.player play];
}
- (void)stop {
        [self pause];
}
- (NSString *)description {
        return [@"WKVideoPlugin " stringByAppendingString:self->URL.path];
}
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (NSMutableDictionary *)convertArgument:(NSDictionary *)args
                               Operation:(WKSerializeOption)op {
        NSMutableDictionary *returnValue =
            [NSMutableDictionary dictionaryWithDictionary:args];
        if (op == TOJSON) {
                returnValue[@"Render"] = @"WKVideoPlugin";
                if ([returnValue.allKeys containsObject:@"Path"]) {
                        returnValue[@"Path"] =
                            [(NSURL *)returnValue[@"Path"] absoluteString];
                }
        } else if (op == FROMJSON) {
                returnValue[@"Render"] = NSClassFromString(@"WKVideoPlugin");
                if ([returnValue.allKeys containsObject:@"Path"]) {
                        returnValue[@"Path"] =
                            [NSURL URLWithString:[args objectForKey:@"Path"]];
                }
        }

        return returnValue;
}
@end
