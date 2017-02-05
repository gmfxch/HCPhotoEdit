//
//  HCPhotoEditCustomSlider.h
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCPhotoEditCustomSlider : UISlider

//分段值
@property(nonatomic, copy) void(^valueChangedBlock)(NSInteger index);

@property(nonatomic, copy) void(^touchEndedBlock)();

-(void)setItemTitles:(NSArray*)titles;
-(void)setDefaultItemIndex:(NSInteger)index;



@end
