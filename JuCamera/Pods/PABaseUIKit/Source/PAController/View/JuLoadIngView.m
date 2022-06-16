//
//  JuLoadIngView.m
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuLoadIngView.h"
#import "JuLayoutFrame.h"
@interface JuLoadIngView (){
    UIActivityIndicatorView *_ju_actStatus;
    UILabel *ju_labStatus;
    UIButton *ju_btnRefresh;
}

@end


@implementation JuLoadIngView
-(id)initWithView:(UIView *)supView{
    self=[super init];
    if (self) {
        [supView addSubview:self];
//        self.juOrigin(CGPointMake(0, 0));
        self.juCenterY.equal(-30);
        self.juCenterX.equal(0);
        self.juSize(CGSizeMake(0, 200));
       
        _ju_actStatus=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _ju_actStatus.hidesWhenStopped=YES;
        [self addSubview:_ju_actStatus];
//        _ju_actStatus.juFrame(CGRectMake(0, 0, 40, 40));
        _ju_actStatus.juOrigin(CGPointMake(0, 0));
//        _ju_actStatus.juCenterY.equal(0);
        
        ju_btnRefresh =[UIButton buttonWithType:UIButtonTypeSystem];
        ju_btnRefresh.userInteractionEnabled=NO;
        [ju_btnRefresh setImage:[UIImage imageNamed:@"net_refresh"] forState:UIControlStateNormal];
        ju_btnRefresh.tintColor=[UIColor lightGrayColor];
        [self addSubview:ju_btnRefresh];
        ju_btnRefresh.juFrame(CGRectMake(0, 0, 25, 25));
        
        ju_labStatus=[[UILabel alloc]init];
        ju_labStatus.font=[UIFont systemFontOfSize:14];
        ju_labStatus.textColor=[UIColor lightGrayColor];
        [self addSubview:ju_labStatus];
        ju_labStatus.juCenterX.equal(0);
        ju_labStatus.juCenterY.equal(28);
        self.ju_loadingType=JuLoadingIng;
    }
    return self;
}

-(void)setJu_loadingType:(JuLoadingType)ju_loadingType{
    _ju_loadingType=ju_loadingType;
    self.hidden=NO;
    ju_btnRefresh.hidden=YES;
    if (_ju_loadingType==JuLoadingIng) {
        ju_labStatus.text=@"加载中...";
        [_ju_actStatus startAnimating];
    }else if (_ju_loadingType==JuLoadingSuccess){
        self.hidden=YES;
        [_ju_actStatus stopAnimating];
    }else{
        self.hidden=YES;
        [_ju_actStatus stopAnimating];
//        ju_btnRefresh.hidden=NO;
//        ju_labStatus.text=@"加载失败，点击重试！";
//        if (_ju_loadingType==JuLoadingError) {
//            ju_labStatus.text=@"加载出错，请稍后重试！";
//        }
//        [_ju_actStatus stopAnimating];
    }
     self.userInteractionEnabled=!ju_btnRefresh.hidden;
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_ju_loadingType==JuLoadingFailure) {
        if (self.ju_rereshHandle) {
            self.ju_loadingType=JuLoadingIng;
            self.ju_rereshHandle();
        }
    }
}
/**兼容老版本*/

-(void)shWhiteStatus{
    ju_labStatus.textColor=PAColor_White;
    _ju_actStatus.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    ju_btnRefresh.tintColor=PAColor_White;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
