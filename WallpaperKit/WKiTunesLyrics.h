//
//  WCiTunesLyrics.h
//  WallpaperKit
//
//  Created by Naville Zhang on 19/02/2017.
//  Copyright © 2017 NavilleZhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WKDesktop.h"
#import "iTunes.h"
#import "LyricManager.h"
#import "Lyric.h"
@interface WKiTunesLyrics : NSView<WKRenderProtocal>
/**
 Init Plugin
 
 @param window NSWindow to draw in.Caller will handle view adding
 @param args Not Used
 */
- (instancetype)initWithWindow:(WKDesktop*)window andArguments:(NSDictionary*)args;
@property (nonatomic) BOOL requiresConsistentAccess;
@end
