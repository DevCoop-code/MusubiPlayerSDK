//
//  MusubiSubtitleParser.h
//  MusubiSubtitles
//
//  Created by HanGyo Jeong on 2020/11/20.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusubiSubtitles.h"

NS_ASSUME_NONNULL_BEGIN

#define musubiSubtitle_version @"0.0.4.beta"

@interface MusubiSubtitleParser : NSObject

@property(nonatomic) NSFileManager* filemgr;
@property(nonatomic) NSMutableArray* subtitleLinkArray;
//@property(nonatomic) NSArray<ExternalSubtitle *>* subtitleLinkArray;

- (id)initWithExternalSubtitle:(NSString*)subtitlePath;

- (NSString*) getCurrentRootDirectoory;
- (void) setSubtitleLinkArray:(NSMutableArray*) array;
- (NSMutableArray*) setSubtitleLinkArray;
@end

NS_ASSUME_NONNULL_END
