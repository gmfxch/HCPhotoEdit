//
//  CHPhotoEditAdjustItemView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/7.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditAdjustItemView.h"
#import "HCPhotoEditCustomSlider.h"
#import "HCPhotoEditViewController.h"
#import "HCPhotoEditCustomButton.h"
#import "GPUImage.h"
#import "GPUImageSharpenFilter.h" //锐化（清晰度）
#import "GPUImageHueFilter.h" //色度

#import "GPUImageBrightnessFilter.h" //亮度
#import "GPUImageExposureFilter.h" //曝光
#import "GPUImageContrastFilter.h" //对比度
#import "GPUImageSaturationFilter.h" //饱和度
#import "GPUImageGammaFilter.h" //伽马线
#import "GPUImageColorInvertFilter.h" //反色
#import "GPUImageSepiaFilter.h" //褐色（怀旧）
#import "GPUImageLevelsFilter.h" //色阶
#import "GPUImageGrayscaleFilter.h" //灰度
#import "GPUImageHistogramFilter.h" //色彩直方图，显示在图片上
#import "GPUImageHistogramGenerator.h" //色彩直方图
#import "GPUImageRGBFilter.h" //RGB
#import "GPUImageToneCurveFilter.h" //色调曲线
#import "GPUImageMonochromeFilter.h" //单色
#import "GPUImageOpacityFilter.h" //不透明度
#import "GPUImageHighlightShadowFilter.h" //提亮阴影
#import "GPUImageFalseColorFilter.h" //色彩替换（替换亮部和暗部色彩）
#import "GPUImageHueFilter.h" //色度
#import "GPUImageChromaKeyFilter.h" //色度键
#import "GPUImageWhiteBalanceFilter.h" //白平横
#import "GPUImageAverageColor.h" //像素平均色值
#import "GPUImageSolidColorGenerator.h" //纯色
#import "GPUImageLuminosity.h" //亮度平均
#import "GPUImageAverageLuminanceThresholdFilter.h" //像素色值亮度平均，图像黑白（有类似漫画效果）
#import "GPUImageLookupFilter.h" //lookup 色彩调整
#import "GPUImageAmatorkaFilter.h" //Amatorka lookup
#import "GPUImageMissEtikateFilter.h" //MissEtikate lookup
#import "GPUImageSoftEleganceFilter.h" //SoftElegance lookup


#pragma mark - 图像处理 Handle Image

#import "GPUImageCrosshairGenerator.h" //十字
#import "GPUImageLineGenerator.h" //线条
#import "GPUImageTransformFilter.h" //形状变化
#import "GPUImageCropFilter.h" //剪裁
#import "GPUImageSharpenFilter.h" //锐化
#import "GPUImageUnsharpMaskFilter.h" //反遮罩锐化
#import "GPUImageiOSBlurFilter.h" //模糊
#import "GPUImageVignetteFilter.h"
#import "GPUImageVibranceFilter.h" //自然饱和度


@implementation HCPhotoEditAdjustItemView
{
    HCPhotoEditBaseScrollView *editView;
    UIView                    *configView;
    GPUImagePicture           *picSource;
    GPUImageSaturationFilter  *SaturationFilter;
    GPUImageContrastFilter    *ContrastFilter;
    GPUImageExposureFilter    *ExposureFilter;
    GPUImageBrightnessFilter  *BrightnessFilter;
    GPUImageSharpenFilter     *SharpenFilter;
    GPUImageVignetteFilter    *VignetteFilter;
    GPUImageWhiteBalanceFilter *BalanceFilter;
    GPUImageHighlightShadowFilter *ShadowFilter;
    GPUImageHighlightShadowFilter *ShadowFilter2;
    CGFloat                        lastSliderValue;
    UISlider                       *_slider;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *images = @[@"TPhotoAdjustCategory_Level",@"TPhotoAdjustCategory_sharpness",@"TPhotoAdjustCategory_Temperature",@"TPhotoAdjustCategory_Exposure",@"TPhotoAdjustCategory_Contrast",@"TPhotoAdjustCategory_Saturation",@"TPhotoAdjustCategory_Highlight",@"TPhotoAdjustCategory_Shadow",@"TPhotoAdjustCategory_vignetteStrong"];
        NSArray *titles = @[@"层次",@"清晰度",@"色温",@"曝光",@"对比度",@"饱和度",@"高光",@"阴影",@"暗角"];
        HCPhotoEditBaseScrollView *scrollView = [[HCPhotoEditBaseScrollView alloc] initWithFrame:self.bounds bottomTitle:@"调整" imagesNameArray:images titlesArray:titles buttonWidth:90 imageSize:30];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        editView = scrollView;
        
    }
    return self;
}

