//
//  HCPhotoEditBaseItemView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditBaseItemView.h"
#import "HCPhotoEditBaseScrollView.h"

@interface HCPhotoEditBaseItemView()<HCPhotoEditBaseScrollViewDelegate>

@end

@implementation HCPhotoEditBaseItemView

-(void)dealloc
{
    NSLog(@"%s",__func__);
}

#pragma mark delegate
-(void)didClickButtonAtIndex:(NSInteger)index
{
//    if (self.selectItemBlock) {
//        self.selectItemBlock(index);
//    }
}

-(void)okEdit
{
    [self hide];
    if (self.okBlock) {
        self.okBlock();
    }
}

-(void)cancelEdit
{
    [self hide];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

-(void)hide
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 150);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+(HCPhotoEditBaseItemView*)showInView:(UIView*)view
{
    return [[HCPhotoEditBaseItemView alloc] init];
}

@end
