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
    
    ExternalSubtitle* srtData = nil;
    while (index < srtTextLength) {
        switch (distinctLabel) {
            case 0: {       // Parsing Index
                srtData = [[ExternalSubtitle alloc] init];
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
                char startHourData[3];
                char startMinuteData[3];
                char startSecondData[3];
                
                memcpy(startHourData, srtText + index, 2);
                index += 3;
                
                memcpy(startMinuteData, srtText + index, 2);
                index += 3;
                
                memcpy(startSecondData, srtText + index, 2);
                index += 3;
                
                NSData* startSrtHour = [NSData dataWithBytes:startHourData length:2];
                NSString* startSrtHourStr = [[NSString alloc] initWithData:startSrtHour encoding:NSUTF8StringEncoding];
                
                NSData* startSrtMinute = [NSData dataWithBytes:startMinuteData length:2];
                NSString* startSrtMinuteStr = [[NSString alloc] initWithData:startSrtMinute encoding:NSUTF8StringEncoding];
                
                NSData* startSrtSecond = [NSData dataWithBytes:startSecondData length:2];
                NSString* startSrtSecondStr = [[NSString alloc] initWithData:startSrtSecond encoding:NSUTF8StringEncoding];
                
                NSInteger s_hour = [startSrtHourStr intValue];
                NSInteger s_minute = [startSrtMinuteStr intValue];
                NSInteger s_second = [startSrtSecondStr intValue];
                
                NSLog(@"SRT Index: %ld, hour: %ld, minute: %ld, second: %ld", (long)subtitleIndex, (long)s_hour, (long)s_minute, (long)s_second);
                
                NSInteger srtStartTime = (s_hour * 60 * 60) + (s_minute * 60) + s_second;
                srtData.subtitleStartTime = srtStartTime * 1000;
                
                NSInteger nextTimeIndex = index;
                while (true) {
                    if (srtText[nextTimeIndex] == '-' && srtText[nextTimeIndex + 1] == '-' && srtText[nextTimeIndex + 2] == '>') {
                        if (srtText[nextTimeIndex + 3] == ' ') {
                            index += 7;
                            break;
                        } else {
                            index += 5;
                            break;
                        }
                    }
                    
                    if (nextTimeIndex >= srtTextLength) {
                        break;
                    }
                    nextTimeIndex ++;
                }
//                index += 7;     // Skip the miliseconds & ' --> '
                
                char endHourData[3];
                char endMinuteData[3];
                char endSecondData[3];
                
                memcpy(endHourData, srtText + index, 2);
                index += 3;
                
                memcpy(endMinuteData, srtText + index, 2);
                index += 3;
                
                memcpy(endSecondData, srtText + index, 2);
                index += 3;
                
                NSData* endSrtHour = [NSData dataWithBytes:endHourData length:2];
                NSString* endSrtHourStr = [[NSString alloc] initWithData:endSrtHour encoding:NSUTF8StringEncoding];

                NSData* endSrtMinute = [NSData dataWithBytes:endMinuteData length:2];
                NSString* endSrtMinuteStr = [[NSString alloc] initWithData:endSrtMinute encoding:NSUTF8StringEncoding];

                NSData* endSrtSecond = [NSData dataWithBytes:endSecondData length:2];
                NSString* endSrtSecondStr = [[NSString alloc] initWithData:endSrtSecond encoding:NSUTF8StringEncoding];

                NSInteger e_hour = [endSrtHourStr intValue];
                NSInteger e_minute = [endSrtMinuteStr intValue];
                NSInteger e_second = [endSrtSecondStr intValue];

                NSLog(@"SRT Index: %ld, hour: %ld, minute: %ld, second: %ld", (long)subtitleIndex, (long)e_hour, (long)e_minute, (long)e_second);

                NSInteger srtEndTime = (e_hour * 60 * 60) + (e_minute * 60) + e_second;
                srtData.subtitleEndTime = srtEndTime * 1000;
                
                while (true) {
                    index ++;
                    
                    if (srtText[index] == '\n') {
                        distinctLabel++;
                        break;
                    }
                    if (index > srtTextLength) {
                        break;
                    }
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
                
                srtData.subtitleText = srtSubtitleData;
                [srtSubtitleArray addObject:srtData];
                
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
    
    return srtSubtitleArray;
}

@end
