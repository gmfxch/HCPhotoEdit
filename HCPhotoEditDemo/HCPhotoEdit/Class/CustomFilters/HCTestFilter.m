//
//  CHTestFilter.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/15.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCTestFilter.h"
#import "HCPhotoEditViewController.h"


NSString *const HCTestShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //map
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     texel = texel * texture2D(inputImageTexture2, textureCoordinate).rgb;
     gl_FragColor = vec4(texel, 0);
 }
);



@implementation HCTFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:HCTestShaderString]))
    {
        return nil;
    }
    
    return self;
}


@end

@implementation HCTestFilter


-(id)initWithTextureImage:(UIImage*)image
{
    if (!(self = [super init]))
    {
        return nil;
    }

    
    HCTFilter *filter = [[HCTFilter alloc] init];
    [self addFilter:filter];
    //blackboard1024
    //LightFX1.jpg
    //customTexture
    UIImage *image1 = image;
    imageSource1 = [[GPUImagePicture alloc] initWithImage:image1];
    [imageSource1 addTarget:filter atTextureLocation:1];
    [imageSource1 processImage];
    
//    NSString *aBundleSourcePath = [[NSBundle mainBundle] pathForResource:@"CHPhotoEditResource" ofType:@"bundle"];
//    NSBundle *bundle = [NSBundle bundleWithPath:aBundleSourcePath];
//    NSString *path = [bundle pathForResource:@"halo_54.jpg" ofType:@"" inDirectory:@"texture/halo_54"];
//    UIImage *image =  [UIImage imageWithContentsOfFile:path];
//    
//    imageSource1 = [[GPUImagePicture alloc] initWithImage:image];
//    [imageSource1 addTarget:filter atTextureLocation:1];
//    [imageSource1 processImage];
//    
    self.initialFilters = [NSArray arrayWithObjects:filter, nil];
    self.terminalFilter = filter;
    
    return self;
 
}

@end
