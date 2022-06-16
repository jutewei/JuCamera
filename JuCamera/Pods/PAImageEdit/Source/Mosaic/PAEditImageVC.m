//
//  JuImageRotatingView.m
//  图片旋转
//
//  Created by Juvid on 2020/12/22.
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/29.
//

#import "PAEditImageVC.h"
#import "JuLayoutFrame.h"
#import "UIImage+category.h"
#import "PAMosaicZoomScroll.h"
#import "PAEditConfig.h"

@interface PAEditImageVC ()
@property (nonatomic,copy) JuImageResult ju_handle;
@property (nonatomic,strong)UIButton *ju_backBtn;
@property (nonatomic,strong)UIButton *ju_resetBtn;
@end

@implementation PAEditImageVC{
    UIImage *ju_imageData;
    PAMosaicZoomScroll *ju_mosaicView;
}

-(instancetype)initWithImage:(UIImage *)image
                      handle:(JuImageResult)handle{
    self=[super init];
    if (self) {
        self.modalPresentationStyle=UIModalPresentationFullScreen;
        self.ju_handle=handle;
        ju_imageData=image;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    [self juMosaicView];
    [self juBackItem];
}

-(void)juBackItem{
    _ju_backBtn=[[UIButton alloc]init];
    [_ju_backBtn addTarget:self action:@selector(juTouchBack) forControlEvents:UIControlEventTouchUpInside];
    [_ju_backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_ju_backBtn setImage:PAEditImage(@"back") forState:UIControlStateNormal];
    [self.view addSubview:_ju_backBtn];
    _ju_backBtn.juSafeFrame(CGRectMake(24, 15, 40, 30));
    
    _ju_resetBtn=[[UIButton alloc]init];
    [_ju_resetBtn addTarget:self action:@selector(juTouchReset) forControlEvents:UIControlEventTouchUpInside];
    _ju_resetBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    _ju_resetBtn.backgroundColor=MosaicMainColor;
    [_ju_resetBtn.layer setCornerRadius:2];
    [_ju_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.view addSubview:_ju_resetBtn];
    _ju_resetBtn.juSafeFrame(CGRectMake(-24, 16, 48, 28));
    
}

-(void)juTouchReset{
    [ju_mosaicView.mosaicView juReset];
}

-(void)juMosaicView{
    __weak typeof(self) weakSelf =self;
   ju_mosaicView=[[PAMosaicZoomScroll alloc]initWithImage:ju_imageData handle:^(UIImage * _Nullable result) {
        if (weakSelf.ju_handle) {
            weakSelf.ju_handle(result);
        }
       [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    ju_mosaicView.statusHandle = ^(BOOL  isStart) {
        weakSelf.ju_backBtn.hidden=isStart;
        weakSelf.ju_resetBtn.hidden=isStart;
    };
    [self.view addSubview:ju_mosaicView];
    ju_mosaicView.juEdge(UIEdgeInsetsZero);
}

-(void)juTouchBack{
    if (self.handleBack) {
        self.handleBack();
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)juRotaingView{
//    PARotatingView *view=[[PARotatingView alloc]initWithImage:ju_imageData handle:^(UIImage * _Nullable result) {
//
//    }];
//    [self.view addSubview:view];
   
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
