//
//  MusubiSubtitleParser.m
//  MusubiSubtitles
//
//  Created by HanGyo Jeong on 2020/11/20.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import "MusubiSubtitleParser.h"

@implementation MusubiSubtitleParser

- (id)initWithExternalSubtitle:(NSString*)subtitlePath {
    self = [super init];
    
    self.filemgr = NSFileManager.defaultManager;
    NSArray<NSURL *> * dirPaths = [self.filemgr URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if (dirPaths != nil) {
        NSURL* dirPath = dirPaths[0];
        if (dirPath != nil) {
            NSURL* newDir = [dirPath URLByAppendingPathComponent:@"musubi"];
            
            NSError* error;
            [self.filemgr createDirectoryAtURL:newDir withIntermediateDirectories:true attributes:nil error:&error];
            
            if (error) {
                NSLog(@"Error to set musubi Directory");
            } else {
                [self.filemgr changeCurrentDirectoryPath:newDir.path];
                NSLog(@"Check the Current Directory %@", newDir.absoluteString);
            }
        }
    }
    
    
    return self;
}

@end
