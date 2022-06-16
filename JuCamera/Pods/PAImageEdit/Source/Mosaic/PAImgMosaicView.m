//
//  JuImgMosaicView.m
//  JuPhoto
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/29.
//

#import "PAImgMosaicView.h"
#import "UIImage+category.h"
#import "JuLayoutFrame.h"


@interface PAImgMosaicView()

//展示马赛克图片的涂层
@property (nonatomic, strong) CALayer *mosaicImageLayer;

//遮罩层，用于设置形状路径
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

//手指涂抹的路径
@property (nonatomic, assign) CGMutablePathRef path;


@end

@implementation PAImgMosaicView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化马赛克图层
        self.mosaicImageLayer = [CALayer layer];
        self.mosaicImageLayer.frame  = self.bounds;
        [self.layer addSublayer:self.mosaicImageLayer];
        _scale=1;
        _pixelWidth=20;
        //初始化遮罩图层
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
        shapeLayer.fillColor = nil;
        //设置当前的马赛克图层的遮罩层
        self.mosaicImageLayer.mask = shapeLayer;
    }
    return self;
}

-(void)setPixelWidth:(CGFloat)pixelWidth{
    _pixelWidth=pixelWidth;
    [self setNextStep];
}

-(void)setScale:(CGFloat)scale{
    _scale=scale;
}

-(void)setNextStep{
    if (self.path) {
        CGPathRelease(self.path);
        self.path=nil;
    }
    self.path = CGPathCreateMutable();
    //初始化遮罩图层
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineWidth = _pixelWidth/_scale;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
    self.shapeLayer.fillColor = nil;
    //设置当前的马赛克图层的遮罩层
    [self.mosaicImageLayer.mask addSublayer:self.shapeLayer];
}

- (void)setOriginalImage:(UIImage *)originalImage{
    _originalImage  = originalImage;//原始图片
    self.image = originalImage;//顶层视图展示原始图片
    if ([originalImage isKindOfClass:[UIImage class]]) {
        self.mosaicImage=[originalImage juMosaicLevel:50];
    }
}

- (void)setMosaicImage:(UIImage *)mosaicImage{
    _mosaicImage = mosaicImage;//马赛克图片
    self.mosaicImageLayer.contents = (__bridge id _Nullable)([mosaicImage CGImage]);//将马赛克图层内容设置为马赛克图片内容
}

//上一步操作
-(void)juLastStep{
    if (self.mosaicImageLayer.mask.sublayers.count) {
        CALayer *layer=self.mosaicImageLayer.mask.sublayers.lastObject;
        [layer removeFromSuperlayer];
    }
}

//重置
-(void)juReset{
    while (self.mosaicImageLayer.mask.sublayers.lastObject) {
        [self.mosaicImageLayer.mask.sublayers.lastObject removeFromSuperlayer];
    }
}

-(UIImage *)juGetResultImage{
    if (self.mosaicImageLayer.mask.sublayers.count==0) {
        return self.originalImage;
    }
    CGRect frame=self.layer.bounds;
    CGFloat scale=self.image.size.width/frame.size.width;
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *deadledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return deadledImage;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (event.allTouches.count>1) {///大于一个手指不涂抹
        return;
    }
    if (self.statusHandle) {
        self.statusHandle(YES);
    }
    [self setNextStep];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
    self.shapeLayer.path = self.path;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (!self.path) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
    self.shapeLayer.path = self.path;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (self.statusHandle) {
        self.statusHandle(NO);
    }
    if (self.path) {
        CGPathRelease(self.path);
        self.path=nil;
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    if (self.statusHandle) {
        self.statusHandle(NO);
    }
}

- (void)dealloc{
    if (self.path) {
        CGPathRelease(self.path);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
