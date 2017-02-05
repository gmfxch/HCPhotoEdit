//
//  CHPhotoEditBaseItemView.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCPhotoEditBaseScrollView.h"
#import "HCPhotoEditBaseImageView.h"

@interface HCPhotoEditBaseItemView : UIView<HCPhotoEditBaseScrollViewDelegate>

@property(nonatomic, copy)void(^selectItemBlock)(NSInteger index);
@property(nonatomic, copy)void(^cancelBlock)();
@property(nonatomic, copy)void(^okBlock)();

@property(nonatomic, weak) HCPhotoEditBaseImageView  *mainImageView;
@property(nonatomic, strong) UIImage    *oriImage;

+(HCPhotoEditBaseItemView*)showInView:(UIView*)view;
+(HCPhotoEditBaseItemView*)showInView:(UIView*)view  icons:(NSArray*)icons;

@end
