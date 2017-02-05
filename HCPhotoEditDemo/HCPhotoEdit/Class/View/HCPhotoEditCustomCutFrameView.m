//
//  HCPhotoEditCustomCutFrameView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/9.
//  Copyright © 2016年 chenhao. All rights reserved.
//
#define MAX_SIZE   100.0

#import "HCPhotoEditCustomCutFrameView.h"
#import "HCPhotoEditViewController.h"

@implementation HCPhotoEditCustomCutFrameView
{
    UIImageView *leftTop;
    UIImageView *leftBottom;
    UIImageView *rightBottom;
    UIImageView *rightTop;
    UIImageView *top;
    UIImageView *left;
    UIImageView *bottom;
    UIImageView *right;
    CAShapeLayer *dottedShapLayer;
    CAShapeLayer *realLineShapLayer;
    CGRect        oriFrame;
    CGPoint       lastPoint;
    float         buttonSize;
    CGSize        maxSizeP;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _proportion = 0;
        oriFrame = frame;
        self.backgroundColor = [UIColor clearColor];
        buttonSize = 40;
        //顶点
        leftTop = [[UIImageView alloc] initWithImage:IMAGE_WITHNAME(@"photo_crop_resize_button")];
        leftTop.frame = CGRectMake(0, 0, buttonSize, buttonSize);
        leftTop.contentMode = UIViewContentModeCenter;
        [self addSubview:leftTop];
        
        leftBottom = [[UIImageView alloc] initWithImage:IMAGE_WITHNAME(@"photo_crop_resize_button")];
        leftBottom.frame = CGRectMake(0, self.bounds.size.height - buttonSize, buttonSize, buttonSize);
        leftBottom.contentMode = UIViewContentModeCenter;
        [self addSubview:leftBottom];
        
        
        
        rightBottom = [[UIImageView alloc] initWithImage:IMAGE_WITHNAME(@"photo_crop_resize_button")];
        rightBottom.frame = CGRectMake(self.bounds.size.width - buttonSize, self.bounds.size.height - buttonSize, buttonSize, buttonSize);
        rightBottom.contentMode = UIViewContentModeCenter;
        [self addSubview:rightBottom];
        
        
        rightTop = [[UIImageView alloc] initWithImage:IMAGE_WITHNAME(@"photo_crop_resize_button")];
        rightTop.frame = CGRectMake(self.bounds.size.width - buttonSize, 0, buttonSize, buttonSize);
        rightTop.contentMode = UIViewContentModeCenter;
        [self addSubview:rightTop];
        
        
        //photo_crop_resize_h@2x
        top = [[UIImageView alloc] initWithImage:IMAGE_WITHNAME(@"photo_crop_resize_w")];
        top.frame = CGRectMake(self.bounds.size.width/2.0 - buttonSize/2.0, 0, buttonSize, buttonSize);
        top.contentMode = UIViewContentModeCenter;
        [self addSubview:top];
        
        
        left = [[UIImageView alloc] initWithImage:IMAGE_WITHNAME(@"photo_crop_resize_h")];
        left.frame = CGRectMake(0, self.bounds.size.height/2.0 - buttonSize/2.0, buttonSize, buttonSize);
        left.contentMode = UIViewContentModeCenter;
        [self addSubview:left];
        
        
        bottom = [[UIImageView alloc] initWithImage:IMAGE_WITHNAME(@"photo_crop_resize_w")];
        bottom.frame = CGRectMake(self.bounds.size.width/2.0 - buttonSize/2.0, self.bounds.size.height - buttonSize, buttonSize, buttonSize);
        bottom.contentMode = UIViewContentModeCenter;
        [self addSubview:bottom];
        
        
        right = [[UIImageView alloc] initWithImage:IMAGE_WITHNAME(@"photo_crop_resize_h")];
        right.frame = CGRectMake(self.bounds.size.width - buttonSize, self.bounds.size.height/2.0 - buttonSize/2.0, buttonSize, buttonSize);
        right.contentMode = UIViewContentModeCenter;
        [self addSubview:right];
        
        
        //边框实线
        UIBezierPath *path = [UIBezierPath bezierPath];
        //坐边
        [path moveToPoint:CGPointMake(buttonSize/2.0, buttonSize/2.0)];
        [path addLineToPoint:CGPointMake(buttonSize/2.0, self.bounds.size.height - buttonSize/2.0)];
        //底边
        [path addLineToPoint:CGPointMake(self.bounds.size.width -  buttonSize/2.0, self.bounds.size.height - buttonSize/2.0)];
        //右边
        [path addLineToPoint:CGPointMake(self.bounds.size.width - buttonSize/2.0, buttonSize/2.0)];
        //顶部
        [path addLineToPoint:CGPointMake(buttonSize/2.0, buttonSize/2.0)];
        realLineShapLayer = [[CAShapeLayer alloc] init];
        realLineShapLayer.path = path.CGPath;
        realLineShapLayer.lineWidth = 1.0;
        realLineShapLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:realLineShapLayer];
        
        
        //虚线
        CGRect lineRect = CGRectMake(buttonSize/2.0, buttonSize/2.0, self.bounds.size.width - buttonSize, self.bounds.size.height - buttonSize);
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        
        //横1
        [path2 moveToPoint:CGPointMake(lineRect.origin.x, lineRect.size.height/4.0 + lineRect.origin.y)];
        [path2 addLineToPoint:CGPointMake(lineRect.size.width + lineRect.origin.x, lineRect.size.height/4.0 + lineRect.origin.y)];
        //横2
        [path2 moveToPoint:CGPointMake(lineRect.origin.x, lineRect.size.height/4.0 * 3 + lineRect.origin.y)];
        [path2 addLineToPoint:CGPointMake(lineRect.origin.x + lineRect.size.width, lineRect.size.height/4.0 * 3  + lineRect.origin.y)];
        
        [path2 moveToPoint:CGPointMake(lineRect.size.width/4.0 + lineRect.origin.x, lineRect.origin.y)];
        [path2 addLineToPoint:CGPointMake(lineRect.size.width/4.0 + lineRect.origin.x, lineRect.size.height + lineRect.origin.y)];
        
        [path2 moveToPoint:CGPointMake(lineRect.size.width/4.0 * 3+ lineRect.origin.x, lineRect.origin.y)];
        [path2 addLineToPoint:CGPointMake(lineRect.size.width/4.0 * 3 + lineRect.origin.x, lineRect.size.height + lineRect.origin.y)];
 
        dottedShapLayer = [[CAShapeLayer alloc] init];
        dottedShapLayer.path = path2.CGPath;
        dottedShapLayer.lineWidth = 1.0;
        dottedShapLayer.lineDashPattern = @[@2,@2];
        dottedShapLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:dottedShapLayer];
        dottedShapLayer.fillColor = [UIColor clearColor].CGColor;
        realLineShapLayer.fillColor = [UIColor clearColor].CGColor;
        
        leftTop.userInteractionEnabled = YES;
        leftBottom.userInteractionEnabled = YES;
        rightTop.userInteractionEnabled = YES;
        rightBottom.userInteractionEnabled = YES;
        left.userInteractionEnabled = YES;
        bottom.userInteractionEnabled = YES;
        right.userInteractionEnabled = YES;
        top.userInteractionEnabled = YES;
        
        [leftTop addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSelector:)]];
        [leftBottom addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSelector:)]];
        [rightTop addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSelector:)]];
        [rightBottom addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSelector:)]];
        [left addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSelector:)]];
        [right addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSelector:)]];
        [top addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSelector:)]];
        [bottom addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSelector:)]];
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureSelector:)]];
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    
    [super setFrame:frame];

    leftTop.frame = CGRectMake(0, 0, buttonSize, buttonSize);

    leftBottom.frame = CGRectMake(0, self.bounds.size.height - buttonSize, buttonSize, buttonSize);

    rightBottom.frame = CGRectMake(self.bounds.size.width - buttonSize, self.bounds.size.height - buttonSize, buttonSize, buttonSize);

    rightTop.frame = CGRectMake(self.bounds.size.width - buttonSize, 0, buttonSize, buttonSize);

    top.frame = CGRectMake(self.bounds.size.width/2.0 - buttonSize/2.0, 0, buttonSize, buttonSize);

    left.frame = CGRectMake(0, self.bounds.size.height/2.0 - buttonSize/2.0, buttonSize, buttonSize);
    
    bottom.frame = CGRectMake(self.bounds.size.width/2.0 - buttonSize/2.0, self.bounds.size.height - buttonSize, buttonSize, buttonSize);

    right.frame = CGRectMake(self.bounds.size.width - buttonSize, self.bounds.size.height/2.0 - buttonSize/2.0, buttonSize, buttonSize);
    
    //边框实线
    UIBezierPath *path = [UIBezierPath bezierPath];
    //坐边
    [path moveToPoint:CGPointMake(buttonSize/2.0, buttonSize/2.0)];
    [path addLineToPoint:CGPointMake(buttonSize/2.0, self.bounds.size.height - buttonSize/2.0)];
    //底边
    [path addLineToPoint:CGPointMake(self.bounds.size.width -  buttonSize/2.0, self.bounds.size.height - buttonSize/2.0)];
    //右边
    [path addLineToPoint:CGPointMake(self.bounds.size.width - buttonSize/2.0, buttonSize/2.0)];
    //顶部
    [path addLineToPoint:CGPointMake(buttonSize/2.0, buttonSize/2.0)];
    
    realLineShapLayer.path = path.CGPath;
    
    //虚线
    CGRect lineRect = CGRectMake(buttonSize/2.0, buttonSize/2.0, self.bounds.size.width - buttonSize, self.bounds.size.height - buttonSize);
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    
    //横1
    [path2 moveToPoint:CGPointMake(lineRect.origin.x, lineRect.size.height/4.0 + lineRect.origin.y)];
    [path2 addLineToPoint:CGPointMake(lineRect.size.width + lineRect.origin.x, lineRect.size.height/4.0 + lineRect.origin.y)];
    //横2
    [path2 moveToPoint:CGPointMake(lineRect.origin.x, lineRect.size.height/4.0 * 3 + lineRect.origin.y)];
    [path2 addLineToPoint:CGPointMake(lineRect.origin.x + lineRect.size.width, lineRect.size.height/4.0 * 3  + lineRect.origin.y)];
    
    [path2 moveToPoint:CGPointMake(lineRect.size.width/4.0 + lineRect.origin.x, lineRect.origin.y)];
    [path2 addLineToPoint:CGPointMake(lineRect.size.width/4.0 + lineRect.origin.x, lineRect.size.height + lineRect.origin.y)];
    
    [path2 moveToPoint:CGPointMake(lineRect.size.width/4.0 * 3+ lineRect.origin.x, lineRect.origin.y)];
    [path2 addLineToPoint:CGPointMake(lineRect.size.width/4.0 * 3 + lineRect.origin.x, lineRect.size.height + lineRect.origin.y)];

    dottedShapLayer.path = path2.CGPath;
}


