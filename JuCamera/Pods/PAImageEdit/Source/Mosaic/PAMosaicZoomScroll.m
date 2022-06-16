//
//  PAMosaicZoomScroll.m
//  PAImageEdit
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/9.
//

#import "PAMosaicZoomScroll.h"
#import "JuLayoutFrame.h"
#import "PAEditConfig.h"

@interface PAMosaicZoomScroll()

@property (nonatomic,copy) JuImageResult ju_handle;

@end

@implementation PAMosaicZoomScroll{
    PAMosaicSizeButton *ju_currentSize;
    UIView *ju_viewSize;
    UIView *ju_anctonview;
    
}

-(instancetype)initWithImage:(UIImage *)image
                      handle:(JuImageResult)handle{
    self=[super init];
    if (self) {
        self.ju_handle = handle;
        [self setImage:image];
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    [super setImage:image];
    [self setMosaicContent];
    self.mosaicView.originalImage=image;
}

-(void)setMosaicContent{
    __weak typeof(self) weakSelf = self;
    PAImgMosaicView *view=[[PAImgMosaicView alloc]initWithFrame:ju_originRect];
    view.statusHandle = ^(BOOL  isStart) {
        if (weakSelf.statusHandle) {
            weakSelf.statusHandle(isStart);
        }
        [weakSelf setIsHiddeEdit:isStart];
    };
    [ju_scrollView addSubview:view];
    self.ju_zoomView=view;
    self.isEdit=NO;
    [self juSetActionView];
}

-(void)juSetActionView{
    
    CGFloat sizeW=Window_Width*0.4;

    ju_anctonview=[[UIView alloc]init];
    [self addSubview:ju_anctonview];
    ju_anctonview.juSafeFrame(CGRectMake(0, -24, 0, 28));
    
    CGFloat itemSpace=(sizeW-96)/2;
    UIButton *btnFinish=[[UIButton alloc]init];
    [btnFinish setTitle:@"完成" forState:UIControlStateNormal];
    [btnFinish setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btnFinish.titleLabel.font=[UIFont systemFontOfSize:12];
    btnFinish.backgroundColor=MosaicMainColor;
    [btnFinish.layer setCornerRadius:2];
    [btnFinish addTarget:self action:@selector(juTouchFinish) forControlEvents:UIControlEventTouchUpInside];
    [ju_anctonview addSubview:btnFinish];
    btnFinish.juFrame(CGRectMake(-itemSpace, 0, 48, 28));
    
    
    UIButton *btnMosaic=[[UIButton alloc]init];
    [btnMosaic setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btnMosaic setImage:[UIImage imageNamed:PAEditImageBundle(@"mosaic_icon")] forState:UIControlStateNormal];
    [btnMosaic setImage:[UIImage imageNamed:PAEditImageBundle(@"mosaic_iconSelected")] forState:UIControlStateSelected];
    [btnMosaic addTarget:self action:@selector(juTouchMosaic:) forControlEvents:UIControlEventTouchUpInside];
    [ju_anctonview addSubview:btnMosaic];
    btnMosaic.juFrame(CGRectMake(-(2*itemSpace+48), 0, 48, 28));
    sizeW=Window_Width*0.6;
//    画笔大小
    ju_viewSize=[[UIView alloc]init];
    [ju_anctonview addSubview:ju_viewSize];
    ju_viewSize.juFrame(CGRectMake(0.01, 0, sizeW, 0));
    itemSpace=(sizeW-48)/4+8;
    NSArray *arrSize=@[@(12),@(16),@(20)];
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor colorWithWhite:1 alpha:0.27];
    [ju_viewSize addSubview:line];
    line.juFrame(CGRectMake(-.01, 0, 1, 19));
    
    for (int i=0; i<3; i++) {
        CGFloat size=[arrSize[i] intValue];
        PAMosaicSizeButton *btn =[[PAMosaicSizeButton alloc]init];
        btn.tag=i;
        [btn addTarget:self action:@selector(juTouchSize:) forControlEvents:UIControlEventTouchUpInside];
        [ju_viewSize addSubview:btn];
        [btn setRadius:size];
        if (i==2) {
            [self juTouchMosaic:btn];
        }
        btn.juFrame(CGRectMake(itemSpace+itemSpace*i, 0, size, size));
    }
    ju_viewSize.hidden=YES;
    [self juTouchMosaic:btnMosaic];
}

-(void)juTouchSize:(PAMosaicSizeButton *)sender{
    if ([ju_currentSize isEqual:sender]) {
        return;
    }
    
    ju_currentSize.selected=NO;
    [ju_currentSize setIsSelect];

    sender.selected=YES;
    [sender setIsSelect];
    
    self.mosaicView.pixelWidth=CGRectGetWidth(sender.frame)+4;
    
    ju_currentSize=sender;

}
-(void)juTouchAction:(UIButton *)sender{
    if (sender.tag==0) {
        [self.mosaicView juLastStep];
    }else if(sender.tag==1){
        [self.mosaicView juReset];
    }else if(sender.tag==2){
        if (self.ju_handle) {
            self.ju_handle([self.mosaicView juGetResultImage]);
        }
    }
}

-(void)juTouchMosaic:(UIButton *)sender{
    sender.selected=!sender.selected;
    self.isEdit=sender.selected;
    ju_viewSize.hidden=!sender.selected;
}

-(void)juTouchFinish{
    if (self.ju_handle) {
        self.ju_handle([self.mosaicView juGetResultImage]);
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    [super scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    self.mosaicView.scale=scale;
}

-(PAImgMosaicView *)mosaicView{
    return (PAImgMosaicView *)self.ju_zoomView;
}

-(void)setIsEdit:(BOOL)isEdit{
    [super setIsEdit:isEdit];
    self.mosaicView.userInteractionEnabled=isEdit;
}
-(void)setIsHiddeEdit:(BOOL)isHide{
    ju_anctonview.hidden=isHide;
}
@end



@implementation PAMosaicSizeButton{
    UIView *insideView;
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view=[super hitTest:point withEvent:event];
    if (view==nil) {
        if (point.x>-14&&point.x<(14+CGRectGetWidth(self.frame))&&point.y>-14&&point.y<(14+CGRectGetHeight(self.frame))) {
            return self;
        }
        
    }
    return view;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self setStytleView];
    }
    return self;
}
-(void)setRadius:(CGFloat)radius{
    if (radius<16) {
        [self.layer setCornerRadius:3];
        [insideView.layer setCornerRadius:1];
    }else{
        [self.layer setCornerRadius:4];
        [insideView.layer setCornerRadius:2];
    }
  
}
-(void)setStytleView{
    
    self.backgroundColor=UIColor.clearColor;
    [self.layer setCornerRadius:3];
    [self.layer setBorderWidth:1];
    [self.layer setBorderColor:UIColor.whiteColor.CGColor];
    
    insideView =[[UIView alloc]init];
    insideView.userInteractionEnabled=NO;
    insideView.backgroundColor=UIColor.whiteColor;
    [insideView.layer setCornerRadius:1];
    [self addSubview:insideView];
    insideView.juEdge(UIEdgeInsetsMake(3, 3, 3, 3));
}

-(void)setIsSelect{
    if (self.selected) {
        [self.layer setBorderColor:MosaicMainColor.CGColor];
        insideView.backgroundColor=MosaicMainColor;
    }else{
        [self.layer setBorderColor:UIColor.whiteColor.CGColor];
        insideView.backgroundColor=UIColor.whiteColor;
    }
}

@end
