//
//  MusubiSRTParser.m
//  MusubiSubtitles
//
//  Created by HanGyo Jeong on 2020/11/19.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import "MusubiSRTParser.h"

@implementation MusubiSRTParser

- (id)initWithExternalSubtitle:(NSString *)subtitlePath {
    self = [super initWithExternalSubtitle:subtitlePath];
    
    NSFileManager* filemgr = [super filemgr];
    
    NSString* srtSubPath = [[filemgr currentDirectoryPath] stringByAppendingString:subtitlePath];
    
    NSData* dataBuffer = [filemgr contentsAtPath:srtSubPath];
    [self setSubtitleLinkArray:[self getTheSubtitleData:dataBuffer]];
    
    return self;
}

- (NSMutableArray*) getTheSubtitleData:(NSData*) subtitleData {
    const char* srtText = (const char*)[subtitleData bytes];
    NSUInteger srtTextLength = subtitleData.length;
    NSUInteger index = 0;
    
    NSMutableArray* srtSubtitleArray = [[NSMutableArray alloc] init];
    NSInteger subtitleIndex = 0;
    NSUInteger subtitleLength = 1;
    NSUInteger distinctLabel = 0;   // 0: subtitle index, 1: subtitle time, 2: subtitle
    while (index < srtTextLength) {
        
        switch (distinctLabel) {
            case 0: {       // Parsing Index
                if (subtitleIndex == 9) {
                    subtitleLength = 2;
                }
                else if (subtitleIndex == 99) {
                    subtitleLength = 3;
                }
                
                char srtIndex[subtitleLength + 1];
                memcpy(srtIndex, srtText + index, subtitleLength);
                NSData* data = [NSData dataWithBytes:srtIndex length:subtitleLength];
                NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                subtitleIndex = [str intValue];
                
                NSLog(@"SRT Index, %ld", (long)subtitleIndex);
                
                index += subtitleLength;    // Skip the Subtitle Index
                
                if (srtText[index] == '\n') {
                    distinctLabel ++;
                }
            }
            break;
                
            case 1: {       // Parsing Time
                char startHourData[2];
                char startMinuteData[2];
                char startSecondData[2];
                
                memcpy(startHourData, srtText + index, 2);
                index += 3;
                
                memcpy(startMinuteData, srtText + index, 2);
                index += 3;
                
                memcpy(startSecondData, srtText + index, 2);
                index += 3;
                
                index += 7;     // Skip the miliseconds & ' --> '
                
                char endHourData[2];
                char endMinuteData[2];
                char endSecondData[2];
                
                memcpy(endHourData, srtText + index, 2);
                index += 3;
                
                memcpy(endMinuteData, srtText + index, 2);
                index += 3;
                
                memcpy(endSecondData, srtText + index, 2);
                index += 3;
                
                index += 4;
                
                if (srtText[index] == '\n') {
                    distinctLabel ++;
                }
            }
            break;
            
            case 2: {       // Parsing Subtitle
                NSUInteger subtitleDataLength = 0;
                while(true) {
                    subtitleDataLength++;
                    if (index + subtitleDataLength + 1 >= srtTextLength) {
                        break;
                    }
                    
                    if ( (srtText[index + subtitleDataLength] == '\n' && srtText[index + subtitleDataLength + 1] == '\n') || (index >= srtTextLength) ) {
                        if (subtitleIndex == 9) {
                            subtitleLength = 2;
                        } else if (subtitleIndex == 99) {
                            subtitleLength = 3;
                        }
                        
                        char nextSrtIndex[subtitleLength + 1];
                        memcpy(nextSrtIndex, srtText + index + subtitleDataLength + 2, subtitleLength);
                        NSData* nextSrtIndexData = [NSData dataWithBytes:nextSrtIndex length:subtitleLength];
                        NSString* nextSrtIndexStr = [[NSString alloc] initWithData:nextSrtIndexData encoding:NSUTF8StringEncoding];
                        
                        NSInteger nextIndex = [nextSrtIndexStr intValue];
                        
                        if (nextIndex == subtitleIndex + 1) {
                            break;
                        }
                        if (index >= srtTextLength) {
                            break;
                        }
                    }
                }
                
                char srtTextData[subtitleDataLength + 1];
                memcpy(srtTextData, srtText + index, subtitleDataLength);
                
                NSData* data = [NSData dataWithBytes:srtTextData length:subtitleDataLength];
                NSString* srtSubtitleData;
                srtSubtitleData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (srtSubtitleData == nil) {
                    NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
                    srtSubtitleData = [[NSString alloc] initWithData:data encoding:encoding];
                }
                
                NSLog(@"SRT Subtitle: %@", srtSubtitleData);
                
                index += (subtitleDataLength + 1);
                distinctLabel = 0;
            }
            break;
                
            default: {
                distinctLabel = 0;
            }
            break;
        }
        
        index++;
    }
    
    return nil;
}

@end
