//
//  LJQBaseViewVC.h
//  豆蔓理财
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJQBaseViewVC : UIViewController

- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money;

- (NSString *)returnDecimalString:(NSString *)string;


/**
 文字插入图片

 @param string 文字
 @param imageName 图片名称
 @param imageBounds 图片占位大小
 @param index 图片插入位置
 @return 图文
 */
- (NSMutableAttributedString *)returenAttribute:(NSString *)string imageName:(NSString *)imageName imageBounds:(CGRect)imageBounds index:(NSInteger)index;

@end
