//
//  HCPhotoEditFuzzyItemView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditFuzzyItemView.h"
#import "HCPhotoEditViewController.h"
#import "HCPhotoEditCustomButton.h"
#import "HCPhotoEditCustomSlider.h"
#import "GPUImageGaussianBlurFilter.h"
#import "GPUImage.h"
#import "GPUImageGaussianSelectiveBlurFilter.h"
#import "GPUImageTiltShiftFilter.h"
#import "HCCustomGPUImageTiltShiftFilter.h"
#import "HCPhotoEditFuzzyMaskView.h"


@interface HCPhotoEditFuzzyItemView()

@property(nonatomic, assign) NSInteger  blurIndex; //当前选中的模糊程度档位
@property(nonatomic, assign) CGPoint                   currentExcludeCirclePoint;  //圆形位置
@property(nonatomic, assign) float currentExcludeCircleRadius; //半径
@property(nonatomic, assign) float startExcludeCircleRadius; //半径

@property(nonatomic, assign) float currentRotation; //
@property(nonatomic, assign) float startRotation; //


@end

@implementation HCPhotoEditFuzzyItemView
{
    HCPhotoEditBaseScrollView *editView;
    UIView                    *sliderConfigView;  //二级slider菜单
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *images = @[@"photo_tiltshift_close",@"photo_tiltshift_circle"];
        HCPhotoEditBaseScrollView *scrollView = [[HCPhotoEditBaseScrollView alloc] initWithFrame:self.bounds bottomTitle:@"虚化" imagesNameArray:images titlesArray:nil buttonWidth:self.bounds.size.width/2.0 imageSize:30];
        scrollView.delegate = self;
        scrollView.ignoreButtonSelect = YES;
        [self addSubview:scrollView];
        editView = scrollView;

    }
    return self;
}

+(HCPhotoEditBaseItemView*)showInView:(UIView*)view
{
    HCPhotoEditFuzzyItemView *effectView = [[HCPhotoEditFuzzyItemView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 150, view.bounds.size.width, 150)];
    effectView.transform = CGAffineTransformMakeTranslation(0, 150);
    [view addSubview:effectView];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        effectView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];

    return effectView;
}

-(void)didClickButtonAtIndex:(NSInteger)index
{
    [super didClickButtonAtIndex:index];
    self.currentExcludeCirclePoint = CGPointMake(0.5, 0.5);
    if (index == 0)
    {
        sliderConfigView = [self sliderConfigView:0];
    }
    else if (index == 1)
    {
        self.currentExcludeCircleRadius = 0.3;
        self.startExcludeCircleRadius = 0.3;
        sliderConfigView = [self sliderConfigView:1];
    }
    else
    {
        self.currentRotation = 0.0;
        self.startRotation = 0.0;
        self.currentExcludeCircleRadius = 0.2;
        self.startExcludeCircleRadius = 0.2;
        sliderConfigView = [self sliderConfigView:2];
    }
}