-(void)panGestureSelector:(UIPanGestureRecognizer*)pan
{
    
    CGPoint pt = [pan translationInView:self.superview];
    CGRect frame = self.frame;
    if (pan.view == top)
    {
        float dis = (pt.y - lastPoint.y);
        if (frame.size.height - dis >= MAX_SIZE) {
            frame.origin.y += dis;
            frame.size.height -= dis;
            frame.size.height = MIN((CGRectGetMaxY(self.frame) - oriFrame.origin.y), frame.size.height);
        }else{
            dis = frame.size.height - MAX_SIZE;
            frame.origin.y += dis;
            frame.size.height -= dis;
        }
    }
    else if (pan.view == left)
    {
        float dis = (pt.x - lastPoint.x);
        if (frame.size.width - dis >= MAX_SIZE) {
            frame.origin.x += dis;
            frame.size.width -= dis;
            frame.size.width = MIN((CGRectGetMaxX(self.frame) - oriFrame.origin.x), frame.size.width);
        }else{
            dis = frame.size.width - MAX_SIZE;
            frame.origin.x += dis;
            frame.size.width -= dis;
        }
    }
    else if (pan.view == bottom)
    {
        float dis = (pt.y - lastPoint.y);
        if (frame.size.height + dis + frame.origin.y <= CGRectGetMaxY(oriFrame)) {
            frame.size.height += dis;
        }else{
            frame.size.height = CGRectGetMaxY(oriFrame) - frame.origin.y;
        }
    }
    else if (pan.view == right)
    {
        float dis = (pt.x - lastPoint.x);
        if (frame.size.width + dis + frame.origin.x <= CGRectGetMaxX(oriFrame)) {
            frame.size.width += dis;
        }else{
            frame.size.width = CGRectGetMaxX(oriFrame) - frame.origin.x;
        }
    }
    else if (pan.view == leftTop)
    {
        if (_proportion == 0) { //自由模式
            float dis = (pt.x - lastPoint.x);
            if (frame.size.width - dis >= MAX_SIZE) {
                frame.origin.x += dis;
                frame.size.width -= dis;
                frame.size.width = MIN((CGRectGetMaxX(self.frame) - oriFrame.origin.x), frame.size.width);
            }else{
                dis = frame.size.width - MAX_SIZE;
                frame.origin.x += dis;
                frame.size.width -= dis;
            }
            
            float dis2 = (pt.y - lastPoint.y);
            if (frame.size.height - dis2 >= MAX_SIZE) {
                frame.origin.y += dis2;
                frame.size.height -= dis2;
                frame.size.height = MIN((CGRectGetMaxY(self.frame) - oriFrame.origin.y), frame.size.height);
            }else{
                dis2 = frame.size.height - MAX_SIZE;
                frame.origin.y += dis2;
                frame.size.height -= dis2;
            }
        }
        else //比例模式
        {
            float scale;
            if (fabs(pt.x - lastPoint.x) > fabs(pt.y - lastPoint.y)) {
                scale = (pt.x - lastPoint.x)/frame.size.width;
            }else{
                scale = (pt.y - lastPoint.y)/frame.size.height;
            }
            float maxW = CGRectGetMaxX(frame) - self.mainImageView.frame.origin.x - (self.mainImageView.bounds.size.width/2.0 - self.mainImageView.realImageSize.width/2.0) + buttonSize/2.0;
            float maxH = CGRectGetMaxY(frame) - self.mainImageView.frame.origin.y - (self.mainImageView.bounds.size.height/2.0 - self.mainImageView.realImageSize.height/2.0) + buttonSize/2.0;
            
            if ((frame.origin.x + frame.size.width * scale) >= 0 &&
                (frame.origin.y + frame.size.height * scale) >= 0 &&
                frame.size.width*(1 - scale) >= MAX_SIZE &&
                frame.size.height*(1 - scale) >= MAX_SIZE &&
                frame.size.width*(1 - scale) <= maxW &&
                frame.size.height*(1 - scale) <= maxH) {
                
                frame.origin.x += frame.size.width * scale;
                frame.origin.y += frame.size.height * scale;
                frame.size.width *= (1 - scale);
                frame.size.height *= (1 - scale);
            }
        }
        
    }
    else if (pan.view == leftBottom)
    {
        if (_proportion == 0) {
            float dis = (pt.x - lastPoint.x);
            if (frame.size.width - dis >= MAX_SIZE) {
                frame.origin.x += dis;
                frame.size.width -= dis;
                frame.size.width = MIN((CGRectGetMaxX(self.frame) - oriFrame.origin.x), frame.size.width);
            }else{
                dis = frame.size.width - MAX_SIZE;
                frame.origin.x += dis;
                frame.size.width -= dis;
            }
            
            float dis2 = (pt.y - lastPoint.y);
            if (frame.size.height + dis2 + frame.origin.y <= CGRectGetMaxY(oriFrame)) {
                frame.size.height += dis2;
            }else{
                frame.size.height = CGRectGetMaxY(oriFrame) - frame.origin.y;
            }
        }
        else
        {
            float scale;
            if (fabs(pt.x - lastPoint.x) > fabs(pt.y - lastPoint.y)) {
                scale = (pt.x - lastPoint.x)/frame.size.width;
            }else{
                scale = -(pt.y - lastPoint.y)/frame.size.height;
            }
            float maxW = CGRectGetMaxX(frame) - self.mainImageView.frame.origin.x - (self.mainImageView.bounds.size.width/2.0 - self.mainImageView.realImageSize.width/2.0) + buttonSize/2.0;
            float maxH = CGRectGetMaxY(oriFrame) - frame.origin.y;
            
            if ((frame.origin.x + frame.size.width * scale) >= 0 &&
                (frame.origin.y + frame.size.height * scale) >= 0 &&
                frame.size.width*(1 - scale) >= MAX_SIZE &&
                frame.size.height*(1 - scale) >= MAX_SIZE &&
                frame.size.width*(1 - scale) <= maxW &&
                frame.size.height*(1 - scale) <= maxH) {
                
                frame.origin.x += frame.size.width * scale;
                frame.size.width *= (1 - scale);
                frame.size.height *= (1 - scale);
            }
        }
        
    }
    else if (pan.view == rightTop)
    {
        if (_proportion == 0) {
            float dis = (pt.y - lastPoint.y);
            if (frame.size.height - dis >= MAX_SIZE) {
                frame.origin.y += dis;
                frame.size.height -= dis;
                frame.size.height = MIN((CGRectGetMaxY(self.frame) - oriFrame.origin.y), frame.size.height);
            }else{
                dis = frame.size.height - MAX_SIZE;
                frame.origin.y += dis;
                frame.size.height -= dis;
            }
            
            float dis2 = (pt.x - lastPoint.x);
            if (frame.size.width + dis2 + frame.origin.x <= CGRectGetMaxX(oriFrame)) {
                frame.size.width += dis2;
            }else{
                frame.size.width = CGRectGetMaxX(oriFrame) - frame.origin.x;
            }
        }else{
        
            float scale;
            if (fabs(pt.x - lastPoint.x) > fabs(pt.y - lastPoint.y)) {
                scale = -(pt.x - lastPoint.x)/frame.size.width;
            }else{
                scale = (pt.y - lastPoint.y)/frame.size.height;
            }
            float maxW = CGRectGetMaxX(oriFrame) - frame.origin.x;
            float maxH = CGRectGetMaxY(frame) - oriFrame.origin.y;
            
            if ((frame.origin.x + frame.size.width * scale) >= 0 &&
                (frame.origin.y + frame.size.height * scale) >= 0 &&
                frame.size.width*(1 - scale) >= MAX_SIZE &&
                frame.size.height*(1 - scale) >= MAX_SIZE &&
                frame.size.width*(1 - scale) <= maxW &&
                frame.size.height*(1 - scale) <= maxH) {
                
                frame.origin.y += frame.size.height * scale;
                frame.size.width *= (1 - scale);
                frame.size.height *= (1 - scale);
            }
            
        }
        
    }
    else if (pan.view == rightBottom)
    {
        if (_proportion == 0) {
            float dis = (pt.x - lastPoint.x);
            if (frame.size.width + dis + frame.origin.x <= CGRectGetMaxX(oriFrame)) {
                frame.size.width += dis;
            }else{
                frame.size.width = CGRectGetMaxX(oriFrame) - frame.origin.x;
            }
            
            float dis2 = (pt.y - lastPoint.y);
            if (frame.size.height + dis2 + frame.origin.y <= CGRectGetMaxY(oriFrame)) {
                frame.size.height += dis2;
            }else{
                frame.size.height = CGRectGetMaxY(oriFrame) - frame.origin.y;
            }
        }else{
            
            float scale;
            if (fabs(pt.x - lastPoint.x) > fabs(pt.y - lastPoint.y)) {
                scale = -(pt.x - lastPoint.x)/frame.size.width;
            }else{
                scale = -(pt.y - lastPoint.y)/frame.size.height;
            }
            float maxW = CGRectGetMaxX(oriFrame) - frame.origin.x;
            float maxH = CGRectGetMaxY(oriFrame) - frame.origin.y;
            
            if ((frame.origin.x + frame.size.width * scale) >= 0 &&
                (frame.origin.y + frame.size.height * scale) >= 0 &&
                frame.size.width*(1 - scale) >= MAX_SIZE &&
                frame.size.height*(1 - scale) >= MAX_SIZE &&
                frame.size.width*(1 - scale) <= maxW &&
                frame.size.height*(1 - scale) <= maxH) {
                
//                frame.origin.y += frame.size.height * scale;
                frame.size.width *= (1 - scale);
                frame.size.height *= (1 - scale);
            }
        
        }
        
    }
    else if (pan.view == self)
    {
        frame.origin.x += (pt.x - lastPoint.x);
        frame.origin.y += (pt.y - lastPoint.y);
    }
    
    //x,y最小值判断
    frame.origin.x = frame.origin.x <= oriFrame.origin.x ? oriFrame.origin.x : frame.origin.x;
    frame.origin.y = frame.origin.y <= oriFrame.origin.y ? oriFrame.origin.y : frame.origin.y;
    
    //w,h最大值判断
    frame.size.width = frame.size.width >= maxSizeP.width ? maxSizeP.width : frame.size.width;
    frame.size.height = frame.size.height >= maxSizeP.height ? maxSizeP.height : frame.size.height;
    
    //w,h最小值判断
    frame.size.width = frame.size.width <= MAX_SIZE ? MAX_SIZE : frame.size.width;
    frame.size.height = frame.size.height <= MAX_SIZE ? MAX_SIZE : frame.size.height;
    
    if (CGRectGetMaxX(frame) >= CGRectGetMaxX(oriFrame)) {
        frame.origin.x = CGRectGetMaxX(oriFrame) - frame.size.width;
    }
    if (CGRectGetMaxY(frame) >= CGRectGetMaxY(oriFrame)) {
        frame.origin.y = CGRectGetMaxY(oriFrame) - frame.size.height;
    }

    self.frame = frame;
    lastPoint = pt;
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        lastPoint = CGPointMake(0, 0);
    }
}

//-(void)adjustX:(CGPoint)pt
//{
//    
//}
//
//-(void)adjustY:(CGPoint)pt
//{
//    
//}
//
//-(void)adjustWidth:(CGPoint)pt
//{
//    
//}
//
//-(void)adjustHeight:(CGPoint)pt
//{
//    
//}

-(void)setProportion:(float)proportion
{
    _proportion = proportion;
    if (_proportion != 0) {
        top.hidden = YES;
        left.hidden = YES;
        bottom.hidden = YES;
        right.hidden = YES;
        
        CGPoint pt = self.center;
        CGRect frame = oriFrame;
        //_proportion = 1 ：2
        // (w - x) / h = 1/2;
        //x = w -  1/2 * h;
        float dis = frame.size.width - _proportion * frame.size.height;
        if (dis >= 0) {
            frame.size.width -= dis;
        }else{
            dis = frame.size.height - (1.0 / _proportion) * frame.size.width;
            frame.size.height -= dis;
        }
        self.frame = frame;
        self.center = pt;
        maxSizeP = frame.size;
    }
    else
    {
        maxSizeP = self.frame.size;
    }
}


@end
