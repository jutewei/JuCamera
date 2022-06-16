//
//  JuBaseData.h
//  PABase
//
//  Created by Juvid on 2021/4/20.
//

#import <Foundation/Foundation.h>
#import "PABaseModel.h"
#import "UIScrollView+JuRefresh.h"
#import "PAPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JuBaseDataVM  : NSObject


@property (nonatomic,strong) id  zl_data;   ///< 对象数据

@property (nonatomic,strong) NSMutableArray *zl_mArrList;   ///< 列表数据

@property (nonatomic,strong) PAPageModel  *zl_pageSize;   ///< 对象数据

+(instancetype)zlInitWithContentView:(UIScrollView *)contentView;


-(void)zlSetBaseDadas;

//分页处理
-(void)setArrList:(NSMutableArray *)mArrList isPage:(BOOL)isPage;

-(void)zlReloadData;

-(void)zlReloadData:(UIScrollView *)scrollView;

-(NSInteger)sections;

-(NSInteger)sectionRows:(NSInteger)section;

-(id)sectionRowData:(NSIndexPath *)indexPath;

-(id)sectionData:(NSInteger)section;

-(BOOL)isNoData;

@end




NS_ASSUME_NONNULL_END
