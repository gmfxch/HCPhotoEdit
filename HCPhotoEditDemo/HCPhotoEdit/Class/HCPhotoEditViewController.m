//
//  CHPhotoEditViewController.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//  


#import "HCPhotoEditViewController.h"
#import "HCPhotoEditCustomButton.h"
#import "HCPhotoEditColorFilterItemView.h"
#import "HCPhotoEditFuzzyItemView.h"
#import "HCPhotoEditBaseImageView.h"
#import "HCPhotoEditCutItemView.h"
#import "HCPhotoEditRotateItemView.h"
#import "HCPhotoEditLightItemView.h"
#import "HCPhotoEditFrameItemView.h"
#import "HCPhotoEditAdjustItemView.h"
#import "HCPhotoEditSpecialEffectsItemView.h"
#import "GPUImage.h"




//******************************************
//******************************************
@interface HCPhotoEditViewController ()

@end

@implementation HCPhotoEditViewController
{
    UIView        *topView;
    UIScrollView  *bottomScrollView;
    HCPhotoEditBaseImageView   *mainImageView;
    NSMutableArray  *colorFilterIcons;
    NSMutableArray  *effectFilterIcons;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_RGB(40, 40, 40);
    [self topView];
    [self mainImageView];
    [self bottomScrollView];
    [self loadIconImages];
}

-(void)loadIconImages
{
    
    NSArray *filters = @[@"FWHudsonFilter",@"FWBrannanFilter",@"FWEarlybirdFilter",@"FWHefeFilter",@"FWSutroFilter",@"FWLomofiFilter",@"FWLordKelvinFilter",@"FWNashvilleFilter",@"FWRiseFilter",@"FWSierraFilter",@"FWAmaroFilter",@"FWToasterFilter",@"FWValenciaFilter",@"FWWaldenFilter",@"FWXproIIFilter",@"FW1977Filter",@"FWInkwellFilter"];
    NSArray *filters2 = @[@"GPUImageKuwaharaFilter",@"GPUImageSketchFilter",@"GPUImageSmoothToonFilter",@"GPUImageGlassSphereFilter",@"GPUImageEmbossFilter",@"GPUImageSwirlFilter"];
    effectFilterIcons = [NSMutableArray array];
    colorFilterIcons = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIGraphicsBeginImageContext(CGSizeMake(142, 142));
        [self.oriImage drawInRect:[self configRect:CGSizeMake(142, 142)]];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        for (int index = 0; index < filters.count; index++)
        {
            GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
            GPUImageFilter *outFilter = [[[NSClassFromString(filters[index]) class] alloc] init];
            [pic addTarget:outFilter];
            [outFilter useNextFrameForImageCapture];
            [pic processImage];
            UIImage *image2 = [outFilter imageFromCurrentFramebuffer];
            [colorFilterIcons addObject:image2];
        }
        
        for (int index = 0; index < filters2.count; index++)
        {
            GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
            GPUImageFilter *outFilter = [[[NSClassFromString(filters2[index]) class] alloc] init];
            [pic addTarget:outFilter];
            if ([outFilter isKindOfClass:[GPUImageKuwaharaFilter class]]) {
                //水彩画滤镜
                GPUImageKuwaharaFilter *f = (GPUImageKuwaharaFilter*)outFilter;
                f.radius = 8;
            }
            [outFilter useNextFrameForImageCapture];
            [pic processImage];
            UIImage *image2 = [outFilter imageFromCurrentFramebuffer];
            [effectFilterIcons addObject:image2];
        }
        
    });
}


-(UIView*)topView
{
    if (!topView)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
        view.backgroundColor = COLOR_RGB(25, 25, 25);
        [self.view addSubview:view];
        topView = view;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        cancelBtn.frame = CGRectMake(0, 0, view.bounds.size.height + 20, view.bounds.size.height);
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancelBtn];
        
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        finishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        finishBtn.frame = CGRectMake(self.view.bounds.size.width - view.bounds.size.height - 20, 0, view.bounds.size.height + 20, view.bounds.size.height);
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:finishBtn];
        
        
        UILabel  *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, view.bounds.size.height)];
        title.center = view.center;
        title.font = [UIFont boldSystemFontOfSize:17];
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"编辑";
        [view addSubview:title];
    }
    
    return topView;
}

