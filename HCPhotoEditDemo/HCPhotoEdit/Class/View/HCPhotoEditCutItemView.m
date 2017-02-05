//
//  HCPhotoEditCutItemView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/7.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditCutItemView.h"
#import "HCPhotoEditViewController.h"
#import "HCPhotoEditCustomButton.h"
#import "HCPhotoEditCustomSlider.h"
#import "HCPhotoEditCustomCutFrameView.h"
#import "HCPhotoEditCustomButton.h"

@interface HCPhotoEditCutItemView()

@property(nonatomic, weak) HCPhotoEditCustomCutFrameView *cutView;

@end

@implementation HCPhotoEditCutItemView
{
    HCPhotoEditBaseScrollView *editView;
    UIView                    *sliderConfigView;  //二级slider菜单
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *images = @[@"photo_crop_freedom",@"photo_crop_11",@"photo_crop_23",@"photo_crop_34",@"photo_crop_916",@"photo_crop_verticalgold"];
        NSArray *titles = @[@"自由",@"1:1",@"2:3",@"3:4",@"9:16",@"黄金比例"];
        HCPhotoEditBaseScrollView *scrollView = [[HCPhotoEditBaseScrollView alloc] initWithFrame:self.bounds bottomTitle:@"裁剪" imagesNameArray:images titlesArray:titles buttonWidth:self.bounds.size.width/3.0 imageSize:35];
        scrollView.delegate = self;
//        scrollView.ignoreButtonSelect = YES;
        [self addSubview:scrollView];
        editView = scrollView;
        
    }
    return self;
}

+(HCPhotoEditBaseItemView*)showInView:(UIView*)view
{
    HCPhotoEditCutItemView *effectView = [[HCPhotoEditCutItemView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 140, view.bounds.size.width, 140)];
    effectView.transform = CGAffineTransformMakeTranslation(0, effectView.bounds.size.height);
    [view addSubview:effectView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        effectView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    return effectView;
}

-(void)didClickButtonAtIndex:(NSInteger)index  button:(HCPhotoEditCustomButton *)btn
{
    
    [super didClickButtonAtIndex:index];
    [self.cutView removeFromSuperview];
    
    float buttonSize = 40;
    CGSize size = self.mainImageView.realImageSize;
    CGRect frame = CGRectMake(self.mainImageView.bounds.size.width/2.0 - size.width/2.0 - buttonSize/2.0 + self.mainImageView.frame.origin.x, self.mainImageView.bounds.size.height/2.0 - size.height/2.0 - buttonSize/2.0 + self.mainImageView.frame.origin.y, size.width + buttonSize, size.height + buttonSize);
    HCPhotoEditCustomCutFrameView *view = [[HCPhotoEditCustomCutFrameView alloc] initWithFrame:frame];
    [self.mainImageView.superview addSubview:view];
    view.mainImageView = self.mainImageView;
    self.cutView = view;

    if (index == 0)
    {
        view.proportion = 0;
    }
    else if (index == 1)
    {
        view.proportion = 1.0/1.0;
    }
    else if (index == 2)
    {
        if (btn.normalState) {
            view.proportion = 2.0/3.0;
            [btn setImage:IMAGE_WITHNAME(@"photo_crop_23_h") forState:UIControlStateSelected];
            [btn setTitle:@"2:3" forState:UIControlStateSelected];
            
        }else{
            view.proportion = 3.0/2.0;
            [btn setImage:IMAGE_WITHNAME(@"photo_crop_32_h") forState:UIControlStateSelected];
            [btn setTitle:@"3:2" forState:UIControlStateSelected];
        }
    }
    else if (index == 3)
    {
        if (btn.normalState) {
            view.proportion = 3.0/4.0;
            [btn setImage:IMAGE_WITHNAME(@"photo_crop_34_h") forState:UIControlStateSelected];
            [btn setTitle:@"3:4" forState:UIControlStateSelected];
        }else{
            view.proportion = 4.0/3.0;
            [btn setImage:IMAGE_WITHNAME(@"photo_crop_43_h") forState:UIControlStateSelected];
            [btn setTitle:@"4:3" forState:UIControlStateSelected];
        }
    }
    else if (index == 4)
    {
        if (btn.normalState) {
            view.proportion = 9.0/16.0;
            [btn setImage:IMAGE_WITHNAME(@"photo_crop_916_h") forState:UIControlStateSelected];
            [btn setTitle:@"9:16" forState:UIControlStateSelected];
        }else{
            view.proportion = 16.0/9.0;
            [btn setImage:IMAGE_WITHNAME(@"photo_crop_169_h") forState:UIControlStateSelected];
            [btn setTitle:@"16:9" forState:UIControlStateSelected];
        }
    }
    else if (index == 5)
    {
        //photo_crop_horizontalgold_h@2x
        if (btn.normalState) {
            view.proportion = 0.618/1.0;
            [btn setImage:IMAGE_WITHNAME(@"photo_crop_verticalgold_h") forState:UIControlStateSelected];
//            [btn setTitle:@"" forState:UIControlStateSelected];
        }else{
            view.proportion = 1.0/0.618;
            [btn setImage:IMAGE_WITHNAME(@"photo_crop_horizontalgold_h") forState:UIControlStateSelected];
//            [btn setTitle:@"" forState:UIControlStateSelected];
        }
    }
    btn.normalState = !btn.normalState;
    
}

-(void)okEdit
{
    
    float oriX = self.cutView.frame.origin.x - self.mainImageView.frame.origin.x - (self.mainImageView.bounds.size.width/2.0 - self.mainImageView.realImageSize.width/2.0) + 40/2.0;
    float oriY = self.cutView.frame.origin.y - self.mainImageView.frame.origin.y - (self.mainImageView.bounds.size.height/2.0 - self.mainImageView.realImageSize.height/2.0) + 40/2.0;
    
    float realX = oriX / self.mainImageView.imageScale;
    float realY = oriY / self.mainImageView.imageScale;
    float width = (self.cutView.frame.size.width - 40) / self.mainImageView.imageScale;
    float height = (self.cutView.frame.size.height - 40) / self.mainImageView.imageScale;
    CGRect newFrame = CGRectMake(realX, realY, width, height);
    CGImageRef cgimage = CGImageCreateWithImageInRect(self.mainImageView.image.CGImage, newFrame);
    UIImage  *newImage = [UIImage imageWithCGImage:cgimage];
    self.mainImageView.image = newImage;
    
    [self.cutView removeFromSuperview];
    [super okEdit];
}

-(void)cancelEdit
{
    [super cancelEdit];
    [self.cutView removeFromSuperview];
}

@end
