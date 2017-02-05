//
//  CHPhotoEditBaseImageView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditBaseImageView.h"
#import "HCPhotoEditFuzzyMaskView.h"

@interface HCPhotoEditBaseImageView()<UIGestureRecognizerDelegate>



@end

@implementation HCPhotoEditBaseImageView
{
    CGPoint lastPoint;
    float   currentScale;
    float   lastScale;
    float   currentAngle;
    float   lastAngle;
    BOOL    isOnPanGesture;
    BOOL    isOnPinchGesture;
    BOOL    isOnRotateGesture;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showCircleMask = NO;
        currentScale = 1.0;
        lastScale = 1.0;
        currentAngle = 0;
        [self addSubview:self.imageView];
        self.imageView.frame = self.bounds;
        self.userInteractionEnabled = YES;
        //滑动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSelector:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        //单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureSelector:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        //捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureSelector:)];
        pinch.delegate = self;
        [self addGestureRecognizer:pinch];
        //旋转手势
//        UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGestureSelector:)];
//        rotate.delegate = self;
//        [self addGestureRecognizer:rotate];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.panGestureMovedBlock) {
        [self showMaskView];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.panGestureEndedBlock) {
       [self hideMaskView];
    }
    
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.panGestureEndedBlock) {
        [self hideMaskView];
    }
}

//滑动
-(void)panGestureSelector:(UIPanGestureRecognizer*)pan
{
    isOnPanGesture = YES;
    CGPoint pt = [pan translationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        lastPoint = CGPointMake(0, 0);
    }else if (pan.state == UIGestureRecognizerStateChanged){
        if (self.panGestureMovedBlock) {
            self.panGestureMovedBlock(CGPointMake(pt.x - lastPoint.x, pt.y - lastPoint.y));
            [self updateMaskView:CGPointMake(pt.x - lastPoint.x, pt.y - lastPoint.y)];
        }
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled){
        isOnPanGesture = NO;
        if (self.panGestureEndedBlock) {
            [self updateMaskView:CGPointMake(pt.x - lastPoint.x, pt.y - lastPoint.y)];
            self.panGestureEndedBlock(CGPointMake(pt.x - lastPoint.x, pt.y - lastPoint.y));
            [self hideMaskView];
        }
    }
    lastPoint = pt;
}

//缩放
-(void)pinchGestureSelector:(UIPinchGestureRecognizer*)pinch
{
    NSLog(@"scale = %f",pinch.scale);
    isOnPinchGesture = YES;
    if (pinch.state == UIGestureRecognizerStateChanged) {
        if (self.pinchGestureBlock) {
            currentScale = pinch.scale * lastScale;
            self.pinchGestureBlock(pinch.scale);
            [self updateMaskView:CGPointMake(0, 0)];
        }
    }
    
    if (pinch.state == UIGestureRecognizerStateEnded||pinch.state == UIGestureRecognizerStateCancelled) {
        isOnPinchGesture = NO;
        if (self.pinchEndedGestureBlock) {
            self.pinchEndedGestureBlock(pinch.scale);
            lastScale = currentScale;
            [self hideMaskView];
        }
    }
}

//旋转
-(void)rotateGestureSelector:(UIRotationGestureRecognizer*)rotate
{
    isOnRotateGesture = YES;
    if (self.rotateGestureBlock) {
        currentAngle = rotate.rotation + lastAngle;
        self.rotateGestureBlock(rotate.rotation);
        [self updateMaskView:CGPointMake(0, 0)];
    }

    if (rotate.state == UIGestureRecognizerStateEnded||rotate.state == UIGestureRecognizerStateCancelled) {
        isOnRotateGesture = NO;
        if (self.rotateEndGestureBlock) {
            self.rotateEndGestureBlock(rotate.rotation);
            [self hideMaskView];
            lastAngle = currentAngle;
        }
    }
    
    
}

-(void)tapGestureSelector:(UITapGestureRecognizer*)tap
{
    if (self.tapGestureBlock) {
        self.tapGestureBlock([tap locationInView:self]);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.image) {
        self.realImageSize = [self getImageScaleSize:self.image.size];
    }
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    if (self.bounds.size.width > 0 && self.bounds.size.height > 0) {
        self.realImageSize = [self getImageScaleSize:self.image.size];
    }
    
    if (!_oriImage && image) {
        _oriImage = image;
    }
    self.imageView.image = image;
}

//获取图片适应后的真实大小（UIViewContentModeScaleAspectFit）
-(CGSize)getImageScaleSize:(CGSize)imageSize
{
    if (imageSize.width == 0 && imageSize.height == 0) {
        return CGSizeMake(0, 0);
    }
    CGSize resultSize;
    CGFloat scale = imageSize.width / self.bounds.size.width;
    if (imageSize.height / scale < self.bounds.size.height)
    {
        resultSize.width = self.bounds.size.width;
        resultSize.height = imageSize.height / scale;
    }
    else
    {
        CGFloat scale2 = imageSize.height / self.bounds.size.height;
        resultSize.width = imageSize.width / scale2;
        resultSize.height = self.bounds.size.height;
    }
    
    _imageScale = resultSize.width / imageSize.width;
    self.imageView.frame = CGRectMake(0, 0, resultSize.width, resultSize.height);
    self.imageView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    return resultSize;
}

