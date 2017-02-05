//
//  HCPhotoEditCustomButton.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//

#import "HCPhotoEditCustomButton.h"
#import "HCPhotoEditViewController.h"


@implementation HCPhotoEditCustomButton
{
    UIImage  *_image;
    UIImage  *_hightImage;
    NSString *_title;
    float    _imageSize;
}


-(instancetype)initWithImage:(UIImage*)image  highlightedImage:(UIImage*)hightImage title:(NSString*)title  font:(float)font imageSize:(float)size
{
    self = [super init];
    if (self) {
        _imageSize = size;
        if (_imageSize == 0) {
            _imageSize = image.size.width;
        }
        _hightImage = hightImage;
        _image = image;
        _title = title;
        _normalState = YES;
        
        [self setBackgroundColor:COLOR_RGB(25, 25, 25)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:COLOR_RGB(250, 223, 84) forState:UIControlStateHighlighted];
        [self setTitleColor:COLOR_RGB(250, 223, 84) forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        if (hightImage) {
            [self setImage:hightImage forState:UIControlStateHighlighted];
            [self setImage:hightImage forState:UIControlStateSelected];
        }
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [self imageRectForContentRect:contentRect];
    CGRect  titleFrame = CGRectMake(0, CGRectGetMaxY(frame) + 12, contentRect.size.width, 20);
    if (CGRectGetMaxY(titleFrame) + 5 >= contentRect.size.height) {
        titleFrame.origin.y -= 5;
    }
    
    return titleFrame;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    float size = _imageSize;
    float x = contentRect.size.width/2.0 - size/2.0;
    float y = contentRect.size.height * 0.55 - size;
    if (!_title) {
        y = contentRect.size.height / 2.0 - size/2.0;
    }
    y = y <= 10 ? 10 : y;
    return CGRectMake(x, y, size, size);
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        [self setBackgroundColor:COLOR_RGB(0, 0, 0)];
        if (_hightImage) {
            [self setImage:_hightImage forState:UIControlStateNormal];
        }
        
        [self setTitleColor:COLOR_RGB(250, 223, 84) forState:UIControlStateNormal];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.selected) {
                return ;
            }
            [self setBackgroundColor:COLOR_RGB(25, 25, 25)];
            [self setImage:_image forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        });
    }
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:COLOR_RGB(0, 0, 0)];
//        _normalState = NO;
    }else{
        [self setBackgroundColor:COLOR_RGB(25, 25, 25)];
        [self setImage:_image forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _normalState = YES;
    }
}

@end
