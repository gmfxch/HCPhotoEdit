//
//  HCPhotoEditBaseScrollView.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCPhotoEditBaseScrollViewDelegate <NSObject>

-(void)didClickButtonAtIndex:(NSInteger)index;
-(void)didClickButtonAtIndex:(NSInteger)index  button:(UIButton*)btn;
-(void)cancelEdit;
-(void)okEdit;

@end

@interface HCPhotoEditBaseScrollView : UIView

@property(nonatomic, assign) BOOL  ignoreButtonSelect;
@property(nonatomic, weak) id<HCPhotoEditBaseScrollViewDelegate> delegate;
@property(nonatomic, strong) UIView  *bottomView;
@property(nonatomic, strong) UIScrollView  *scrollView;

-(instancetype)initWithFrame:(CGRect)frame  bottomTitle:(NSString*)title  imagesNameArray:(NSArray*)images  titlesArray:(NSArray*)titles buttonWidth:(float)width  imageSize:(float)size;
-(instancetype)initWithFrame:(CGRect)frame  bottomTitle:(NSString*)title  imagesArray:(NSArray*)images  titlesArray:(NSArray*)titles buttonWidth:(float)width  imageSize:(float)size;


@end