+(HCPhotoEditBaseItemView*)showInView:(UIView*)view
{
    HCPhotoEditAdjustItemView *effectView = [[HCPhotoEditAdjustItemView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 150, view.bounds.size.width, 150)];
    effectView.transform = CGAffineTransformMakeTranslation(0, 150);
    [view addSubview:effectView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        effectView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    return effectView;
}


-(void)didClickButtonAtIndex:(NSInteger)index button:(UIButton *)btn
{
    
    SaturationFilter = nil;
    ContrastFilter = nil;
    ExposureFilter = nil;
    BrightnessFilter = nil;
    SharpenFilter = nil;
    VignetteFilter = nil;
    BalanceFilter = nil;
    ShadowFilter = nil;
    ShadowFilter2 = nil;
    
    if (!self.oriImage) {
        self.oriImage = self.mainImageView.image;
    }
    picSource =  [[GPUImagePicture alloc] initWithImage:self.oriImage];
    configView = [self sliderConfigView:index];
    configView.tag = index;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.selected = NO;
    });
    if (index == 8) {
        [self sliderValueChanged:_slider];
    }
}

-(UIView*)sliderConfigView:(NSInteger)index
{
    
    lastSliderValue = 0;
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = COLOR_RGB(40, 40, 40);
    [self addSubview:view];
    HCPhotoEditCustomSlider  *slider = [[HCPhotoEditCustomSlider alloc] initWithFrame:CGRectMake(30, 40, self.bounds.size.width - 60, 40)];
    [view addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _slider = slider;

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
    
    switch (index) {
        case 0:
            //层次
            slider.maximumValue = 1;
            slider.minimumValue = 0;
            slider.value = 0;
            break;
        case 1:
            //清晰度
            slider.minimumValue = 0.0;
            slider.maximumValue = 1.5;
            slider.value = 0;
            break;
        case 2:
            //色温
            slider.minimumValue = 0;
            slider.maximumValue = 10000.0;
            slider.value = 5000.0;
            break;
        case 3:
            //曝光
            slider.maximumValue = 1;
            slider.minimumValue = -1;
            slider.value = 0;
            break;
        case 4:
            //对比度
            slider.maximumValue = 3;
            slider.minimumValue = 0.3;
            slider.value = 1.0;
            break;
        case 5:
            //饱和度
            slider.maximumValue = 2;
            slider.minimumValue = 0;
            slider.value = 1.0;
            break;
        case 6:
            //高光
            slider.maximumValue = 0.8;
            slider.minimumValue = -0.8;
            slider.value = 0.0;
            break;
        case 7:
            //阴影
            slider.maximumValue = 1;
            slider.minimumValue = 0;
            slider.value = 0.0;
            break;
        case 8:
            //暗角
            slider.maximumValue = 0.6;
            slider.minimumValue = 0.4;
            slider.value = 0.5;
            break;
            
        default:
            break;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.mainImageView.bounds];
    titleLabel.tag = 1010;
    titleLabel.numberOfLines = 0;
    titleLabel.transform = CGAffineTransformMakeTranslation(0, -30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:23];
    titleLabel.textColor = [UIColor whiteColor];
    [self.mainImageView addSubview:titleLabel];
    
    [slider setTouchEndedBlock:^{
        [UIView animateWithDuration:0.2 animations:^{
            titleLabel.alpha = 0;
        } completion:^(BOOL finished) {
            titleLabel.hidden = YES;
        }];
    }];

    return view;
}

-(void)cancel
{
    [self hideSliderView];
    if (self.oriImage) {
       self.mainImageView.image = self.oriImage;
    }
    [[self.mainImageView viewWithTag:1010] removeFromSuperview];
}

-(void)ok
{
    [self hideSliderView];
    [[self.mainImageView viewWithTag:1010] removeFromSuperview];
}

-(void)hideSliderView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        configView.alpha = 0.4;
        configView.transform = CGAffineTransformMakeTranslation(0, configView.bounds.size.height);
        editView.alpha = 1;
    } completion:^(BOOL finished) {
        [configView removeFromSuperview];
        configView = nil;
    }];
}


