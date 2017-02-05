//
//  FWLordKelvinFilter.h
//  FWMeituApp
//
//  Created by hzkmn on 16/1/8.
//  Copyright © 2016年 ForrestWoo co,.ltd. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "GPUImageThreeInputFilter.h"
#import "GPUImageFourInputFilter.h"
#import "GPUImageTwoInputFilter.h"
#import "GPUImage.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface FWFilter2 : GPUImageTwoInputFilter

@end

@interface FWLordKelvinFilter : GPUImageFilterGroup
{
    GPUImagePicture *imageSource;
}

@end
