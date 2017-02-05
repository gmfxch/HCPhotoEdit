# HCPhotoEdit
简易的图片处理框架。采用GPUImage实现，包含滤镜，特效，虚化，裁剪，旋转，光影，边框，色彩参数调整功能

### 效果展示
<img src="http://ofstcegl2.bkt.clouddn.com/Screen%20Shot%202017-02-05%20at%20%E4%B8%8A%E5%8D%8810.32.28.png" width = "250" height = "444" alt="图片名称" align=center />
<img src="http://ofstcegl2.bkt.clouddn.com/Screen%20Shot%202017-02-05%20at%20%E4%B8%8A%E5%8D%8811.32.45.png" width = "250" height = "444" alt="图片名称" align=center />
<img src="http://ofstcegl2.bkt.clouddn.com/Screen%20Shot%202017-02-05%20at%20%E4%B8%8A%E5%8D%8810.33.13.png" width = "250" height = "444" alt="图片名称" align=center />
<img src="http://ofstcegl2.bkt.clouddn.com/Screen%20Shot%202017-02-05%20at%20%E4%B8%8A%E5%8D%8810.33.26.png" width = "250" height = "444" alt="图片名称" align=center />
<img src="http://ofstcegl2.bkt.clouddn.com/Screen%20Shot%202017-02-05%20at%20%E4%B8%8A%E5%8D%8810.33.37.png" width = "250" height = "444" alt="图片名称" align=center />
<img src="http://ofstcegl2.bkt.clouddn.com/Screen%20Shot%202017-02-05%20at%20%E4%B8%8A%E5%8D%8810.34.15.png" width = "250" height = "444" alt="图片名称" align=center />

### 使用示例
导入头文件 #import "HCPhotoEditViewController.h"
```objc
    HCPhotoEditViewController *editController = [[HCPhotoEditViewController alloc] init];
    editController.oriImage = imageView.image;
    editController.delegate = self;
    [self presentViewController:editController animated:YES completion:nil];
    
```
实现代理HCPhotoEditViewControllerDelegate
```objc
/**
 点击“完成”按钮回调函数
 */
-(void)didClickFinishButtonWithEditController:(HCPhotoEditViewController*)controller  newImage:(UIImage*)newImage;
/**
 点击“取消”按钮回调函数
 */
-(void)didClickCancelButtonWithEditController:(HCPhotoEditViewController*)controller;
    
```

    