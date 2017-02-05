//
//  HCPhotoEditLightItemView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/7.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditLightItemView.h"
#import "HCTestFilter.h"

@implementation HCPhotoEditLightItemView
{
    GPUImagePicture        *pic;
    NSMutableArray         *textureImageNames;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSMutableArray *images = [NSMutableArray arrayWithArray:@[@"eft_halo_11.jpg",@"eft_halo_12.jpg",@"eft_halo_14.jpg",@"eft_halo_15.jpg",@"eft_halo_16.jpg",@"eft_halo_17.jpg",@"eft_halo_22.jpg",@"eft_halo_50.jpg",@"eft_halo_51.jpg",@"eft_halo_52.jpg",@"eft_halo_53.jpg",@"eft_halo_54.jpg"]];
        NSMutableArray *titles = [NSMutableArray arrayWithArray:@[@"F1",@"F2",@"F3",@"F4",@"F5",@"F6",@"F7",@"F8",@"F9",@"F10",@"F11",@"F12"]];
        HCPhotoEditBaseScrollView *scrollView = [[HCPhotoEditBaseScrollView alloc] initWithFrame:self.bounds bottomTitle:@"光影" imagesNameArray:images titlesArray:titles buttonWidth:90 imageSize:55];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        
        textureImageNames = [NSMutableArray arrayWithArray:@[@"halo_11.jpg",@"halo_12.jpg",@"halo_14.jpg",@"halo_15.jpg",@"halo_16.jpg",@"halo_17.jpg",@"halo_22.jpg",@"halo_50.jpg",@"halo_51.jpg",@"halo_52.jpg",@"halo_53.jpg",@"halo_54.jpg"]];
        
        
    }
    return self;
}

+(HCPhotoEditBaseItemView*)showInView:(UIView*)view
{
    HCPhotoEditLightItemView *effectView = [[HCPhotoEditLightItemView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 150, view.bounds.size.width, 150)];
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

    pic = [[GPUImagePicture alloc] initWithImage:self.oriImage];
    HCTestFilter *filter = [[HCTestFilter alloc] initWithTextureImage:[UIImage imageNamed:textureImageNames[index]]];
    [pic addTarget:filter];
    [filter useNextFrameForImageCapture];
    [pic processImage];
    UIImage *newImage = [filter imageFromCurrentFramebuffer];
    if (newImage) {
        
        UIGraphicsBeginImageContextWithOptions(self.oriImage.size, NO, 1.0);
        [self.oriImage drawInRect:CGRectMake(0, 0, self.oriImage.size.width, self.oriImage.size.height)];
        [newImage drawInRect:CGRectMake(0, 0, self.oriImage.size.width, self.oriImage.size.height) blendMode:kCGBlendModePlusLighter alpha:1.0];
        UIImage *newimage2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.mainImageView.image = newimage2;
    }
}

-(void)okEdit
{
    [super okEdit];
}

-(void)cancelEdit
{
    [super cancelEdit];
    if (self.oriImage) {
       self.mainImageView.image = self.oriImage;
    }
}

@end
