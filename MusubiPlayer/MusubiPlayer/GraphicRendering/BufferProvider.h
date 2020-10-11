//
//  BufferProvider.h
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/11.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface BufferProvider : NSObject

@property(nonatomic) NSInteger inflightBufferCount;

@property(nonatomic) dispatch_semaphore_t availableResourcesSemaphore;

// Create number of buffers
- (instancetype) init:(id<MTLDevice>)device
inflightBuffersCount:(NSInteger)inflightBuffersCount
 sizeOfUniformsBuffer:(NSInteger)sizeOfUniformsBuffer;

@end

NS_ASSUME_NONNULL_END
