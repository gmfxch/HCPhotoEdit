//
//  CHCustomGPUImageTiltShiftFilter.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/8.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImage.h"

@interface HCCustomGPUImageTiltShiftFilter : GPUImageFilterGroup
{
    GPUImageGaussianBlurFilter *blurFilter;
    GPUImageFilter *selectiveFocusFilter;
    BOOL hasOverriddenAspectRatio;
}

@property (readwrite, nonatomic) CGFloat excludeCircleRadius;

@property (readwrite, nonatomic) CGPoint excludeCirclePoint;

@property (readwrite, nonatomic) CGFloat excludeBlurSize;

@property (readwrite, nonatomic) CGFloat blurRadiusInPixels;

@property (readwrite, nonatomic) CGFloat aspectRatio;

@property (nonatomic, readwrite) CGFloat rotation;

@end
