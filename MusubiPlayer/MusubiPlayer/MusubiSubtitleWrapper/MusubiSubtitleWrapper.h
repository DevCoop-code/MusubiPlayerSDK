//
//  MusubiSubtitleWrapper.h
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/11/19.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum SubtitleType: NSUInteger {
    remote = 1,
    local = 2
} SubtitleType;

@interface MusubiSubtitleWrapper : NSObject

- (void)initMusubiSubtitle:(NSString*)subtitlePath Type:(SubtitleType)type;

@end

NS_ASSUME_NONNULL_END
