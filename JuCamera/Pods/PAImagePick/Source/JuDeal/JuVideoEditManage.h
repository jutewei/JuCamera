//
//  JuVideoEditManage.h
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/4/11.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JuVideoEditManage : NSObject

+ (instancetype _Nullable ) sharedInstance;

-(void)juCompressionWithPath:(NSString *)path
                      preset:(NSString*)presetName
                      handle:(void (^)(BOOL success,NSString *result))handle;

-(void)juCompressionWithAsset:(AVAsset *)asset
                       preset:(NSString*)presetName
                       handle:(void (^)(BOOL success,NSString *result))handle;

@end

NS_ASSUME_NONNULL_END
