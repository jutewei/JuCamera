//
//  PABaseContentTVC.m
//  PABase
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/3.
//

#import "PABaseContentTVC.h"

@interface PABaseContentTVC ()

@end

@implementation PABaseContentTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setIsTextEidt];
    // Do any additional setup after loading the view.
}
//文本编辑
-(void)setIsTextEidt{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gestureRecognizer.delegate=self;
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.zl_tableView addGestureRecognizer:gestureRecognizer];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}


-(void)zlSetPostV:(NSString *)postVale showV:(NSString *)showVale{
    [self zlSetModel:self.vModel.zl_currentM postV:postVale showV:showVale];
}

-(void)zlSetModel:(PARequestModel *)model postV:(NSString *)postVale showV:(NSString *)showVale{
    if (![model.zl_postVaule isEqual:postVale]) {
        [model setPostValue:postVale showValue:showVale];
        [zl_tableView reloadData];
    }
}

#pragma mark 隐藏键盘
- (void) hideKeyboard:(UIGestureRecognizer *)sender{
    [self.view endEditing:YES];
}
- (void) hideKeyboard {
    [self hideKeyboard:nil];
}
-(Class)zlVMDataClass{
    return JuBaseContentVM.class;
}
-(JuBaseContentVM *)vModel{
    return (JuBaseContentVM *)self.zl_baseVMData;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
