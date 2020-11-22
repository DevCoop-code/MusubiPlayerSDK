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
    
    [self getTheSubtitleData:dataBuffer];
    
    return self;
}

- (NSArray*) getTheSubtitleData:(NSData*) subtitleData {
    const char* smiText = (const char*)[subtitleData bytes];
    NSUInteger smiTextLength = subtitleData.length;
    NSUInteger index = 0;
    while (index < smiTextLength) {
        if (smiText[index] == '<' && smiText[index + 1] == 'S' && smiText[index + 2] == 'Y') {  // 'SYNC' Property
            index += 2;
            
            NSUInteger subtitleStartIndex = 0;
            NSUInteger subtitleEndIndex = 0;

            // Search '>'
            while (smiText[index] != '>') {
                index++;
            }
            
            subtitleStartIndex = index;
            
            // Search End of Line
            while (smiText[index] != '\n') {
                
                // If when 'P' Tag Exists
                if ( smiText[index] == '<' && ((smiText[index + 1] == 'P') || (smiText[index + 1] == 'p')) ) {
                    do {
                        index++;
                        subtitleStartIndex = index;
                        NSLog(@"[SMI Parser] Debug: %c", smiText[index]);
                    } while (smiText[index] != '>');
                }
                index++;
            }
            
            subtitleEndIndex = index;
            
            if (subtitleStartIndex != 0 && subtitleEndIndex != 0) {
                size_t length = subtitleEndIndex - subtitleStartIndex;
                char textData[length + 1];
                memcpy(textData, smiText + (subtitleStartIndex + 1), length);

                NSData* data = [NSData dataWithBytes:textData length:length];
                NSString* smiText;
                smiText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (smiText == nil) {
                    NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
                    smiText = [[NSString alloc] initWithData:data encoding:encoding];
                }
                
                NSLog(@"subtitle Data: %@", smiText);
            }
        }
        
        index++;
    }
    
    return nil;
}
@end
