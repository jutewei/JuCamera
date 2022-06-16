//
//  JuPhotoDelegate.h
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/22.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JuPhotoDelegate <NSObject>

- (void)juPhotosDidFinishController:(UIViewController *)pickerController didSelectAssets:(NSArray *)arrList;///< 预览

- (void)juPhotosDidCancelController:(UIViewController *)pickerController;///< 取消

@optional
- (void)juDidReceiveMemoryWarning;///< 内存警告

@end
