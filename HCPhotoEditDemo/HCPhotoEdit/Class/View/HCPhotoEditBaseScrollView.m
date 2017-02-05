//
//  HCPhotoEditBaseScrollView.m
//  GPUImageDemo
//
//  Created by chenhao on 16/12/6.
//  Copyright © 2016年 chenhao. All rights reserved.
//  

#import "HCPhotoEditBaseScrollView.h"
#import "HCPhotoEditViewController.h"
#import "HCPhotoEditCustomButton.h"

@implementation HCPhotoEditBaseScrollView
{
    HCPhotoEditCustomButton *lastSelectedBtn;
}

-(instancetype)initWithFrame:(CGRect)frame  bottomTitle:(NSString*)title  imagesArray:(NSArray*)images  titlesArray:(NSArray*)titles buttonWidth:(float)width  imageSize:(float)size
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = COLOR_RGB(35, 35, 35);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 45, self.bounds.size.width, 45)];
        view.backgroundColor = COLOR_RGB(20, 20, 20);
        [self addSubview:view];
        self.bottomView = view;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        cancelBtn.frame = CGRectMake(0, 0, view.bounds.size.height + 20, view.bounds.size.height);
        [cancelBtn setImage:IMAGE_WITHNAME(@"photo_bottom_bar_cancel") forState:UIControlStateNormal];
        [cancelBtn setImage:IMAGE_WITHNAME(@"photo_bottom_bar_cancel_light") forState:UIControlStateNormal];
        cancelBtn.tintColor = [UIColor whiteColor];
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancelBtn];
        
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        finishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        finishBtn.frame = CGRectMake(self.bounds.size.width - view.bounds.size.height - 20, 0, view.bounds.size.height + 20, view.bounds.size.height);
        [finishBtn setImage:IMAGE_WITHNAME(@"photo_bottom_bar_ok") forState:UIControlStateNormal];
        [finishBtn setImage:IMAGE_WITHNAME(@"photo_bottom_bar_ok_light") forState:UIControlStateNormal];
        finishBtn.tintColor = [UIColor whiteColor];
        [finishBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:finishBtn];
        
        
        UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.bounds.size.width/2 - 50, 0, 100, view.bounds.size.height)];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [view addSubview:titleLabel];
        
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 45)];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (int index = 0; index < images.count; index++)
            {
                HCPhotoEditCustomButton *btn = [[HCPhotoEditCustomButton alloc] initWithImage:images[index] highlightedImage:images[index] title:titles[index] font:12 imageSize:size];
                btn.tag = index + 10;
                [btn setImage:images[index] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake(index * width, 0, width - 1, scrollView.bounds.size.height);
                [scrollView addSubview:btn];
                scrollView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), 0);
                btn.alpha = 0;
                [UIView animateWithDuration:0.2 delay:0.05*index options:UIViewAnimationOptionCurveEaseOut animations:^{
                    btn.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        });
        
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame  bottomTitle:(NSString*)title  imagesNameArray:(NSArray*)images  titlesArray:(NSArray*)titles buttonWidth:(float)width  imageSize:(float)size

{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = COLOR_RGB(35, 35, 35);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 45, self.bounds.size.width, 45)];
        view.backgroundColor = COLOR_RGB(20, 20, 20);
        [self addSubview:view];
        self.bottomView = view;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        cancelBtn.frame = CGRectMake(0, 0, view.bounds.size.height + 20, view.bounds.size.height);
        [cancelBtn setImage:IMAGE_WITHNAME(@"photo_bottom_bar_cancel") forState:UIControlStateNormal];
        [cancelBtn setImage:IMAGE_WITHNAME(@"photo_bottom_bar_cancel_light") forState:UIControlStateNormal];
        cancelBtn.tintColor = [UIColor whiteColor];
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancelBtn];
        
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        finishBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        finishBtn.frame = CGRectMake(self.bounds.size.width - view.bounds.size.height - 20, 0, view.bounds.size.height + 20, view.bounds.size.height);
        [finishBtn setImage:IMAGE_WITHNAME(@"photo_bottom_bar_ok") forState:UIControlStateNormal];
        [finishBtn setImage:IMAGE_WITHNAME(@"photo_bottom_bar_ok_light") forState:UIControlStateNormal];
        finishBtn.tintColor = [UIColor whiteColor];
        [finishBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:finishBtn];
        
        
        UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.bounds.size.width/2 - 50, 0, 100, view.bounds.size.height)];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [view addSubview:titleLabel];
        
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 45)];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (int index = 0; index < images.count; index++)
            {
                NSString *name = images[index];
                NSString *name2 = [name stringByAppendingString:@"_h"];
//                NSString *title = (index < titles.count) ? titles[index]: nil;
                UIImage *hightImage = IMAGE_WITHNAME(name2);
                if (!hightImage) {
                    hightImage = IMAGE_WITHNAME([name stringByAppendingString:@"_Light"]);
                }
                HCPhotoEditCustomButton *btn = [[HCPhotoEditCustomButton alloc] initWithImage:IMAGE_WITHNAME(name) highlightedImage:hightImage title:titles[index] font:12 imageSize:size];
                btn.tag = index + 10;
                [btn setImage:hightImage forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake(index * width, 0, width - 1, scrollView.bounds.size.height);
                [scrollView addSubview:btn];
                scrollView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), 0);
                btn.alpha = 0;
                [UIView animateWithDuration:0.2 delay:0.05*index options:UIViewAnimationOptionCurveEaseOut animations:^{
                    btn.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        });
      
    }
    return self;
}

-(void)cancel
{
    if ([self.delegate respondsToSelector:@selector(cancelEdit)]) {
        [self.delegate cancelEdit];
    }
}

-(void)ok
{
    if ([self.delegate respondsToSelector:@selector(okEdit)]) {
        [self.delegate okEdit];
    }
}

-(void)buttonClick:(HCPhotoEditCustomButton*)btn
{
    if (!self.ignoreButtonSelect) {
        if (btn != lastSelectedBtn && lastSelectedBtn) {
            lastSelectedBtn.normalState = YES;
        }
        lastSelectedBtn.selected = NO;
        lastSelectedBtn = btn;
        lastSelectedBtn.selected = YES;
    }

    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
        [self.delegate didClickButtonAtIndex:btn.tag - 10];
    }
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:button:)]) {
        [self.delegate didClickButtonAtIndex:btn.tag - 10 button:btn];
    }
}

@end
