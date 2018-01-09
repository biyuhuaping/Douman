//
//  AZT_PDFReader.h
//  AZT_PDFReader
//
//  Created by huangbing on 2017/1/10.
//  Copyright © 2017年 北京安证通信息科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AZT_PDFReader : NSObject

/** 获取实例 */
+ (AZT_PDFReader *)getInstance;

/**
 功能:    打开PDF文件
 返回值:  无
 参数说明:
 ParentViewCtr: 父视图UIViewController
 PDFPath:       PDF文档路径
 ViewCtrTitle:  PDF预览界面自定义标题
 */
- (void)openPDFWithViewCtr: (UIViewController*)ParentViewCtr PDFPath: (NSString *)PDFPath ViewCtrTitle:(NSString *)ViewCtrTitle;


/**
 功能:          设置签章验证view颜色和滑动条颜色;
 返回值:         无
 参数说明:
 cusColor:      自定义颜色
 */
- (void)setShowSignatureViewMainColor:(UIColor *) cusColor;

@end
