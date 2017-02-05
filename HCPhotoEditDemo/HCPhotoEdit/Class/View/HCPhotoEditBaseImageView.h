//
//  CHPhotoEditBaseImageView.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCPhotoEditFuzzyMaskView.h"


@interface HCPhotoEditBaseImageView : UIView

@property(nonatomic, strong) UIImage  *image;
//@property(nonatomic, copy)void(^touchMovedBlock)(CGPoint pt);//pt表示位移（并不是具体位置）
//@property(nonatomic, copy)void(^touchEndedBlock)(CGPoint pt);

@property(nonatomic, copy)void(^pinchGestureBlock)(float dis); //捏合手势block
@property(nonatomic, copy)void(^pinchEndedGestureBlock)(float dis); //捏合手结束block
@property(nonatomic, copy)void(^panGestureMovedBlock)(CGPoint pt); //滑动手势block
@property(nonatomic, copy)void(^panGestureEndedBlock)(CGPoint pt); //滑动手势结束block
@property(nonatomic, copy)void(^tapGestureBlock)(CGPoint pt); //单击手势block
@property(nonatomic, copy)void(^rotateGestureBlock)(float angle);//旋转手势
@property(nonatomic, copy)void(^rotateEndGestureBlock)(float angle);//旋转手势结束

@property(nonatomic, assign) CGSize  realImageSize;
@property(nonatomic, assign) float   imageScale;
@property(nonatomic, strong) UIImage  *oriImage;
@property(nonatomic, strong) HCPhotoEditFuzzyMaskView *maskView;
@property(nonatomic, strong) UIImageView  *imageView;
@property(nonatomic, assign) BOOL         showCircleMask;

-(void)clearMaskView;

-(void)rotateLeft;
-(void)rotateRight;
-(void)flipX;
-(void)flipY;
-(void)restore;



@end
