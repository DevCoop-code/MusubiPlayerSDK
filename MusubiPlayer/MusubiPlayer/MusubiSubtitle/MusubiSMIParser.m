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
    
    [self setSubtitleLinkArray:[self getTheSubtitleData:dataBuffer]];
    
    return self;
}

- (NSMutableArray*) getTheSubtitleData:(NSData*) subtitleData {
    const char* smiText = (const char*)[subtitleData bytes];
    NSUInteger smiTextLength = subtitleData.length;
    NSUInteger index = 0;
    
    NSMutableArray* smiSubtitleArray = [[NSMutableArray alloc] init];
    while (index < smiTextLength) {
        if (smiText[index] == '<' && smiText[index + 1] == 'S' && smiText[index + 2] == 'Y') {  // 'SYNC' Property
            index += 2;
            
            ExternalSubtitle* smiData = [[ExternalSubtitle alloc] init];
            
            NSUInteger subtitleStartIndex = 0;
            NSUInteger subtitleEndIndex = 0;

            NSUInteger subtitleTimeStartIndex = 0;
            NSUInteger subtitleTimeEndIndex = 0;
            // Search '>'
            while (smiText[index] != '>') {
                if (smiText[index] == 'S' && smiText[index + 1] == 'T' && smiText[index + 2] == 'A') {
                    subtitleTimeStartIndex = index + 6;
                }
                index++;
            }
            if (subtitleTimeStartIndex != 0) {
                subtitleTimeEndIndex = index - 1;
                
                size_t length = (subtitleTimeEndIndex - subtitleTimeStartIndex) + 1;
                char timeData[length + 1];
                memcpy(timeData, smiText + subtitleTimeStartIndex, length);
                
                NSData* data = [NSData dataWithBytes:timeData length:length];
                NSString* timeText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"subtitle start: %@", timeText);
                
                smiData.subtitleStartTime = [timeText intValue];
            }
            
            subtitleStartIndex = index;
            
            // Search End of Line
            while (smiText[index] != '\n') {
                
                // If when 'P' Tag Exists
                if ( smiText[index] == '<' && ((smiText[index + 1] == 'P') || (smiText[index + 1] == 'p')) ) {
                    do {
                        index++;
                        subtitleStartIndex = index;
//                        NSLog(@"[SMI Parser] Debug: %c", smiText[index]);
                    } while (smiText[index] != '>');
                }
                
                // If when 'font' Tag Exists
                if ( smiText[index] == '<' && ((smiText[index + 1] == 'F') || (smiText[index + 1] == 'f')) &&
                    ((smiText[index + 2] == 'O') || (smiText[index + 2] == 'o')) ) {
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
                NSString* smiSubtitleData;
                smiSubtitleData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (smiSubtitleData == nil) {
                    NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
                    smiSubtitleData = [[NSString alloc] initWithData:data encoding:encoding];
                }
                
                smiData.subtitleText = smiSubtitleData;
                
                [smiSubtitleArray addObject:smiData];
                
//                NSLog(@"subtitle Data: %@", smiSubtitleData);
            }
        }
        
        index++;
    }
    
    return smiSubtitleArray;
}
@end