-(UIView*)sliderConfigView:(NSInteger)type
{
    
    __weak __typeof(&*self)weakSelf = self;
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = COLOR_RGB(40, 40, 40);
    [self addSubview:view];
    
    HCPhotoEditCustomSlider  *slider = [[HCPhotoEditCustomSlider alloc] initWithFrame:CGRectMake(30, 40, self.bounds.size.width - 60, 40)];
    [view addSubview:slider];
    [slider setItemTitles:@[@"F1.0",@"F1.2",@"F1.4",@"F2.0",@"F2.8",@"F3.2"]];
    [slider setValueChangedBlock:^(NSInteger index) {
        
        weakSelf.blurIndex = index;
        if (type == 0)
        {
            //整体模糊
            GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
            filter.blurRadiusInPixels = 6 * (index + 1);
            GPUImagePicture *picSource = [[GPUImagePicture alloc] initWithImage:weakSelf.oriImage];
            [picSource addTarget:filter];
            [filter useNextFrameForImageCapture];
            [picSource processImage];
            UIImage *newImage = [filter imageFromCurrentFramebuffer];
            weakSelf.mainImageView.image = newImage;
        }
        else if (type == 1)
        {
            //局部模糊（圆形）
            self.mainImageView.showCircleMask = YES;
            [weakSelf updateCircleBlurImage];
        }
        else
        {
            //局部模糊（径向）
//            self.mainImageView.showCircleMask = NO;
//            [weakSelf updateLineBlurImage];
        }
        
    }];
    [slider setDefaultItemIndex:0];
    slider.valueChangedBlock(0);
    
    //滑动手势，改变模糊位置
    [self.mainImageView setPanGestureMovedBlock:^(CGPoint pt) {
        
        if (type == 1) {
            float size = MIN(weakSelf.mainImageView.realImageSize.width, weakSelf.mainImageView.realImageSize.height);
            _currentExcludeCirclePoint.x += pt.x / size;
            _currentExcludeCirclePoint.y += pt.y / size;

        }else if (type == 2){
            float size = MIN(weakSelf.mainImageView.realImageSize.width, weakSelf.mainImageView.realImageSize.height);
            _currentExcludeCirclePoint.x += pt.x / size;
            _currentExcludeCirclePoint.y += pt.y / size;
        }
        
    }];
    //滑动结束
    [self.mainImageView setPanGestureEndedBlock:^(CGPoint pt) {
        
        if (type == 1) {
            float size = MIN(weakSelf.mainImageView.realImageSize.width, weakSelf.mainImageView.realImageSize.height);
            _currentExcludeCirclePoint.x += pt.x / size;
            _currentExcludeCirclePoint.y += pt.y / size;
            [weakSelf updateCircleBlurImage];
        }else if (type == 2){
            float size = MIN(weakSelf.mainImageView.realImageSize.width, weakSelf.mainImageView.realImageSize.height);
            _currentExcludeCirclePoint.x += pt.x / size;
            _currentExcludeCirclePoint.y += pt.y / size;
            [weakSelf updateLineBlurImage];
        }
        
    }];
    //捏合手势
    [self.mainImageView setPinchGestureBlock:^(float scale) {
        
        weakSelf.currentExcludeCircleRadius = weakSelf.startExcludeCircleRadius * scale;
        weakSelf.currentExcludeCircleRadius = MIN(weakSelf.currentExcludeCircleRadius, 0.99);

    }];
    //捏合手势结束
    [self.mainImageView setPinchEndedGestureBlock:^(float scale) {
        
        weakSelf.currentExcludeCircleRadius = weakSelf.startExcludeCircleRadius * scale;
        weakSelf.currentExcludeCircleRadius = MIN(weakSelf.currentExcludeCircleRadius, 0.99);
        if (type == 1) {
            [weakSelf updateCircleBlurImage];
        }else if (type == 2){
            [weakSelf updateLineBlurImage];
        }
        
        weakSelf.startExcludeCircleRadius = weakSelf.currentExcludeCircleRadius;
    }];
    
//    //旋转手势
//    if (type == 2)
//    {
//        [self.mainImageView setRotateGestureBlock:^(float angle) {
//            weakSelf.currentRotation = weakSelf.startRotation + angle;
//        }];
//        [self.mainImageView setRotateEndGestureBlock:^(float angle) {
//            weakSelf.currentRotation = weakSelf.startRotation + angle;
//            weakSelf.startRotation = weakSelf.currentRotation;
//            [weakSelf updateLineBlurImage];
//        }];
//
//    }
//    else
//    {
//        [self.mainImageView setRotateGestureBlock:nil];
//        [self.mainImageView setRotateEndGestureBlock:nil];
//    }

    
    //bottomView
    UIView *bottomView = [[UIView alloc] initWithFrame:editView.bottomView.frame];
    bottomView.backgroundColor = COLOR_RGB(40, 40, 40);
    [view addSubview:bottomView];
    
    HCPhotoEditCustomButton *btn1 = [[HCPhotoEditCustomButton alloc] initWithImage:IMAGE_WITHNAME(@"photo_bottom_bar_cancel")  highlightedImage:IMAGE_WITHNAME(@"photo_bottom_bar_cancel_light") title:nil font:0 imageSize:0];
    btn1.frame = CGRectMake(0, 0, bottomView.bounds.size.width/2.0 - 1, bottomView.bounds.size.height);
    [bottomView addSubview:btn1];
    
    HCPhotoEditCustomButton *btn2 = [[HCPhotoEditCustomButton alloc] initWithImage:IMAGE_WITHNAME(@"photo_bottom_bar_ok")  highlightedImage:IMAGE_WITHNAME(@"photo_bottom_bar_ok_light") title:nil font:0 imageSize:0];
    btn2.frame = CGRectMake(bottomView.bounds.size.width/2.0, 0, bottomView.bounds.size.width/2.0, bottomView.bounds.size.height);
    [bottomView addSubview:btn2];
    [btn1 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    view.transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.transform = CGAffineTransformIdentity;
        editView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
    return view;
}


-(void)cancel
{
    [self hideSliderView];
    self.mainImageView.image = self.oriImage;
    [self.mainImageView setPanGestureMovedBlock:nil];
    [self.mainImageView clearMaskView];
}

-(void)ok
{
    [self hideSliderView];
    [self.mainImageView setPanGestureMovedBlock:nil];
    [self.mainImageView clearMaskView];
}

-(void)hideSliderView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        sliderConfigView.alpha = 0.4;
        sliderConfigView.transform = CGAffineTransformMakeTranslation(0, sliderConfigView.bounds.size.height);
        editView.alpha = 1;
    } completion:^(BOOL finished) {
        [sliderConfigView removeFromSuperview];
    }];
}

