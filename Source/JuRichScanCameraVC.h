//
//  JuRichScanCameraVC.h
//  JuCamera
//
//  Created by Juvid on 2017/10/20.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuCameraviewController.h"

typedef void(^__nullable JuScanHandle)(id _Nullable result);             //

@interface JuRichScanCameraVC : JuCameraviewController{
   
}
@property (nonatomic,copy) JuScanHandle ju_handle;
@end
