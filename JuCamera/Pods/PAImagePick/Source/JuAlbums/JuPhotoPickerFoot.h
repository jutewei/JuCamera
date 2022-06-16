//
//  JuPhotoCollectionFoot.h
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuPhotoConfig.h"
@interface JuPhotoPickerFoot : UICollectionReusableView

@property (nonatomic,strong)NSString *ju_strText;

@end


@interface JuPhotoPickerTitleView : UIControl

+(instancetype)initWithHandle:(dispatch_block_t)handle;

-(void)setText:(NSString *)text;

@end

@interface JuPhotoPickerToolBar : UIView

+(instancetype)initWithHandle:(JuHandleIndex)handle;

@property (nonatomic,copy)JuHandleIndex ju_handle;

@property (nonatomic,assign)BOOL ju_hideOImg;

@property (nonatomic,assign)BOOL ju_hidePreView;


-(void)juSetCount:(NSInteger)count;

-(void)juSetOriginal:(BOOL)isOrginal;

@end