-(UIView*)bottomScrollView
{
    if (!bottomScrollView)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100)];
        scrollView.backgroundColor = COLOR_RGB(35, 35, 35);
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:scrollView];
        bottomScrollView = scrollView;
        
        NSArray *titles = @[@"滤镜",@"特效",@"虚化",@"裁剪",@"旋转",@"光影",@"边框",@"调整",];
        NSArray *images = @[@"TPhotoAdjustCategory_Saturation",@"photo_effect_effect",@"photo_tiltshift_tiltshift",
                            @"photo_crop_crop",@"photo_rotate_rotate",
                            @"photo_light_light",@"photo_frame_frame",
                            @"photo_adjust_adjust",];
        for (int index = 0; index < titles.count; index++)
        {
            float width = 85;

            NSString *name = images[index];
            NSString *name2 = [name stringByAppendingString:@"_h"];
            HCPhotoEditCustomButton *btn = [[HCPhotoEditCustomButton alloc] initWithImage:IMAGE_WITHNAME(name) highlightedImage:IMAGE_WITHNAME(name2) title:titles[index] font:13 imageSize:0];
            btn.tag = index;
            [btn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(index * width, 0, width - 1, scrollView.bounds.size.height);
            [scrollView addSubview:btn];
            scrollView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), 0);
        }
    }
    
    return bottomScrollView;
}

-(HCPhotoEditBaseImageView*)mainImageView
{
    if (!mainImageView)
    {
        HCPhotoEditBaseImageView *imageView = [[HCPhotoEditBaseImageView alloc] initWithFrame:CGRectMake(10, [self topView].bounds.size.height + 10, self.view.bounds.size.width - 20, self.view.bounds.size.height - [self bottomScrollView].bounds.size.height - [self topView].bounds.size.height - 20)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = self.oriImage;
        [self.view addSubview:imageView];
        mainImageView = imageView;
    }
    return mainImageView;
}

#pragma mark editButton action
-(void)editButtonClick:(UIButton*)btn
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self hideTopView];
        
        switch (btn.tag)
        {
                
            case 0:
            {
                [self chooseColorFilter];
            }
                break;
            case 1:
            {
                [self chooseEffect];
            }
                break;
            case 2:
            {
                [self chooseFuzzy];
            }
                break;
            case 3:
            {
                [self chooseCut];
            }
                break;
            case 4:
            {
                [self chooseRotate];
            }
                break;
            case 5:
            {
                [self chooseLight];
            }
                break;
            case 6:
            {
                [self chooseBorder];
            }
                break;
            case 7:
            {
                [self chooseAdjust];
            }
                break;
            default:
                break;
        }

    });
}


#pragma mark ITEM
//滤镜
-(void)chooseColorFilter
{
    if (colorFilterIcons.count == 0) {
        return;
    }
    HCPhotoEditBaseItemView *view = [HCPhotoEditColorFilterItemView showInView:self.view icons:colorFilterIcons];
    view.mainImageView = mainImageView;
    view.oriImage = mainImageView.image;
    [view setOkBlock:^{
        [self restoreMainView];
    }];
    [view setCancelBlock:^{
        [self restoreMainView];
    }];
    [view setSelectItemBlock:^(NSInteger index) {
        
    }];
}

//特效
-(void)chooseEffect
{
    if (effectFilterIcons.count == 0) {
        return;
    }
    HCPhotoEditBaseItemView *view = [HCPhotoEditSpecialEffectsItemView showInView:self.view icons:effectFilterIcons];
    view.mainImageView = mainImageView;
    view.oriImage = mainImageView.image;
    [view setOkBlock:^{
        [self restoreMainView];
    }];
    [view setCancelBlock:^{
        [self restoreMainView];
    }];
    [view setSelectItemBlock:^(NSInteger index) {
        
    }];
}

//虚化
-(void)chooseFuzzy
{
    HCPhotoEditBaseItemView *view = [HCPhotoEditFuzzyItemView showInView:self.view];
    view.mainImageView = mainImageView;
    view.oriImage = mainImageView.image;
    [view setOkBlock:^{
        [self restoreMainView];
    }];
    [view setCancelBlock:^{
        [self restoreMainView];
    }];
}

//裁剪
-(void)chooseCut
{
    HCPhotoEditBaseItemView *view = [HCPhotoEditCutItemView showInView:self.view];
    view.mainImageView = mainImageView;
    [view setOkBlock:^{
        [self restoreMainView];
    }];
    [view setCancelBlock:^{
        [self restoreMainView];
    }];
    [view setSelectItemBlock:^(NSInteger index) {
        
    }];
}

//旋转
-(void)chooseRotate
{
    HCPhotoEditBaseItemView *view = [HCPhotoEditRotateItemView showInView:self.view];
    view.mainImageView = mainImageView;
    [view setOkBlock:^{
        [self restoreMainView];
    }];
    [view setCancelBlock:^{
        [self restoreMainView];
    }];
    [view setSelectItemBlock:^(NSInteger index) {
        
    }];
}

