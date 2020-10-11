//
//  SquarePlain.h
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/11.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface SquarePlain : Node

- (instancetype) init:(id<MTLDevice>)device commandQ:(id<MTLCommandQueue>)commandQ;

@end

NS_ASSUME_NONNULL_END
