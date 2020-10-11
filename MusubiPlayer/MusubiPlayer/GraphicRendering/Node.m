//
//  Node.m
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/11.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import "Node.h"

@implementation Node {
    BufferProvider* bufferProvider;
    MetalTexture* texture;
    
    Float32 positionX, positionY, positionZ;
    
    id<MTLSamplerState> samplerState;
}

- (instancetype)init:(NSString *)name
              vertex:(NSArray<Vertex *> *)vertices
              device:(id<MTLDevice>)device {
    [self initProperty];
    
    samplerState = [self defaultSampler:device];
    
    Float32* vertexDataArray = malloc(sizeof(Float32) * [vertices count] * 9);
    
    int index = 0;
    for (int i = 0; i < [vertices count]; i++) {
        Vertex* vertexData = (Vertex*)[vertices objectAtIndex:i];
        Float32* vertexElement = vertexData.floatBuffer;
        for (int j = 0; j < 9; j++) {
            vertexDataArray[index + j] = vertexElement[j];
        }
        index += 9;
    }
    
    NSUInteger dataSize = ([vertices count] * 9) * sizeof(vertexDataArray[0]);
    _vertexBuffer = [device newBufferWithBytes:(vertexDataArray) length:dataSize options:MTLResourceCPUCacheModeWriteCombined];
    
    _name = name;
    _device = device;
    _vertexCount = [vertices count];
    
    // 16 is the 4x4 matrix size
    bufferProvider = [[BufferProvider alloc] init:device
                             inflightBuffersCount:3
                             sizeOfUniformsBuffer:sizeof(Float32) * 16 * 2];
    
    texture = [[MetalTexture alloc]init:YES];
    
    self = [super init];
    return self;
}

- (void) render:(id<MTLCommandQueue>)commandQueue
renderPipelineState:(id<MTLRenderPipelineState>)pipelineState
       drawable:(id<CAMetalDrawable>)drawable
    pixelBuffer:(CVPixelBufferRef)pixelBuffer {
    
    // Make CPU Wait
    dispatch_semaphore_wait([bufferProvider availableResourcesSemaphore], DISPATCH_TIME_FOREVER);
    
    MTLRenderPassDescriptor* renderPassDescriptor = [[MTLRenderPassDescriptor alloc]init];
    renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    
    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    /*
     Signal the semaphore when the resource becomes available
     When the GPU finishes rendering, it executes a completion handler to signal the semaphore the bumps its count back up again
     
     addCompletedHandler: Registers a block of code that Metal calls immediately after the GPU finishes executing the commands in the command buffer
     */
    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> _Nonnull commandbuffer) {
        dispatch_semaphore_signal([bufferProvider availableResourcesSemaphore]);
    }];
    
    [texture loadVideoTexture:_device commandQ:commandQueue pixelBuffer:pixelBuffer flip:YES];
    _ytexture = texture.ytexture;
    _cbcrtexture = texture.cbcrtexture;
    
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    [renderEncoder setCullMode:MTLCullModeFront];
    [renderEncoder setRenderPipelineState:pipelineState];
    [renderEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
    [renderEncoder setFragmentTexture:_ytexture atIndex:0];
    [renderEncoder setFragmentTexture:_cbcrtexture atIndex:1];
    
    if (nil != samplerState) {
        [renderEncoder setFragmentSamplerState:samplerState atIndex:0];
    }
    
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:_vertexCount instanceCount:_vertexCount/3];
    [renderEncoder endEncoding];
    
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

- (void)initProperty {
    positionX = 0.0;
    positionY = 0.0;
}

- (id<MTLSamplerState>)defaultSampler:(id<MTLDevice>)device {
    // MTLSamplerDescriptor
    // An object that you use to configure a texture sampler
    MTLSamplerDescriptor* sampler = [MTLSamplerDescriptor new];
    sampler.minFilter = MTLSamplerMinMagFilterNearest;
    sampler.magFilter = MTLSamplerMinMagFilterNearest;
    sampler.mipFilter = MTLSamplerMipFilterNearest;
    sampler.maxAnisotropy = 1;
    sampler.sAddressMode = MTLSamplerAddressModeClampToEdge;
    sampler.tAddressMode = MTLSamplerAddressModeClampToEdge;
    sampler.rAddressMode = MTLSamplerAddressModeClampToEdge;
    sampler.normalizedCoordinates = YES;
    sampler.lodMinClamp = 0;
    sampler.lodMaxClamp = FLT_MAX;
    
    return [device newSamplerStateWithDescriptor:sampler];
}

@end
