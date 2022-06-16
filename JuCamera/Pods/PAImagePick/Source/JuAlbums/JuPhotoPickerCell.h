//
//  JuPhotoCollectionVCell.h
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
@interface JuPhotoPickerCell : UICollectionViewCell
@property (nonatomic,assign) NSInteger ju_allowVideo;
//单选
//@property (nonatomic,assign) NSInteger ju_singleSelect;
@property (nonatomic,strong) PHAsset *ju_asset;
@property (nonatomic,copy) JuAssetHandle ju_assetHandle;
@end
