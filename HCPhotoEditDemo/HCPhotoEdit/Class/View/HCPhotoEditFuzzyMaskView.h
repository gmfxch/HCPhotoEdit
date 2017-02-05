//
//  HCPhotoEditFuzzyMaskView.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/11.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCPhotoEditFuzzyMaskView : UIView

@property(nonatomic, assign) float   radius;
@property(nonatomic, assign) float   angle;
@property(nonatomic, assign) CGPoint centerPoint;
//@property(nonatomic, assign) BOOL    drawLineGradient;
//@property(nonatomic, strong) CAGradientLayer  *gradientLayer;
//@property(nonatomic, strong) CALayer          *maskLayer;
@property(nonatomic, strong) UIView           *maskView;
@property(nonatomic, strong) UIImage          *image;

-(instancetype)initWithFrame:(CGRect)frame  image:(UIImage*)image  isCircle:(BOOL)isCircle;

//-(void)addGradientLayer;

@end
