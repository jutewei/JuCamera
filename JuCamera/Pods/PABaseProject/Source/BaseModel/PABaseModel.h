//
//  BaseModel.h
//  JsonModel
//
//  Created by Juvid on 14-6-30.
//  Copyright (c) 2015年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "JuBaseEncode.h"
#import "NSArray+Safe.h"
#import "NSObject+JsonModel.h"
@interface PABaseModel : JuBaseEncode

-(NSMutableDictionary *)zlToDictionary;

-(NSArray *)zlRemoveKey;

@end



