//
//  HCPhotoEditRotateItemView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/7.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditRotateItemView.h"
#import "UIImage+HCImageConfig.h"


typedef NS_ENUM(NSInteger, HCImageOrientation){
    
    HCImageOrientation_Up = 0,
    HCImageOrientation_Left,
    HCImageOrientation_Bottom,
    HCImageOrientation_Right,
    
};

@implementation HCPhotoEditRotateItemView
{
    HCImageOrientation  _currentOrientation;
    BOOL                _flipX;
    BOOL                _flipY;
    UIImage             *_oriImage;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *images = @[@"photo_rotate_left_90",@"photo_rotate_right_90",@"photo_rotate_vertical_mirrored",@"photo_rotate_horizontal_mirrored"];
//        NSArray *titles = @[@"滤镜",@"滤镜",@"滤镜",@"滤镜",@"滤镜"];
        HCPhotoEditBaseScrollView *scrollView = [[HCPhotoEditBaseScrollView alloc] initWithFrame:self.bounds bottomTitle:@"旋转" imagesNameArray:images titlesArray:nil buttonWidth:self.bounds.size.width/4.0 imageSize:30];
        scrollView.delegate = self;
        scrollView.ignoreButtonSelect = YES;
        [self addSubview:scrollView];
    }
    return self;
}

+(HCPhotoEditBaseItemView*)showInView:(UIView*)view
{
    HCPhotoEditRotateItemView *effectView = [[HCPhotoEditRotateItemView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 150, view.bounds.size.width, 150)];
    effectView.transform = CGAffineTransformMakeTranslation(0, 150);
    [view addSubview:effectView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        effectView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    return effectView;
}


-(void)didClickButtonAtIndex:(NSInteger)index
{
    if (!_oriImage) {
        _oriImage = self.mainImageView.image;
    }
    if (index == 0) {
        _currentOrientation ++;
        if (_currentOrientation > 3) {
            _currentOrientation = 0;
        }
        [UIView animateWithDuration:0.2 animations:^{
            [self.mainImageView rotateLeft];
        } completion:^(BOOL finished) {
            self.mainImageView.imageView.transform = CGAffineTransformIdentity;
            self.mainImageView.image = [self.mainImageView.image newImageWithRotation:UIImageOrientationLeft];
        }];
    }else if (index == 1){
        _currentOrientation --;
        if (_currentOrientation < 0) {
            _currentOrientation = 3;
        }
        [UIView animateWithDuration:0.2 animations:^{
            [self.mainImageView rotateRight];
        } completion:^(BOOL finished) {
            self.mainImageView.imageView.transform = CGAffineTransformIdentity;
            self.mainImageView.image = [self.mainImageView.image newImageWithRotation:UIImageOrientationRight];
        }];
    }else if (index == 2){
        _flipY = !_flipY;
        [UIView animateWithDuration:0.2 animations:^{
            [self.mainImageView flipY];
        } completion:^(BOOL finished) {
            
            self.mainImageView.imageView.transform = CGAffineTransformIdentity;
            self.mainImageView.image = [self.mainImageView.image newImageWithFlipY];
            
        }];
    }else if (index == 3){
        _flipX = !_flipX;
        [UIView animateWithDuration:0.2 animations:^{
            [self.mainImageView flipX];
        } completion:^(BOOL finished) {
            self.mainImageView.imageView.transform = CGAffineTransformIdentity;
            self.mainImageView.image = [self.mainImageView.image newImageWithFlipX];
        }];
    }
}

-(void)okEdit
{
    [super okEdit];
}


-(void)cancelEdit
{
    [super cancelEdit];
    if (_oriImage) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mainImageView.image = _oriImage;
        }];
    }
}

@end
