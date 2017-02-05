//
//  HCPhotoEditFrameItemView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/7.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditFrameItemView.h"

@implementation HCPhotoEditFrameItemView
{
    UIImage *_oriImage;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *images = @[@"eft_blend_normal_border_1.jpg",@"eft_blend_normal_border_2.jpg",@"eft_blend_normal_border_3.jpg",@"eft_blend_normal_border_4.jpg",@"eft_blend_normal_border_5.jpg",@"eft_blend_normal_border_6.jpg",@"eft_blend_normal_border_7.jpg",@"eft_blend_normal_border_8.jpg",@"eft_blend_normal_border_9.jpg",@"eft_blend_normal_border_10.jpg"];
        
        HCPhotoEditBaseScrollView *scrollView = [[HCPhotoEditBaseScrollView alloc] initWithFrame:self.bounds bottomTitle:@"边框" imagesNameArray:images titlesArray:nil buttonWidth:100 imageSize:65];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
    }
    return self;
}

+(HCPhotoEditBaseItemView*)showInView:(UIView*)view
{
    HCPhotoEditFrameItemView *effectView = [[HCPhotoEditFrameItemView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 150, view.bounds.size.width, 150)];
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
    
    NSArray *images = @[@"blend_normal_border_1",@"blend_normal_border_2",@"blend_normal_border_3",@"blend_normal_border_4",@"blend_normal_border_5",@"blend_normal_border_6",@"blend_normal_border_7",@"blend_normal_border_8",@"blend_normal_border_9",@"blend_normal_border_10"];
    NSString *aBundleSourcePath = [[NSBundle mainBundle] pathForResource:@"CHPhotoEditResource" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:aBundleSourcePath];
    NSString *path = [bundle pathForResource:images[index] ofType:@"png" inDirectory:[NSString stringWithFormat:@"texture/%@",images[index]]];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    
    UIGraphicsBeginImageContext(_oriImage.size);
    [_oriImage drawInRect:CGRectMake(0, 0, _oriImage.size.width, _oriImage.size.height)];
    [image drawInRect:CGRectMake(0, 0, _oriImage.size.width, _oriImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.mainImageView.image = newImage;
    
//    
//    switch (index) {
//        case 0:
//            
//            break;
//        case 1:
//            
//            break;
//        case 2:
//            
//            break;
//        case 3:
//            
//            break;
//        case 4:
//            
//            break;
//            
//        default:
//            break;
//    }
}

-(void)okEdit
{
    [super okEdit];
}

-(void)cancelEdit
{
    [super cancelEdit];
    if (_oriImage) {
        self.mainImageView.image = _oriImage;
    }
}


@end
