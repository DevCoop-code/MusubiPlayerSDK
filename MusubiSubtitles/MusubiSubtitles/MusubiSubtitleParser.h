//
//  MusubiSubtitleParser.h
//  MusubiSubtitles
//
//  Created by HanGyo Jeong on 2020/11/20.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct ExternalSubtitle {
    NSString* subtitleText;
    NSInteger subtitleTime;
} ExternalSubtitle;

@interface MusubiSubtitleParser : NSObject

@property(nonatomic) NSFileManager* filemgr;

- (id)initWithExternalSubtitle:(NSString*)subtitlePath;

@end

NS_ASSUME_NONNULL_END