-(void)sliderValueChanged:(UISlider*)slider
{
    switch (configView.tag) {
        case 0:
            //层次
        {
            if (!ShadowFilter2) {
                ShadowFilter2 = [[GPUImageHighlightShadowFilter alloc] init];
                [picSource addTarget:ShadowFilter2];
            }
            
            ShadowFilter2.shadows += (slider.value - lastSliderValue);
            ShadowFilter2.highlights -= (slider.value - lastSliderValue);
            [self updateImage:ShadowFilter2];
            lastSliderValue = slider.value;
            
            [self updateTitle:@"层次调节" value:slider.value];
        }
            
            break;
        case 1:
            //清晰度
        {
            if (!SharpenFilter) {
                SharpenFilter = [[GPUImageSharpenFilter alloc] init];
                [picSource addTarget:SharpenFilter];
            }
            SharpenFilter.sharpness = slider.value;
            [self updateImage:SharpenFilter];
            
            [self updateTitle:@"清晰度" value:slider.value];
        }
            
            break;
        case 2:
            //色温
        {
            if (!BalanceFilter) {
               BalanceFilter = [[GPUImageWhiteBalanceFilter alloc] init];
                [picSource addTarget:BalanceFilter];
            }
            BalanceFilter.temperature = slider.value;
            [self updateImage:BalanceFilter];
            
            [self updateTitle:@"色温" value:slider.value];
        }
            
            break;
        case 3:
            //曝光度
        {
            if (!ExposureFilter) {
                ExposureFilter = [[GPUImageExposureFilter alloc] init];
                [picSource addTarget:ExposureFilter];
            }
            
            ExposureFilter.exposure = slider.value;
            [self updateImage:ExposureFilter];
            [self updateTitle:@"曝光度" value:slider.value];
        }
            break;
        case 4:
            //对比度
        {
            if (!ContrastFilter) {
                ContrastFilter = [[GPUImageContrastFilter alloc] init];
                [picSource addTarget:ContrastFilter];
            }
            ContrastFilter.contrast = slider.value;
            [self updateImage:ContrastFilter];
            [self updateTitle:@"对比度" value:slider.value];
        }
            break;
        case 5:
            //饱和度
        {
            if (!SaturationFilter) {
                GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init];
                [picSource addTarget:filter];
                SaturationFilter = filter;
            }
            SaturationFilter.saturation = slider.value;
            [self updateImage:SaturationFilter];
            [self updateTitle:@"饱和度" value:slider.value];
        }
            break;
        case 6:
            //高光
        {
            if (!BrightnessFilter) {
                BrightnessFilter = [[GPUImageBrightnessFilter alloc] init];
                [picSource addTarget:BrightnessFilter];
            }
            BrightnessFilter.brightness = slider.value;
            [self updateImage:BrightnessFilter];
            [self updateTitle:@"高光调节" value:slider.value];
        }
            
            break;
        case 7:
            //阴影
        {
            if (!ShadowFilter) {
                ShadowFilter = [[GPUImageHighlightShadowFilter alloc] init];
                [picSource addTarget:ShadowFilter];
            }
            ShadowFilter.shadows = slider.value;
            [self updateImage:ShadowFilter];
            [self updateTitle:@"阴影调节" value:slider.value];
        }
            break;
        case 8:
            //暗角
        {
            if (!VignetteFilter) {
                VignetteFilter = [[GPUImageVignetteFilter alloc] init];
                [picSource addTarget:VignetteFilter];
            }
            
            VignetteFilter.vignetteStart = slider.value;
            VignetteFilter.vignetteEnd = slider.value + 0.25;
            [self updateImage:VignetteFilter];
            [self updateTitle:@"暗角" value:slider.value];
        }
            break;
            
        default:
            break;
    }
}

-(void)updateImage:(GPUImageOutput*)filter
{
    [filter useNextFrameForImageCapture];
    [picSource processImage];
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    if (newImage) {
       self.mainImageView.image = newImage;
    }
}



-(void)updateTitle:(NSString*)title  value:(float)value
{
    UILabel *label = [self.mainImageView viewWithTag:1010];
    label.alpha = 1;
    label.hidden = NO;
    label.text = [NSString stringWithFormat:@"%@\n%.2f",title,value];
}

@end
