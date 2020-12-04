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

@implementation ExternalSubtitle

@end

@implementation MusubiSubtitles {
    MusubiSubtitleParser* subtitleParser;
}

- (void) setSubtitleFile:(NSString*) filePath {
    NSLog(@"Subtitle File Path: %@", filePath);
    
    NSArray* arrString = [filePath componentsSeparatedByString:@"."];
    
    NSString* subtitleExtension = [arrString objectAtIndex:([arrString count] - 1)];
    
    NSLog(@"Subtitle extension: %@", subtitleExtension);
    
    if ([subtitleExtension  isEqual: @"smi"] || [subtitleExtension  isEqual: @"SMI"]) {
        subtitleParser = [[MusubiSMIParser alloc] initWithExternalSubtitle: filePath];
    }
    else if ([subtitleExtension  isEqual: @"srt"] || [subtitleExtension  isEqual: @"SRT"]) {
        subtitleParser = [[MusubiSRTParser alloc] initWithExternalSubtitle: filePath];
    }
    else {
        NSLog(@"[WARNING] NOT Support Subtitle extension Format: %@", subtitleExtension);
    }
}

- (void) setSubtitleURL:(NSString*) subtitleURL {
    NSLog(@"Subtitle URL: %@", subtitleURL);
    
    NSArray* arrString = [subtitleURL componentsSeparatedByString:@"."];
    
    NSString* subtitleExtension = [arrString objectAtIndex:([arrString count] - 1)];
    
    NSLog(@"Subtitle extension: %@", subtitleExtension);
    
    if ([subtitleExtension  isEqual: @"smi"] || [subtitleExtension  isEqual: @"SMI"]) {
        subtitleParser = [[MusubiSMIParser alloc] initExternalSubtitleOverHTTP:subtitleURL];
    }
    else if ([subtitleExtension  isEqual: @"srt"] || [subtitleExtension  isEqual: @"SRT"]) {
        subtitleParser = [[MusubiSRTParser alloc] initExternalSubtitleOverHTTP:subtitleURL];
    }
    else {
        NSLog(@"[WARNING] NOT Support Subtitle extension Format: %@", subtitleExtension);
    }
}

- (NSMutableArray*) getSubtitleSet {
    return subtitleParser.subtitleLinkArray;
}

@end
