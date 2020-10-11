//
//  MetalTexture.h
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/11.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <UIKit/UIKit.h>
#import <VideoToolbox/VideoToolbox.h>
#import <CoreVideo/CoreVideo.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetalTexture : NSObject

@property(nonatomic) id<MTLTexture> ytexture;
@property(nonatomic) id<MTLTexture> cbcrtexture;
@property(nonatomic) MTLTextureType target;
@property(nonatomic) size_t width;
@property(nonatomic) size_t height;
@property(nonatomic) NSInteger depth;
@property(nonatomic) MTLPixelFormat format;
@property(nonatomic) Boolean hasAlpha;
@property(nonatomic) NSString* path;
@property(nonatomic) Boolean isMipmaped;
@property(nonatomic) NSInteger bytesPerPixel;
@property(nonatomic) NSInteger bitsPerComponent;

- (instancetype) init:(Boolean)mipmaped;
- (void) loadVideoTexture:(id<MTLDevice>)device
                 commandQ:(id<MTLCommandQueue>)commandQ
              pixelBuffer:(CVPixelBufferRef)pixelBuffer
                     flip:(Boolean)flip;
@end

NS_ASSUME_NONNULL_END
