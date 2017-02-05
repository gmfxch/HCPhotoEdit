//
//  CHCustomGPUImageTiltShiftFilter.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/8.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCCustomGPUImageTiltShiftFilter.h"
#import <OpenGLES/EAGL.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <math.h>


#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kHCCustomGPUImageTiltShiftFilterShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform lowp float excludeCircleRadius;
 uniform lowp vec2 excludeCirclePoint;
 uniform lowp float excludeBlurSize;
 uniform highp float aspectRatio;
 uniform highp float rotation;
 
 void main()
 {
     lowp vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     highp vec2 textureCoordinateToUse = vec2(textureCoordinate2.x, (textureCoordinate2.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
     
     highp float distanceFromCenter = abs((textureCoordinate2.x - excludeCirclePoint.x) * aspectRatio*cos(rotation) + (textureCoordinate2.y-excludeCirclePoint.y)*sin(rotation));
     
     gl_FragColor = mix(sharpImageColor, blurredImageColor, smoothstep(excludeCircleRadius - excludeBlurSize, excludeCircleRadius, distanceFromCenter));
 }
);

#endif

@implementation HCCustomGPUImageTiltShiftFilter

@synthesize excludeCirclePoint = _excludeCirclePoint, excludeCircleRadius = _excludeCircleRadius, excludeBlurSize = _excludeBlurSize;
@synthesize blurRadiusInPixels = _blurRadiusInPixels;
@synthesize aspectRatio = _aspectRatio;
@synthesize rotation = _rotation;

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    hasOverriddenAspectRatio = NO;
    
    // First pass: apply a variable Gaussian blur
    blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [self addFilter:blurFilter];
    
    // Second pass: combine the blurred image with the original sharp one
    selectiveFocusFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:kHCCustomGPUImageTiltShiftFilterShaderString];
    [self addFilter:selectiveFocusFilter];
    
    // Texture location 0 needs to be the sharp image for both the blur and the second stage processing
    [blurFilter addTarget:selectiveFocusFilter atTextureLocation:1];
    
    // To prevent double updating of this filter, disable updates from the sharp image side
    self.initialFilters = [NSArray arrayWithObjects:blurFilter, selectiveFocusFilter, nil];
    self.terminalFilter = selectiveFocusFilter;
    
    self.blurRadiusInPixels = 5.0;
    
    self.excludeCircleRadius = 60.0/320.0;
    self.excludeCirclePoint = CGPointMake(0.5f, 0.5f);
    self.excludeBlurSize = 30.0/320.0;
    self.rotation = 0.0;
    
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
{
    CGSize oldInputSize = inputTextureSize;
    [super setInputSize:newSize atIndex:textureIndex];
    inputTextureSize = newSize;
    
    if ( (!CGSizeEqualToSize(oldInputSize, inputTextureSize)) && (!hasOverriddenAspectRatio) && (!CGSizeEqualToSize(newSize, CGSizeZero)) )
    {
        _aspectRatio = (inputTextureSize.width / inputTextureSize.height);
        [selectiveFocusFilter setFloat:_aspectRatio forUniformName:@"aspectRatio"];
    }
}

#pragma mark -
#pragma mark Accessors

- (void)setBlurRadiusInPixels:(CGFloat)newValue;
{
    blurFilter.blurRadiusInPixels = newValue;
}

- (CGFloat)blurRadiusInPixels;
{
    return blurFilter.blurRadiusInPixels;
}

- (void)setExcludeCirclePoint:(CGPoint)newValue;
{
    _excludeCirclePoint = newValue;
    [selectiveFocusFilter setPoint:newValue forUniformName:@"excludeCirclePoint"];
}

- (void)setExcludeCircleRadius:(CGFloat)newValue;
{
    _excludeCircleRadius = newValue;
    [selectiveFocusFilter setFloat:newValue forUniformName:@"excludeCircleRadius"];
}

- (void)setExcludeBlurSize:(CGFloat)newValue;
{
    _excludeBlurSize = newValue;
    [selectiveFocusFilter setFloat:newValue forUniformName:@"excludeBlurSize"];
}

- (void)setAspectRatio:(CGFloat)newValue;
{
    hasOverriddenAspectRatio = YES;
    _aspectRatio = newValue;
    [selectiveFocusFilter setFloat:_aspectRatio forUniformName:@"aspectRatio"];
}

-(void)setRotation:(CGFloat)rotation
{
    _rotation = rotation;
    [selectiveFocusFilter setFloat:rotation forUniformName:@"rotation"];
}

@end

