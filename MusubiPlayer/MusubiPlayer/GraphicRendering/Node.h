//
//  Node.h
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/11.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <Metal/Metal.h>
#import "BufferProvider.h"
#import "Vertex.h"
#import "MetalTexture.h"

NS_ASSUME_NONNULL_BEGIN

@interface Node : NSObject

@property(nonatomic) id<MTLDevice> device;
@property(nonatomic) NSString* name;
@property(nonatomic) NSInteger vertexCount;
@property(nonatomic) id<MTLBuffer> vertexBuffer;
@property(nonatomic) CFTimeInterval time;
@property(nonatomic) id<MTLTexture> ytexture;
@property(nonatomic) id<MTLTexture> cbcrtexture;

- (instancetype) init:(NSString*)name
               vertex:(NSArray<Vertex*>*)vertices
               device:(id<MTLDevice>)device;

- (void) render:(id<MTLCommandQueue>)commandQueue
renderPipelineState:(id<MTLRenderPipelineState>) pipelineState
       drawable:(id<CAMetalDrawable>)drawable
    pixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
