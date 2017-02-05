//
//  HCPhotoEditSpecialEffectsItemView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/21.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditSpecialEffectsItemView.h"
#import "FWXproIIFilter.h"
#import "GPUImagePicture.h"
#import "FWAmaroFilter.h"
#import "HCTestFilter.h"

@implementation HCPhotoEditSpecialEffectsItemView
{
    GPUImagePicture          *pic;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *images = @[@"eft_skin_soft.jpg",@"eft_skin_sunshine.jpg",@"eft_lightcolor_colorblue.jpg",@"eft_lightcolor_sweetred.jpg",@"eft_filmflex_005.jpg"];
        NSArray *titles = @[@"水彩画",@"素描",@"卡通",@"水晶球",@"浮雕",@"漩涡"];
        HCPhotoEditBaseScrollView *scrollView = [[HCPhotoEditBaseScrollView alloc] initWithFrame:self.bounds bottomTitle:@"特效" imagesNameArray:images titlesArray:titles buttonWidth:100 imageSize:60];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame icons:(NSArray*)icons
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        NSArray *images = @[@"eft_skin_soft.jpg",@"eft_skin_sunshine.jpg",@"eft_lightcolor_colorblue.jpg",@"eft_lightcolor_sweetred.jpg",@"eft_filmflex_005.jpg"];
        NSArray *titles = @[@"水彩画",@"素描",@"卡通",@"水晶球",@"浮雕",@"漩涡"];
        HCPhotoEditBaseScrollView *scrollView = [[HCPhotoEditBaseScrollView alloc] initWithFrame:self.bounds bottomTitle:@"特效" imagesArray:icons titlesArray:titles buttonWidth:100 imageSize:60];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
    }
    return self;
}

+(HCPhotoEditBaseItemView*)showInView:(UIView*)view icons:(NSArray *)icons
{
    HCPhotoEditSpecialEffectsItemView *effectView = [[HCPhotoEditSpecialEffectsItemView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 150, view.bounds.size.width, 150) icons:icons];
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
    NSArray *filters = @[@"GPUImageKuwaharaFilter",@"GPUImageSketchFilter",@"GPUImageSmoothToonFilter",@"GPUImageGlassSphereFilter",@"GPUImageEmbossFilter",@"GPUImageSwirlFilter"];
    
    [self applyFilter:filters[index]];
    
}

-(void)applyFilter:(NSString*)filter
{
    pic = [[GPUImagePicture alloc] initWithImage:self.oriImage];
    GPUImageFilter *outFilter = [[[NSClassFromString(filter) class] alloc] init];
    if ([filter isEqualToString:@"GPUImageKuwaharaFilter"]) {
        //水彩画滤镜
        GPUImageKuwaharaFilter *f = (GPUImageKuwaharaFilter*)outFilter;
        f.radius = 10;
    }
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
