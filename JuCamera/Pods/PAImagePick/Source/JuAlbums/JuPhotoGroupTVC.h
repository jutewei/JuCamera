//
//  JuPhotoGroupViewController.h
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuPhotoDelegate.h"
#import "JuPhotoConfig.h"
//#import "PABaseVC.h"
@interface JuPhotoGroupTVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

+(id)initWithDelegate:(id<JuPhotoDelegate>)delegate;

+(id)initWithDelegate:(id<JuPhotoDelegate>)delegate maxSelectNum:(NSInteger)maxNum;

+(id)initWithHandle:(JuAlbumHandle)handle;

@property (nonatomic, assign) NSUInteger ju_maxNumSelection;

@property (nonatomic, assign) BOOL ju_onlyVideo;

/*下拉时使用*/
-(void)juShowVC:(UIViewController *)vc;

@end
