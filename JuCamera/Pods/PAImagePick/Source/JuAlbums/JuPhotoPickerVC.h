//
//  JuPhotoCollectionVController.h
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "JuPhotoDelegate.h"
#import "JuPhotoNavigationVC.h"
#import "JuPhotoConfig.h"

//#import "PABaseVC.h"
//typedef void(^JuHandleMultiResult)(id first,id second);//下步操作后有有多个数据

@interface JuPhotoPickerVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

-(instancetype)initWitDelegate:(id<JuPhotoDelegate>)delegate
                  maxSelectNum:(NSInteger)maxNum;

+(instancetype)initWitDelegate:(id<JuPhotoDelegate>)delegate
                  maxSelectNum:(NSInteger)maxNum;

@property (nonatomic, assign) NSUInteger ju_maxNumSelection;

@property (nonatomic, assign) JuPhotoAlbumType ju_mediaType;

@property (nonatomic,assign)BOOL ju_hideOImg;

@property (nonatomic, strong)  PHAssetCollection *ju_PhotoGroup;
@end
