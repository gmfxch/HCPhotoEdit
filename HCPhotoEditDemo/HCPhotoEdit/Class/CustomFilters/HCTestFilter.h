//
//  CHTestFilter.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/15.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

@interface HCTFilter : GPUImageTwoInputFilter

@end

@interface HCTestFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource1;
}

-(id)initWithTextureImage:(UIImage*)image;

@end
