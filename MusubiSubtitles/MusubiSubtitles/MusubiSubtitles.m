//
//  MusubiSubtitles.m
//  MusubiSubtitles
//
//  Created by HanGyo Jeong on 2020/11/19.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import "MusubiSubtitles.h"
#import "MusubiSubtitleParser.h"
#import "MusubiSMIParser.h"
#import "MusubiSRTParser.h"

@implementation MusubiSubtitles

- (void) setSubtitleFile:(NSString*) filePath {
    NSLog(@"Subtitle File Path: %@", filePath);
    
    NSArray* arrString = [filePath componentsSeparatedByString:@"."];
    
    NSString* subtitleExtension = [arrString objectAtIndex:([arrString count] - 1)];
    
    NSLog(@"Subtitle extension: %@", subtitleExtension);
    
    MusubiSubtitleParser* subtitleParser;
    
    if ([subtitleExtension  isEqual: @"smi"] || [subtitleExtension  isEqual: @"SMI"]) {
        subtitleParser = [[MusubiSMIParser alloc] init];
    }
    else if ([subtitleExtension  isEqual: @"srt"] || [subtitleExtension  isEqual: @"SRT"]) {
        subtitleParser = [[MusubiSRTParser alloc] init];
    }
    else {
        NSLog(@"NOT Support Subtitle extension Format: %@", subtitleExtension);
    }
}

@end
