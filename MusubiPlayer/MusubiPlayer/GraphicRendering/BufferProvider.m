//
//  BufferProvider.m
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/11.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import "BufferProvider.h"

@implementation BufferProvider {
    // Store the Buffers themselves
    NSMutableArray<MTLBuffer>* _uniformsBuffers;
    
    // Index of the next available buffer
    NSInteger _availableBufferIndex;
}

// Create number of Buffers
- (instancetype) init:(id<MTLDevice>)device
 inflightBuffersCount:(NSInteger)inflightBuffersCount
 sizeOfUniformsBuffer:(NSInteger)sizeOfUniformsBuffer {
    _availableResourcesSemaphore = dispatch_semaphore_create(inflightBuffersCount);
    
    _inflightBufferCount = inflightBuffersCount;
    _uniformsBuffers = (id)[NSMutableArray new];
    
    for (int i = 0; i < inflightBuffersCount; i++) {
        id<MTLBuffer> uniformsBuffer = [device newBufferWithLength:sizeOfUniformsBuffer
                                                           options:MTLResourceCPUCacheModeWriteCombined];
        [_uniformsBuffers addObject:uniformsBuffer];
    }
    return self;
}

- (void)dealloc {
    for(int i = 0; i < _inflightBufferCount - 1; i++) {
        dispatch_semaphore_signal(_availableResourcesSemaphore);
    }
}
@end
