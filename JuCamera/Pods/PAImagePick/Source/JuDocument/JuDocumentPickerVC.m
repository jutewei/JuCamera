//
//  JUDocumentPickerVC.m
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/5/19.
//

#import "JuDocumentPickerVC.h"

@interface JuDocumentPickerVC ()<UIDocumentPickerDelegate>
@property(nonatomic,copy)JuDocumentHandle ju_handle;
@property(nonatomic,assign)BOOL ju_isPdf;

@end

@implementation JuDocumentPickerVC

+(instancetype)initDocumentPickHandle:(JuDocumentHandle)handle{
    JuDocumentPickerVC *vc=[self initDocumentPickWithType:@[@"com.adobe.pdf"] handle:handle];
    vc.ju_isPdf=YES;
    return vc;
}

+(instancetype)initDocumentPickWithType:(NSArray *)types
                                 handle:(JuDocumentHandle)handle{
    JuDocumentPickerVC *vc=[[JuDocumentPickerVC alloc]initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
    vc.modalPresentationStyle=UIModalPresentationFullScreen;
    vc.ju_handle = handle;
    return vc;
}

+(instancetype)initDocumentPickWtihVC:(UIViewController *)vc
                               handle:(JuDocumentHandle)handle{
    JuDocumentPickerVC *pickVc=[self initDocumentPickHandle:handle];
    [vc presentViewController:pickVc animated:YES completion:nil];
    return pickVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls{
    
    if (urls.count) {
        [self documentPicker:controller didPickDocumentAtURL:urls.firstObject];
    }
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller{
    if (self.ju_cancel) {
        self.ju_cancel();
    }
    NSLog(@"取消了");
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url{
    //获取授权
    BOOL fileUrlAuthozied = [url startAccessingSecurityScopedResource];
    if(fileUrlAuthozied) {
        NSFileCoordinator*fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError*error;
        [fileCoordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL * _Nonnull newURL) {
            //读取文件
            NSString *fileName = [newURL lastPathComponent];
            NSLog(@"%@",fileName);
            if(self.ju_handle&&newURL) {
                if (_ju_isPdf) {
                    NSError *error =nil;
                    NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
                    self.ju_handle(fileData);
                }else{///返回拓展名
                    self.ju_handle(newURL.absoluteString);
                }
            }
            [url stopAccessingSecurityScopedResource];
        }];
    }
    
}
+(NSArray *)fileTypes{
    return @[
    @"public.data",
    @"com.microsoft.powerpoint.ppt",
    @"com.microsoft.word.doc",
    @"com.microsoft.excel.xls",
    @"com.microsoft.powerpoint.pptx",
    @"com.microsoft.word.docx",
    @"com.microsoft.excel.xlsx",
    @"public.avi",
    @"public.3gpp",
    @"public.mpeg-4",
    @"com.compuserve.gif",
    @"public.jpeg",
    @"public.png",
    @"public.plain-text",
    @"com.adobe.pdf",
    @"com.microsoft.word.doc",
    @"public.image",
    @"public.mp3"
    ];
}
/**
 NSString *base64String=[fileData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
 NSMutableDictionary *dic=[NSMutableDictionary dictionary];
 [dic setValue:newURL.absoluteString forKey:@"uri"];
 [dic setValue:base64String forKey:@"base64"];*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation JuPreShareDocumentVC{
    UIDocumentInteractionController *pdfPicker;
    __weak UIViewController *ju_parentVC;
}

+(instancetype)juInitWithUrl:(NSURL *)url withView:(UIViewController *)parentVc{
//        NSURL *url=[[NSBundle mainBundle] URLForResource:@"test4" withExtension:@"jpeg"];
    JuPreShareDocumentVC *vc=[[JuPreShareDocumentVC alloc]init];
    [vc juSetPickVC:url withView:parentVc];
    return vc;
}

-(void)juSetPickVC:(NSURL *)url withView:(UIViewController *)vc{
    ju_parentVC=vc;
    pdfPicker = [UIDocumentInteractionController interactionControllerWithURL:url];
    pdfPicker.delegate = self; // ensure you set the delegate so when a PDF is chosen the right method can be called
    [pdfPicker presentOptionsMenuFromRect:ju_parentVC.view.bounds inView:ju_parentVC.view animated:YES];
}

@end
/**
 https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html#//apple_ref/doc/uid/TP40009259
 public.content 全部
 NSArray*types =@[
 @"public.data",
 @"com.microsoft.powerpoint.ppt",
 @"com.microsoft.word.doc",
 @"com.microsoft.excel.xls",
 @"com.microsoft.powerpoint.pptx",
 @"com.microsoft.word.docx",
 @"com.microsoft.excel.xlsx",
 @"public.avi",
 @"public.3gpp",
 @"public.mpeg-4",
 @"com.compuserve.gif",
 @"public.jpeg",
 @"public.png",
 @"public.plain-text",
 @"com.adobe.pdf"
 ];
 @[
 @"com.microsoft.word.doc",
 @"public.mpeg-4",
 @"com.adobe.pdf",
 @"public.image",
 @"public.mp3"];
 */