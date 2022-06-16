//
//  JuPhotoCollectionFoot.m
//  JuPhotoBrowser
//
//  Created by Juvid on 16/9/21.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "JuPhotoPickerFoot.h"
#import "JuLayoutFrame.h"
#import "JuPhotoConfig.h"
@interface JuPhotoPickerFoot (){
    UILabel *ju_textLabel;
}

@end

@implementation JuPhotoPickerFoot
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        // Create a label
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:17];
        textLabel.textColor = Photo_TitleColor;
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textLabel];
        textLabel.juCenterY.equal(0);
        textLabel.juCenterX.equal(0);
        ju_textLabel = textLabel;
    }

    return self;
}
-(void)setJu_strText:(NSString *)ju_strText{
    _ju_strText=ju_strText;
    ju_textLabel.text=ju_strText;
}

@end


@interface JuPhotoPickerTitleView()
@property(nonatomic,copy)dispatch_block_t touchHandle;
@end
@implementation JuPhotoPickerTitleView{
    UILabel *ju_labTitle;
    UIImageView *ju_imgIcon;
}

+(instancetype)initWithHandle:(dispatch_block_t)handle{
    JuPhotoPickerTitleView *vie=[[JuPhotoPickerTitleView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    vie.touchHandle=handle;
    return vie;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        ju_labTitle=[[UILabel alloc]init];
        ju_labTitle.text=@"最近项目";
        ju_labTitle.textColor=Photo_TitleColor;
        ju_labTitle.font=[UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        [self addSubview:ju_labTitle];
        ju_labTitle.juOrigin(CGPointMake(0, 0));
        ju_labTitle.ju_CenterX.constant=-8;
        
        ju_imgIcon=[[UIImageView alloc]init];
        ju_imgIcon.image=juPhotoImage(@"photo_selectDown");
        [self addSubview:ju_imgIcon];
        ju_imgIcon.juLeaSpace.toView(ju_labTitle).equal(10);
        ju_imgIcon.juCenterY.equal(0);
//        ju_imgIcon.juSize(CGSizeMake(8, 8));
        [self addTarget:self action:@selector(juTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setText:(NSString *)text{
    ju_labTitle.text=text;
}

-(void)juTouch:(id)sender{
    if (self.touchHandle) {
        self.touchHandle();
    }
}

-(CGSize)intrinsicContentSize{
    return CGSizeMake(200, 44);
}

@end


@implementation JuPhotoPickerToolBar{
    UIButton *ju_previewItem,*ju_doneItem,*ju_oBtnItem;
}

+(instancetype)initWithHandle:(JuHandleIndex)handle{
    JuPhotoPickerToolBar *bar=[[JuPhotoPickerToolBar alloc]init];
    bar.ju_handle=handle;
    return bar;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        self.backgroundColor= Photo_BackColor;
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=self.backgroundColor;
        [self addSubview:view];
        view.juLead.equal(0);
        view.juTopSpace.equal(0);
        view.juSize(CGSizeMake(0, 50));
        [self setBaseView];
    }
    return self;
}

-(void)setBaseView{
    
    ju_previewItem = [self juInitBtn:1];
    [ju_previewItem setTitle: @"预览" forState: UIControlStateNormal];
    [ju_previewItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addSubview:ju_previewItem];
    ju_previewItem.juFrame(CGRectMake(12, 0, 40, 40));
    
    ju_oBtnItem = [self juInitBtn:2];
    [ju_oBtnItem setImage:juPhotoImage(@"photo_originalUn") forState:UIControlStateNormal];
    [ju_oBtnItem setImage:juPhotoImage(@"photo_original") forState:UIControlStateSelected];
    [ju_oBtnItem setTitle:@"  原图" forState: UIControlStateNormal];
    [self addSubview:ju_oBtnItem];
    ju_oBtnItem.juOrigin(CGPointMake(0, 0));

    ju_doneItem = [self juInitBtn:3];
    ju_doneItem.backgroundColor=Photo_btnColor;
    [ju_doneItem setTitle: @"完成" forState: UIControlStateNormal];
    [ju_doneItem.layer setCornerRadius:2];
    [ju_doneItem.layer setMasksToBounds:YES];
    [self addSubview:ju_doneItem];
    ju_doneItem.juFrame(CGRectMake(-12, 0, 85, 30));
    [self juSetCount:0];
}

-(void)juTouch:(UIButton *)sender{
    if (self.ju_handle) {
        self.ju_handle(sender.tag);
    }
}

-(void)juSetCount:(NSInteger)count{
    [ju_doneItem setTitle:[NSString stringWithFormat:@"完成(%zi)",count] forState: UIControlStateNormal];
    ju_doneItem.enabled=ju_previewItem.enabled=count;
    if (ju_doneItem.enabled) {
        ju_doneItem.alpha=1;
        ju_previewItem.alpha=1;
    }else{
        ju_doneItem.alpha=0.5;
        ju_previewItem.alpha=0.5;
    }
}

-(void)setJu_hideOImg:(BOOL)ju_hideOImg{
    ju_oBtnItem.hidden=ju_hideOImg;
}

-(void)setJu_hidePreView:(BOOL)ju_hidePreView{
    ju_previewItem.hidden=ju_hidePreView;
}

-(void)juSetOriginal:(BOOL)isOrginal{
    ju_oBtnItem.selected=isOrginal;
}

-(UIButton *)juInitBtn:(NSInteger)tag{
    UIButton  *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    [btn addTarget:self action:@selector(juTouch:) forControlEvents:UIControlEventTouchUpInside];

    btn.tag=tag;
    btn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [btn setTitleColor:Photo_TitleColor forState:UIControlStateNormal];
    return btn;
}
@end