-(void)okEdit
{
    [super okEdit];
}
-(void)cancelEdit
{
    [super cancelEdit];
    self.mainImageView.image = self.oriImage;
}

-(void)updateCircleBlurImage
{
    GPUImagePicture *picSource = [[GPUImagePicture alloc] initWithImage:self.oriImage];
    GPUImageGaussianSelectiveBlurFilter *filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
    [picSource addTarget:filter];
    [filter forceProcessingAtSize:self.oriImage.size];
    filter.blurRadiusInPixels = 6 * (_blurIndex + 1); //模糊程度
    filter.aspectRatio = self.oriImage.size.height/self.oriImage.size.width;    //圆形比例
    filter.excludeCirclePoint = _currentExcludeCirclePoint;//圆形清晰部分的位置
    filter.excludeCircleRadius = _currentExcludeCircleRadius; //圆形清晰部分的半径（0-1）
    filter.excludeBlurSize = 0.25; //圆形部分硬度（0：边界最清晰）
    
    [filter useNextFrameForImageCapture];
    [picSource processImage];
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    self.mainImageView.image = newImage;
}

-(void)updateLineBlurImage
{
    
    GPUImagePicture *picSource = [[GPUImagePicture alloc] initWithImage:self.oriImage];
    HCCustomGPUImageTiltShiftFilter *filter = [[HCCustomGPUImageTiltShiftFilter alloc] init];
    [picSource addTarget:filter];
    filter.blurRadiusInPixels = 6 * (_blurIndex + 1);
    filter.excludeCirclePoint = _currentExcludeCirclePoint;//
//    filter.excludeCirclePoint = CGPointMake(0.1, 0.1);
    filter.excludeCircleRadius = _currentExcludeCircleRadius; //
    filter.excludeBlurSize = 0.0;
//    filter.aspectRatio = 1.0;
    filter.aspectRatio = [UIScreen mainScreen].scale; //
    filter.rotation = self.currentRotation;
//    filter.rotation = M_PI_2;
    [filter useNextFrameForImageCapture];
    [picSource processImage];
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    self.mainImageView.image = newImage;
    
}


@end
