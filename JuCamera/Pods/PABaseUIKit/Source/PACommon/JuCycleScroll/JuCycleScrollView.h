//
//  JuCycleScrollView.h
//  JuCycleScroll
//
//  Created by Juvid on 2018/10/25.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JuPageViewControl.h"
@protocol JuCycleScrollViewDelegate;
@interface JuCycleScrollView : UIView<UIScrollViewDelegate>{
    UIScrollView *ju_scrollView;
    JuPageViewControl *ju_page;
    NSMutableArray *ju_arrList;
    int ju_currentNum,ju_totalNum;
    NSTimer *ju_timer;
    NSTimeInterval ju_animation;
}
@property (assign,nonatomic) CGFloat Scale;

-(void)juSetScrollItem:(NSArray*)arrItem;

-(void)juStartTimer;

-(void)juSetScrollView;
/**
 *  @author Juvid, 16-05-10 16:05
 *
 *  设置轮播图是否滚动
 *
 */
- (void)juSetTimer:(BOOL)animated;

-(void)setCurrentNum:(int)num;

- (void)juDealloc;

//设置数据
-(UIImageView *)juSetImageData:(id)imageObject;

@property (nonatomic ,assign)JUPageAlignment juPageAlignment;

@property (nonatomic ,weak) IBOutlet id<JuCycleScrollViewDelegate> juDelegate;

@end

@protocol JuCycleScrollViewDelegate <NSObject>

-(void)juTouchImageIndex:(id)indexs;

@end
