//
//  HCPhotoEditCustomSlider.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditCustomSlider.h"
#import "HCPhotoEditViewController.h"

@implementation HCPhotoEditCustomSlider
{
    NSMutableArray      *titleLabelsArray;
    UILabel             *lastSelectLabel;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMinimumTrackTintColor:COLOR_RGB(91, 98, 105)];
        [self setMaximumTrackTintColor:COLOR_RGB(91, 98, 105)];
        [self setThumbImage:IMAGE_WITHNAME(@"photo_slider_step_button") forState:UIControlStateHighlighted];
        [self setThumbImage:IMAGE_WITHNAME(@"photo_slider_step_button") forState:UIControlStateNormal];
        self.maximumValue = 100.0;
        self.minimumValue = 0;
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setMinimumTrackTintColor:COLOR_RGB(91, 98, 105)];
        [self setMaximumTrackTintColor:COLOR_RGB(91, 98, 105)];
        [self setThumbImage:IMAGE_WITHNAME(@"photo_slider_step_button") forState:UIControlStateHighlighted];
        [self setThumbImage:IMAGE_WITHNAME(@"photo_slider_step_button") forState:UIControlStateNormal];
    }
    return self;
}

-(void)setItemTitles:(NSArray*)titles
{
    if (!self.superview) {
        return;
    }
    titleLabelsArray = [NSMutableArray array];
    float width = 25;
    float space = (self.bounds.size.width - width * titles.count) / (titles.count - 1);
    for (int index = 0; index < titles.count; index++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = COLOR_RGB(91, 98, 105);
        label.frame = CGRectMake(index * width + index * space + self.frame.origin.x, self.frame.origin.y - 25, width, 18);
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titles[index];
        [self.superview addSubview:label];
        [titleLabelsArray addObject:label];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self valueChanged];
    if (self.touchEndedBlock) {
        self.touchEndedBlock();
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self valueChanged];
    if (self.touchEndedBlock) {
        self.touchEndedBlock();
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (titleLabelsArray.count == 0) {
        return;
    }
    float persent = (self.maximumValue - self.minimumValue)/(titleLabelsArray.count - 1);
    int index = round(self.value / persent);
    lastSelectLabel.textColor = COLOR_RGB(91, 98, 105);
    lastSelectLabel = titleLabelsArray[index];
    lastSelectLabel.textColor = COLOR_RGB(250, 223, 84);
}

-(void)valueChanged
{
    if (titleLabelsArray.count == 0) {
        return;
    }
    
    float persent = (self.maximumValue - self.minimumValue)/(titleLabelsArray.count - 1);
    int index = round(self.value / persent);
    [UIView animateWithDuration:0.3 animations:^{
        [self setValue:(index * persent) animated:YES];
    }];
    
    if (self.valueChangedBlock) {
        self.valueChangedBlock(index);
    }
    
    lastSelectLabel.textColor = COLOR_RGB(91, 98, 105);
    lastSelectLabel = titleLabelsArray[index];
    lastSelectLabel.textColor = COLOR_RGB(250, 223, 84);
}

-(void)setDefaultItemIndex:(NSInteger)index
{
    if (titleLabelsArray.count == 0) {
        return;
    }
    lastSelectLabel.textColor = COLOR_RGB(91, 98, 105);
    lastSelectLabel = titleLabelsArray[index];
    lastSelectLabel.textColor = COLOR_RGB(250, 223, 84);
    float persent = (self.maximumValue - self.minimumValue)/(titleLabelsArray.count - 1);
    [self setValue:(index * persent) animated:NO];
}



@end
