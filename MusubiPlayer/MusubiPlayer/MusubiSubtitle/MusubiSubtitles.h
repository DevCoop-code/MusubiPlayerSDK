//
//  MusubiSubtitles.h
//  MusubiSubtitles
//
//  Created by HanGyo Jeong on 2020/11/19.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExternalSubtitle: NSObject
    @property(nonatomic) NSString* subtitleText;
    @property(nonatomic) NSInteger subtitleStartTime;       // milisecond
    @property(nonatomic) NSInteger subtitleEndTime;         // milisecond
@end

@interface MusubiSubtitles : NSObject

- (void) setSubtitleFile:(NSString*) filePath;
- (NSMutableArray*) getSubtitleSet;

@end
