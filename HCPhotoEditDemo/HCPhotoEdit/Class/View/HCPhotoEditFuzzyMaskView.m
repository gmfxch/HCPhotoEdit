//
//  HCPhotoEditFuzzyMaskView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/11.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditFuzzyMaskView.h"

@implementation HCPhotoEditFuzzyMaskView
{
    CALayer   *maskLayer;
}

-(instancetype)initWithFrame:(CGRect)frame  image:(UIImage*)image  isCircle:(BOOL)isCircle
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = image;
        self.clipsToBounds = YES;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
        self.userInteractionEnabled = NO;
        _centerPoint = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        _radius = 0.3;
        _angle = 0;
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        imageView.backgroundColor = [UIColor clearColor];
//        imageView.image = image;
//        [self addSubview:imageView];
//        
//        float width = self.bounds.size.width * _radius;
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2.0 - width/2.0 , -100000, width, 200000 + self.bounds.size.height)];
//        view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"line_mask"].CGImage);
//        self.maskView = view;
//        imageView.layer.mask = view.layer;
//        
//        if (isCircle) {
//            view.frame = CGRectMake(0, 0, 100, 100);
//            view.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
//            view.layer.cornerRadius = 50;
////            view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"circle_mask"].CGImage);
//        }
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//
//    if (self.drawLineGradient)
//    {
//
////        float X = _centerPoint.x / self.bounds.size.width;
////        //y = k * x + m;
////        //b = k * a + m;
////        //m = b - k * a;
////        //y = k * (x - a) + b;
////        //y = tan(angle) * (x - _centerPoint.x) + _centerPoint.y;
////        //x = 0; y = -tan(angle)*_centerPoint.x + _centerPoint.y;
////        //y = 0; x = _centerPoint.x - _centerPoint.y/tan(angle)
////        //
////        CGFloat locations[] = { 0.0, (X - _radius/2.0) , X, (X + _radius/2.0), 1.0};
////        NSArray *colors = @[(__bridge id) [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor, (__bridge id) [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor, (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor,(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor, (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor];
////        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
////        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(self.bounds.size.width, 0), kCGGradientDrawsAfterEndLocation);
//       
//        
//    }
//    else
//    {
        CGFloat locations[] = { 0.0, _radius , _radius, 1.0};
        NSArray *colors = @[(__bridge id) [[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor, (__bridge id) [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor, (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor];
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
        CGContextDrawRadialGradient(context, gradient, _centerPoint, 4, _centerPoint, self.bounds.size.width, kCGGradientDrawsAfterEndLocation);
//    }
}

-(void)setRadius:(float)radius
{
    _radius = radius;
    [self setNeedsDisplay];
}
-(void)setCenterPoint:(CGPoint)centerPoint
{
    _centerPoint = centerPoint;
    [self setNeedsDisplay];
}

//-(CAGradientLayer*)gradientLayer
//{
//    if (!_gradientLayer) {
//        float radius = 0.02;
//        float size = MAX(self.bounds.size.width, self.bounds.size.height) * 5;
//        _gradientLayer = [CAGradientLayer layer];
//        _gradientLayer.frame = CGRectMake(self.bounds.size.width/2.0 - size/2.0 , self.bounds.size.height/2.0 - size / 2.0 , size, size);
//        _gradientLayer.startPoint = CGPointMake(0, 0);
//        _gradientLayer.endPoint = CGPointMake(1, 0);
//        [self.layer addSublayer:_gradientLayer];
//        NSArray *locations = @[@0, @(0.5 - radius/2.0), @0.5, @(0.5 + radius/2.0), @1.0];
//        NSArray *colors = @[(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor, (__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor,(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.0].CGColor,(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor,(__bridge id)[[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor];
//        _gradientLayer.locations = locations;
//        _gradientLayer.colors = colors;
//        
//    }
//    return _gradientLayer;
//}

-(void)addGradientLayer
{
//    [self gradientLayer];
}


@end
