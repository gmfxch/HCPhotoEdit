//
//  CHPhotoEditViewController.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//
#define COLOR_RGB(R,G,B)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define IMAGE_WITHNAME(X)   [HCPhotoEditViewController resourceImageWithName:X]
#define TEXTURE_WITHNAME(X)   [HCPhotoEditViewController textureImageWithName:X]

#import <UIKit/UIKit.h>
@class HCPhotoEditViewController;
@protocol HCPhotoEditViewControllerDelegate <NSObject>

@optional
/**
 点击“完成”按钮回调函数
 */
-(void)didClickFinishButtonWithEditController:(HCPhotoEditViewController*)controller  newImage:(UIImage*)newImage;
/**
 点击“取消”按钮回调函数
 */
-(void)didClickCancelButtonWithEditController:(HCPhotoEditViewController*)controller;

@end

@interface HCPhotoEditViewController : UIViewController

@property(nonatomic, strong) UIImage  *oriImage;
@property(nonatomic, weak) id<HCPhotoEditViewControllerDelegate> delegate;


+(UIImage*)resourceImageWithName:(NSString*)name;
+(UIImage*)textureImageWithName:(NSString*)name;

@end
