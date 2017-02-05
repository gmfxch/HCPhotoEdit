//
//  HCPhotoEditEffectView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditColorFilterItemView.h"
#import "FWXproIIFilter.h"
#import "GPUImagePicture.h"
#import "FWAmaroFilter.h"
#import "HCTestFilter.h"


@interface HCPhotoEditColorFilterItemView()

@end

@implementation HCPhotoEditColorFilterItemView
{
    GPUImagePicture          *pic;
}

-(instancetype)initWithFrame:(CGRect)frame icons:(NSArray*)icons
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        NSArray *images = @[@"eft_skin_soft.jpg",@"eft_skin_sunshine.jpg",@"eft_lightcolor_colorblue.jpg",@"eft_lightcolor_sweetred.jpg",@"eft_filmflex_005.jpg",@"eft_enhance_auto.jpg",@"eft_hdr_original.jpg",@"eft_loft_006.jpg",@"eft_lomo_cyan.jpg",@"eft_lomo_film.jpg",@"eft_lomo_leaf.jpg",@"eft_retro_02.jpg",@"eft_retro_08.jpg",@"eft_timer_18391.jpg",@"eft_bw_01.jpg",@"eft_sky_01.jpg",@"eft_sky_11.jpg"];
        NSArray *titles = @[@"F1",@"F2",@"F3",@"F4",@"F5",@"F6",@"F7",@"F8",@"F9",@"F10",@"F11",@"F12",@"F13",@"F14",@"F15",@"F16",@"F17"];
        HCPhotoEditBaseScrollView *scrollView = [[HCPhotoEditBaseScrollView alloc] initWithFrame:self.bounds bottomTitle:@"滤镜" imagesArray:icons titlesArray:titles buttonWidth:100 imageSize:60];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *images = @[@"eft_skin_soft.jpg",@"eft_skin_sunshine.jpg",@"eft_lightcolor_colorblue.jpg",@"eft_lightcolor_sweetred.jpg",@"eft_filmflex_005.jpg",@"eft_enhance_auto.jpg",@"eft_hdr_original.jpg",@"eft_loft_006.jpg",@"eft_lomo_cyan.jpg",@"eft_lomo_film.jpg",@"eft_lomo_leaf.jpg",@"eft_retro_02.jpg",@"eft_retro_08.jpg",@"eft_timer_18391.jpg",@"eft_bw_01.jpg",@"eft_sky_01.jpg",@"eft_sky_11.jpg"];
        NSArray *titles = @[@"F1",@"F2",@"F3",@"F4",@"F5",@"F6",@"F7",@"F8",@"F9",@"F10",@"F11",@"F12",@"F13",@"F14",@"F15",@"F16",@"F17"];
        HCPhotoEditBaseScrollView *scrollView = [[HCPhotoEditBaseScrollView alloc] initWithFrame:self.bounds bottomTitle:@"滤镜" imagesNameArray:images titlesArray:titles buttonWidth:100 imageSize:60];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
    }
    return self;
}

+(HCPhotoEditBaseItemView*)showInView:(UIView*)view icons:(NSArray *)icons
{
    HCPhotoEditColorFilterItemView *effectView = [[HCPhotoEditColorFilterItemView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 150, view.bounds.size.width, 150) icons:icons];
    effectView.transform = CGAffineTransformMakeTranslation(0, 150);
    [view addSubview:effectView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        effectView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    return effectView;
}


+(HCPhotoEditBaseItemView*)showInView:(UIView*)view
{
    HCPhotoEditColorFilterItemView *effectView = [[HCPhotoEditColorFilterItemView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 150, view.bounds.size.width, 150)];
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
    if (!self.oriImage) {
        self.oriImage = self.mainImageView.image;
    }
    if (self.selectItemBlock) {
        self.selectItemBlock(index);
    }

    //滤镜种类
    NSArray *filters = @[@"FWHudsonFilter",@"FWBrannanFilter",@"FWEarlybirdFilter",@"FWHefeFilter",@"FWSutroFilter",@"FWLomofiFilter",@"FWLordKelvinFilter",@"FWNashvilleFilter",@"FWRiseFilter",@"FWSierraFilter",@"FWAmaroFilter",@"FWToasterFilter",@"FWValenciaFilter",@"FWWaldenFilter",@"FWXproIIFilter",@"FW1977Filter",@"FWInkwellFilter"];
    
    [self applyFilter:filters[index]];
    
}

-(void)applyFilter:(NSString*)filter
{
    pic = [[GPUImagePicture alloc] initWithImage:self.oriImage];
    GPUImageFilter *outFilter = [[[NSClassFromString(filter) class] alloc] init];
    [pic addTarget:outFilter];
    [outFilter useNextFrameForImageCapture];
    [pic processImage];
    UIImage *newImage = [outFilter imageFromCurrentFramebuffer];
    if (newImage) {
        self.mainImageView.image = newImage;
    }
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


@end
