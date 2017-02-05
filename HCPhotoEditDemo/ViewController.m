//
//  ViewController.m
//  HCPhotoEditDemo
//
//  Created by chenhao on 17/2/4.
//  Copyright © 2017年 chenhao. All rights reserved.
//

#import "ViewController.h"
#import "HCPhotoEditViewController.h"


@interface ViewController ()<HCPhotoEditViewControllerDelegate>

@end

@implementation ViewController
{
    UIImageView  *_currentEditImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)imageView1Click:(UITapGestureRecognizer *)sender
{
    [self beginEdit:(UIImageView*)sender.view];
}

- (IBAction)imageView2Click:(UITapGestureRecognizer *)sender
{
    [self beginEdit:(UIImageView*)sender.view];
}

- (IBAction)imageView3Click:(UITapGestureRecognizer *)sender
{
    [self beginEdit:(UIImageView*)sender.view];
}

-(void)beginEdit:(UIImageView*)imageView
{
    _currentEditImageView = imageView;
    HCPhotoEditViewController *editController = [[HCPhotoEditViewController alloc] init];
    editController.oriImage = imageView.image;
    editController.delegate = self;
    [self presentViewController:editController animated:YES completion:nil];
}


#pragma mark HCPhotoEditViewControllerDelegate

-(void)didClickFinishButtonWithEditController:(HCPhotoEditViewController *)controller newImage:(UIImage *)newImage
{
    _currentEditImageView.image = newImage;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)didClickCancelButtonWithEditController:(HCPhotoEditViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
