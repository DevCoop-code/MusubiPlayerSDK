//
//  MetalTexture.m
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/11.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import "MetalTexture.h"

@implementation MetalTexture {
    CGColorSpaceRef colorSpace;
    CVMetalTextureCacheRef textureCache;
}

- (instancetype)init:(Boolean)mipmaped {
    _width = 0;
    _height = 0;
    _depth = 1;
    _ytexture = nil;
    _cbcrtexture = nil;
    _isMipmaped = mipmaped;
    
    self = [super init];
    return self;
}

- (void)loadVideoTexture:(id<MTLDevice>)device
   commandQ:(id<MTLCommandQueue>)commandQ
pixelBuffer:(CVPixelBufferRef)pixelBuffer
                    flip:(Boolean)flip {
    
    _width = CVPixelBufferGetWidth(pixelBuffer);
    _height = CVPixelBufferGetHeight(pixelBuffer);
    
    if (textureCache == nil) {
        CVMetalTextureCacheRef yTextureCache, cbcrTextureCache;
        CVMetalTextureRef yTextureOut, cbcrTextureOut;
        
        /*
        Make Y Texture
        */
        CVReturn yresult = CVMetalTextureCacheCreate(kCFAllocatorDefault,
                                                     nil,
                                                     device,
                                                     nil,
                                                     &yTextureCache);
        
        if (yresult == kCVReturnSuccess) {
            textureCache = yTextureCache;
        }
        else {
            NSLog(@"Unable to allocate luma texture cache");
        }
        
        CVReturn yresultAboutTexture = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                                 textureCache,
                                                                                 pixelBuffer,
                                                                                 nil,
                                                                                 MTLPixelFormatR8Unorm,
                                                                                 _width,
                                                                                 _height,
                                                                                 0,
                                                                                 &yTextureOut);
        if (yresultAboutTexture != kCVReturnSuccess) {
            NSLog(@"Fail to make texture %d", yresultAboutTexture);
        }
        _ytexture = CVMetalTextureGetTexture(yTextureOut);
        
        /*
         Make CbCr Texture
         */
        CVReturn cbcrresult = CVMetalTextureCacheCreate(kCFAllocatorDefault,
                                                        nil,
                                                        device,
                                                        nil,
                                                        &cbcrTextureCache);
        if (cbcrresult == kCVReturnSuccess) {
            textureCache = cbcrTextureCache;
        }
        else {
            NSLog(@"Unable to allocate chroma texture cache");
        }
        CVReturn cbcrresultAboutTexture = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                        textureCache,
                                                                        pixelBuffer,
                                                                        nil,
                                                                        MTLPixelFormatRG8Unorm,
                                                                        _width/2,
                                                                        _height/2,
                                                                        1,
                                                                        &cbcrTextureOut);
        if (cbcrresultAboutTexture != kCVReturnSuccess) {
            NSLog(@"Fail to make texture %d", cbcrresultAboutTexture);
        }
        _cbcrtexture = CVMetalTextureGetTexture(cbcrTextureOut);
        
        // Release the Texture
        if (yTextureCache != nil) {
            CFRelease(yTextureCache);
            yTextureCache = nil;
        }
        if (textureCache != nil) {
            CFRelease(textureCache);
            textureCache = nil;
        }
        if (cbcrTextureCache != nil) {
            cbcrTextureCache = nil;
        }
        if (yTextureOut != nil) {
            CVBufferRelease(yTextureOut);
            yTextureOut = nil;
        }
        if (cbcrTextureOut != nil) {
            CVBufferRelease(cbcrTextureOut);
            cbcrTextureOut = nil;
        }
    }
}

@end
