//
//  HCPhotoEditCustomCutFrameView.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/9.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCPhotoEditBaseImageView.h"


@interface HCPhotoEditCustomCutFrameView : UIView

@property(nonatomic, assign) float  proportion; //比例（默认0）

@property(nonatomic, weak) HCPhotoEditBaseImageView *mainImageView;

@end
