//
//  SHDoublePopView.h
//  SHBaseProject
//
//  Created by Juvid on 16/5/17.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPopView.h"
#import "NSAttributedString+style.h"
#import "JuStringsManager.h"

@interface JuImgDiaglogView : JuPopView{
    UIView *ju_vieLast;
    UILabel  *ju_labContent;
    UIImageView *ju_imageView;
    UILabel  *ju_labTitel;
}

-(void)juDiaglogWithKey:(nullable NSString *)keyName
                message:(id _Nullable )messae
                 handle:(JuCallHandle _Nonnull )handle;

-(void)juDiaglogTitle:(nullable NSString *)title
                 message:(nullable id)message
               handle:(JuCallHandle _Nullable )handle;

-(void)juDiaglogTitle:(nullable NSString *)title
              message:(nullable id)messae
                items:(nullable NSArray *)arrButton
               handle:(JuCallHandle _Nullable )handle;

-(void)juDiaglogImage:(nullable NSString *)imageName
              message:(nullable id)messae
                items:(nullable NSArray *)arrButton
               handle:(JuCallHandle _Nullable )handle;

@end
