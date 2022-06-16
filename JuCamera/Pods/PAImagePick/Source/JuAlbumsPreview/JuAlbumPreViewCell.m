//
//  JuAlbumPreViewCell.m
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/7/19.
//

#import "JuAlbumPreViewCell.h"
#import "JuScaleAlbumItem.h"
#import "JuLayoutFrame.h"

@implementation JuAlbumPreViewCell{
    JuScaleAlbumItem *ju_scaleView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ju_scaleView=[[JuScaleAlbumItem alloc]init];
        [self.contentView addSubview:ju_scaleView];
        ju_scaleView.juEdge(UIEdgeInsetsMake(0, 0, 0, 20));
        [self.contentView layoutIfNeeded];
    }
    return self;
}

-(void)setJu_tapHandle:(dispatch_block_t)ju_tapHandle{
    ju_scaleView.ju_tapHandle=ju_tapHandle;
}

-(void)juSetImage:(id)imageData {
    [ju_scaleView setItemData:imageData];
}

-(void)juSetFullImage{
    [ju_scaleView juSetFullImage];
}

@end
