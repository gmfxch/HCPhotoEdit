//
//  CHPhotoEditCustomButton.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCPhotoEditCustomButton : UIButton

@property(nonatomic, assign) BOOL  normalState;

-(instancetype)initWithImage:(UIImage*)image  highlightedImage:(UIImage*)hightImage title:(NSString*)title  font:(float)font imageSize:(float)size;

@end
