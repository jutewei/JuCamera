//
//  JuStringsManager.h
//  PABase
//
//  Created by Juvid on 2019/7/4.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define JUStringsInstance       [JuStringsManager sharedInstance]
#define MTWarnWord(value)       (NSString *)JUStringsInstance.ju_markWord[value]
#define MTDiagLogWord(value)    JUStringsInstance.juDiagLogWords[value]
#define MTDTitleWord(value)     JUStringsInstance.juTitleWords[value]
#define MTSEXTITLE(value)       [JUStringsInstance juSexTitle:value]
#define MTEventKey(value)       (JuStringsManager.juEventKeys[value])
@interface JuStringsManager : NSObject

+ (instancetype) sharedInstance;

@property (nonatomic,weak)NSDictionary *ju_markWord;///< 提示语

-(NSDictionary *)juDiagLogWords;

-(NSDictionary *)juTitleWords;

-(NSString *)juSexTitle:(NSInteger)gender;

+(NSDictionary *)juEventKeys;

@end

NS_ASSUME_NONNULL_END