-(void)showMaskView
{
     self.maskView.hidden = NO;
     self.maskView.alpha = 0;
     [UIView animateWithDuration:0.1 animations:^{
         self.maskView.alpha = 1.0;
     }];
}

-(void)hideMaskView
{
    if (isOnPanGesture || isOnRotateGesture || isOnPinchGesture) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        self.maskView.hidden = YES;
    }];
}

-(void)updateMaskView:(CGPoint)pt
{
//    NSLog(@"currentScale = %f",currentScale);
    CGPoint point = self.maskView.centerPoint;
    point.x += pt.x;
    point.y += pt.y;
    self.maskView.centerPoint = point;
    self.maskView.radius = 0.3 * currentScale;
    
    
    if (_showCircleMask)
    {
//        CGRect frame = self.maskView.maskView.frame;
//        frame.origin.x += pt.x;
//        frame.origin.y += pt.y;
        
        
//        self.maskView.maskView.transform = CGAffineTransformMakeScale(currentScale, currentScale);
    }
    else
    {
        CGPoint point = self.maskView.maskView.layer.anchorPoint;
        point.x = point.x - (pt.x * cos(currentAngle) + pt.y * sin(currentAngle)) / self.maskView.maskView.bounds.size.width / currentScale;
        point.y = point.y - (pt.y * sin(currentAngle) + pt.x * cos(currentAngle)) / self.maskView.maskView.bounds.size.height / currentScale;
        self.maskView.maskView.layer.anchorPoint = point;
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(currentAngle);
        self.maskView.maskView.transform = CGAffineTransformScale(transform, currentScale, 1);
    }
}

-(HCPhotoEditFuzzyMaskView*)maskView
{
    if (!_maskView) {
        CGSize size = [self getImageScaleSize:self.image.size];
        
        _maskView = [[HCPhotoEditFuzzyMaskView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) image:self.oriImage isCircle:_showCircleMask];
        [self addSubview:_maskView];
        _maskView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    }
    
    return _maskView;
}

-(void)clearMaskView
{
    [self.maskView removeFromSuperview];
    self.maskView = nil;
    lastScale = 1;
    lastAngle = 0;
    currentAngle = 0;
    currentScale = 1;
    self.showCircleMask = NO;
    [self setPanGestureMovedBlock:nil];
    [self setPanGestureEndedBlock:nil];
    [self setPinchGestureBlock:nil];
    [self setPinchEndedGestureBlock:nil];
    [self setRotateEndGestureBlock:nil];
    [self setRotateGestureBlock:nil];
}


-(UIImageView*)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

-(void)rotateLeft
{
    
    CGSize imageSize = CGSizeMake(self.imageView.frame.size.height, self.imageView.frame.size.width);
    CGSize resultSize;
    CGFloat scale = imageSize.width / self.bounds.size.width;
    if (imageSize.height / scale < self.bounds.size.height)
    {
        resultSize.width = self.bounds.size.width;
        resultSize.height = imageSize.height / scale;
    }
    else
    {
        CGFloat scale2 = imageSize.height / self.bounds.size.height;
        resultSize.width = imageSize.width / scale2;
        resultSize.height = self.bounds.size.height;
    }
    
    self.imageView.frame = CGRectMake(0, 0, resultSize.height, resultSize.width);
    self.imageView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, -M_PI_2);
}

-(void)rotateRight
{
    
    CGSize imageSize = CGSizeMake(self.imageView.frame.size.height, self.imageView.frame.size.width);
    CGSize resultSize;
    CGFloat scale = imageSize.width / self.bounds.size.width;
    if (imageSize.height / scale < self.bounds.size.height)
    {
        resultSize.width = self.bounds.size.width;
        resultSize.height = imageSize.height / scale;
    }
    else
    {
        CGFloat scale2 = imageSize.height / self.bounds.size.height;
        resultSize.width = imageSize.width / scale2;
        resultSize.height = self.bounds.size.height;
    }
    
    self.imageView.frame = CGRectMake(0, 0, resultSize.height, resultSize.width);
    self.imageView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, M_PI_2);
}

-(void)flipX
{
    _imageView.transform = CGAffineTransformScale(_imageView.transform, -1, 1);
}

-(void)flipY
{
    _imageView.transform = CGAffineTransformScale(_imageView.transform, 1, -1);
}

-(void)restore
{
    _imageView.transform = CGAffineTransformIdentity;
    [self getImageScaleSize:self.image.size];
}

@end
