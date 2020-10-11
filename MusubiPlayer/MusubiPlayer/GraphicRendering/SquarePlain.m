//
//  SquarePlain.m
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/11.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

#import "SquarePlain.h"

@implementation SquarePlain

- (instancetype) init:(id<MTLDevice>)device commandQ:(id<MTLCommandQueue>)commandQ {
    Vertex *A = [[Vertex alloc] init:-1.0 y: 1.0 z:0.0 r:1.0 g:0.0 b:0.0 a:1.0 s:1.0 t:0.0];
    Vertex *B = [[Vertex alloc] init:-1.0 y:-1.0 z:0.0 r:0.0 g:1.0 b:0.0 a:1.0 s:1.0 t:1.0];
    Vertex *C = [[Vertex alloc] init: 1.0 y:-1.0 z:0.0 r:0.0 g:0.0 b:1.0 a:1.0 s:0.0 t:1.0];
    Vertex *D = [[Vertex alloc] init: 1.0 y: 1.0 z:0.0 r:0.1 g:0.6 b:0.4 a:1.0 s:0.0 t:0.0];
    
    NSArray<Vertex*> *verticesArray = @[
    A,B,C ,A,C,D
    ];
    
    self = [super init:@"SquarePlain" vertex:verticesArray device:device];
    return self;
}

@end