//光影
-(void)chooseLight
{
    HCPhotoEditBaseItemView *view = [HCPhotoEditLightItemView showInView:self.view];
    view.mainImageView = mainImageView;
    [view setOkBlock:^{
        [self restoreMainView];
    }];
    [view setCancelBlock:^{
        [self restoreMainView];
    }];
    [view setSelectItemBlock:^(NSInteger index) {
        
    }];
}

//边框
-(void)chooseBorder
{
    HCPhotoEditBaseItemView *view = [HCPhotoEditFrameItemView showInView:self.view];
    view.mainImageView = mainImageView;
    [view setOkBlock:^{
        [self restoreMainView];
    }];
    [view setCancelBlock:^{
        [self restoreMainView];
    }];
    [view setSelectItemBlock:^(NSInteger index) {
        
    }];
}

//调整
-(void)chooseAdjust
{
    HCPhotoEditBaseItemView *view = [HCPhotoEditAdjustItemView showInView:self.view];
    view.mainImageView = mainImageView;
    [view setOkBlock:^{
        [self restoreMainView];
        
    }];
    [view setCancelBlock:^{
        [self restoreMainView];
    }];
    [view setSelectItemBlock:^(NSInteger index) {
        
    }];
}

//恢复到主视图模式
-(void)restoreMainView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        topView.transform = CGAffineTransformIdentity;
        mainImageView.frame = CGRectMake(10, topView.bounds.size.height + 10, self.view.bounds.size.width-20, self.view.bounds.size.height - bottomScrollView.bounds.size.height - topView.bounds.size.height - 20);
            bottomScrollView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideTopView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        topView.transform = CGAffineTransformMakeTranslation(0, -topView.bounds.size.height);
        mainImageView.frame = CGRectMake(10, 25, self.view.bounds.size.width - 20, self.view.bounds.size.height - 185);
        bottomScrollView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark button action
-(void)back
{
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonWithEditController:)]) {
        [self.delegate didClickCancelButtonWithEditController:self];
    }
}

-(void)finish
{
    if ([self.delegate respondsToSelector:@selector(didClickFinishButtonWithEditController:newImage:)]) {
        [self.delegate didClickFinishButtonWithEditController:self newImage:mainImageView.image];
    }
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

+(UIImage*)resourceImageWithName:(NSString*)name
{
    NSString *path;
    if ([[name pathExtension] isEqualToString:@"jpg"]) {
        NSString *aBundleSourcePath = [[NSBundle mainBundle] pathForResource:@"CHPhotoEditResource" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:aBundleSourcePath];
        path = [bundle pathForResource:name ofType:@"" inDirectory:@"icon"];
    }else{
        NSString *aBundleSourcePath = [[NSBundle mainBundle] pathForResource:@"CHPhotoEditResource" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:aBundleSourcePath];
        path = [bundle pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"png" inDirectory:@"icon"];
    }
    
    return [UIImage imageWithContentsOfFile:path];
    
}

+(UIImage*)textureImageWithName:(NSString*)name
{
    NSString *path;
    if ([[name pathExtension] isEqualToString:@"jpg"]) {
        NSString *aBundleSourcePath = [[NSBundle mainBundle] pathForResource:@"CHPhotoEditResource" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:aBundleSourcePath];
        
        path = [bundle pathForResource:name ofType:@"" inDirectory:@"texture/halo_54"];
    }else{
        NSString *aBundleSourcePath = [[NSBundle mainBundle] pathForResource:@"CHPhotoEditResource" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:aBundleSourcePath];
        path = [bundle pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"png" inDirectory:@"icon"];
    }
    
    return [UIImage imageWithContentsOfFile:path];

}

-(CGRect)configRect:(CGSize)size
{
    float scale = self.oriImage.size.width / size.width;
    float H = self.oriImage.size.height / scale;
    if (H >= size.height) {
        float W = size.width;
        float X = 0;
        float Y = size.height/2.0 - H/2.0;
        return CGRectMake(X, Y, W, H);
    }
    scale = self.oriImage.size.height / size.height;
    float W = self.oriImage.size.width / scale;
    H = size.height;
    float X = size.width/2.0 - W/2.0;
    float Y = 0;
    return CGRectMake(X, Y, W, H);
}

-(void)setOriImage:(UIImage *)oriImage
{
    if (oriImage.size.width == 0 || oriImage.size.height == 0) {
        return;
    }
    float max = 1920.0 * 1080.0; //设置支持最大像素
    float scale = sqrtf(max/(oriImage.size.width*oriImage.size.height));
    if (scale < 1.0)
    {
        //缩小
        UIGraphicsBeginImageContext(CGSizeMake(oriImage.size.width*scale, oriImage.size.height*scale));
        [oriImage drawInRect:CGRectMake(0, 0, oriImage.size.width*scale, oriImage.size.height*scale)];
        oriImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    _oriImage = oriImage;
}

@end
