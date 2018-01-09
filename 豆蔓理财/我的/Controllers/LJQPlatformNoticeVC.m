//
//  LJQPlatformNoticeVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQPlatformNoticeVC.h"

//#import "AZT_PDFReader.h"
@interface LJQPlatformNoticeVC ()

{
    NSURLSessionDownloadTask *downLoadTask;
}

@property (nonatomic, copy)NSString *pathlujing;

@end

@implementation LJQPlatformNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"平台公告";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(30, 20, 150, 13) labelColor:UIColorFromRGB(0x71757e) textAlignment:(NSTextAlignmentLeft) textFont:13.f];
    label.text = @"尊敬的用户，您好！";
   // [self.view addSubview:label];
    
    NSArray *array = @[@"为了能够给您提供更安全优质的服务，财路通平台将于11月20日21时-11月21日6时进行系统升级。在此期间，平台部分功能和页面将无法正常操作或者无内容显示。",@"1.系统升级期间，用户无法登录，摇钱树及团购将暂停认购、充值、提现等服务，11月21日6时起恢复正常；",@"2.个人账户中的优惠券将于11月20日后失效，并统一清空，请在系统升级前完成使用；",@"3.11月17日-18日百宝箱暂停2天，11月21日恢复正常。",@"因此给您带来的不便我们深表歉意。",@"再次感谢您对财路通长期以来的支持与理解！"];
    UIView *view1 = [self CreateBottomView:18 + LJQ_VIEW_MaxY(label) contentArr:array];
 //   [self.view addSubview:view1];
    
//    NSArray *array1 = @[@"  因此给您带来的不便我们深表歉意。",@"  再次感谢您对财路通长期以来的支持与理解！"];
//    UIView *view2 = [self CreateBottomView:30 + LJQ_VIEW_MaxY(view1) contentArr:array1];
//    [self.view addSubview:view2];
    
    CGFloat width = [self labelWIDTH];
    UILabel *label1 = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - 30 - width, LJQ_VIEW_MaxY(view1) + 46, width, 13) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
    label1.text = @"财路通";
    UILabel *label2 = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - 30 - width, LJQ_VIEW_MaxY(label1) + 10, width, 13) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
    label2.text = @"2016.11.24";
    
  //  [self.view addSubview:label1];
  //  [self.view addSubview:label2];
}

- (UIView *)CreateBottomView:(CGFloat)height contentArr:(NSArray *)array{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, height, SCREENWIDTH, 400)];
    view.backgroundColor = UIColorFromRGB(0xffffff);

    CGFloat maxy = 0;
    for (int i = 0; i < array.count; i++) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentLeft;;
        if (i == 0 | i == 4 | i == 5) {
            paragraph.firstLineHeadIndent = 20.f;
        }
        paragraph.paragraphSpacingBefore = 10.0;
        paragraph.lineSpacing = 10;
        paragraph.hyphenationFactor = 1.0;
        NSString *string = [NSString stringWithFormat:@"%@",array[i]];
        NSDictionary *dic = @{NSParagraphStyleAttributeName:paragraph};
        NSAttributedString *attriute = [[NSAttributedString alloc] initWithString:string attributes:dic];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH - 60, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f],NSParagraphStyleAttributeName:paragraph} context:nil];
        
        UILabel *label1 = [UILabel createLabelFrame:CGRectMake(30, maxy, SCREENWIDTH - 60, rect.size.height) labelColor:UIColorFromRGB(0xb4b4b4) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        label1.numberOfLines = 0;
        label1.attributedText = attriute;
        [view addSubview:label1];
        
        if (i == 3) {
            maxy = rect.size.height + maxy;
        }if(i == 4){
            maxy = rect.size.height + maxy;
        }else {
            maxy = rect.size.height + maxy + 10 ;
        }
    }
    [view setFrame:CGRectMake(0, height, SCREENWIDTH, maxy)];
    return view;
}
- (NSAttributedString *)setupstring:(NSString *)string index:(BOOL)index{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentJustified;
    if (index) {
         paragraph.firstLineHeadIndent = 20.f;
    }
    paragraph.paragraphSpacingBefore = 10.0;
    paragraph.lineSpacing = 5;
    paragraph.hyphenationFactor = 1.0;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paragraph};
    NSAttributedString *attriute = [[NSAttributedString alloc] initWithString:string attributes:dic];
    return attriute;
}

- (CGFloat)labelWIDTH {
    CGRect rect = [@"2036.30.30" boundingRectWithSize:CGSizeMake(200, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} context:nil];
    return rect.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    [downLoadTask resume];
}

//下载PDF文件
- (void)downLoadPDF:(NSString *)urlString {
    
    //File Url
    NSString* fileUrl = urlString;
    //创建 Request
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    
    //下载进行中的事件
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度---%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *string = [NSString stringWithFormat:@"%@.pdf",response.suggestedFilename];
        
        NSString *path = [cachesPath stringByAppendingPathComponent:string];
        
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        
        NSString *imgFilePath = [filePath path];
        self.pathlujing = imgFilePath;
        //设置签章验证的颜色
      //  [[AZT_PDFReader getInstance] setShowSignatureViewMainColor:[UIColor whiteColor]];
        //打开阅读器
      //  [[AZT_PDFReader getInstance] openPDFWithViewCtr:self PDFPath:self.pathlujing ViewCtrTitle:@"豆蔓协议"];


        
    }];
}

@end
