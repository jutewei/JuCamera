//
//  JuBaseView.h
//  MTSkinPublic
//
//  Created by Juvid on 2018/7/9.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JuBaseView : UIView{
    
}
-(void)juSubViews;
-(void)juSetContent:(id)content;
@end


@interface JuBaseNibView : UIControl

-(void)juSubViews;

-(void)juSetContent:(id)content;

@end
