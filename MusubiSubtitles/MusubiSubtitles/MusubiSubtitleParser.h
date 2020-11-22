//
//  MusubiSubtitleParser.h
//  MusubiSubtitles
//
//  Created by HanGyo Jeong on 2020/11/20.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExternalSubtitle: NSObject
    @property(nonatomic) NSString* subtitleText;
    @property(nonatomic) NSInteger subtitleTime;
@end

@interface MusubiSubtitleParser : NSObject

@property(nonatomic) NSFileManager* filemgr;
@property(nonatomic) NSArray<ExternalSubtitle *>* subtitleLinkArray;

- (id)initWithExternalSubtitle:(NSString*)subtitlePath;

- (NSString*) getCurrentRootDirectoory;

@end

NS_ASSUME_NONNULL_END
