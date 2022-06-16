//
//  NibLoad.m
//  YunHK
//
//  Created by Juvid on 14/12/30.
//  Copyright (c) 2014年 Juvid(zhutianwei). All rights reserved.
//

#import "JuNibLoad.h"

@implementation JuNibLoad

+(UIView*)loadNib:(NSString *)nibName{
    return [JuNibLoad loadNib:nibName bundle:nil];
}

+(UIView*)loadNib:(NSString*)nibName bundle:bundle{
    JuNibLoad *loader=[[JuNibLoad alloc] init];
    UINib *nib=[UINib nibWithNibName:nibName bundle:bundle];
    [nib instantiateWithOwner:loader options:nil];
    return loader.leNibview;
}


@end
