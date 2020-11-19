//
//  MusubiSubtitleWrapper.m
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/11/19.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import "MusubiSubtitleWrapper.h"
#include "MusubiSubtitles.h"

@implementation MusubiSubtitleWrapper

- (void)initMusubiSubtitle:(NSString*)subtitlePath Type:(SubtitleType)type {
    MusubiSubtitles* musubiSubtitle = [[MusubiSubtitles alloc] init];
    
    [musubiSubtitle setSubtitleFile:subtitlePath];
}

@end
