//
//  MusubiSMIParser.m
//  MusubiSubtitles
//
//  Created by HanGyo Jeong on 2020/11/19.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import "MusubiSMIParser.h"

@implementation MusubiSMIParser

- (id)initWithExternalSubtitle:(NSString*)subtitlePath {
    self = [super initWithExternalSubtitle:subtitlePath];
    
    NSFileManager* filemgr = [super filemgr];
    
    NSString* smiSubPath = [[filemgr currentDirectoryPath] stringByAppendingString:subtitlePath];
    NSLog(@"SMI Path: %@", smiSubPath);
    
    NSData* dataBuffer = [filemgr contentsAtPath:smiSubPath];
    NSString* smiText = [[NSString alloc] initWithData:dataBuffer encoding:NSUTF8StringEncoding];
    if (smiText == nil) {
        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
        smiText = [[NSString alloc] initWithData:dataBuffer encoding:encoding];
    }

    NSLog(@"SMI Text: %@", smiText);
    
    return self;
}

@end
