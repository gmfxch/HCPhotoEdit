//
//  UIImage+CHImageConfig.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/15.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HCImageConfig)

-(UIImage*)newImageWithRotation:(UIImageOrientation)orientation;
-(UIImage*)newImageWithFlipX;
-(UIImage*)newImageWithFlipY;

@end
