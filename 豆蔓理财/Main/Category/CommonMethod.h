//
//  CommonMethod.h
//  豆蔓理财
//
//  Created by bluesky on 2017/8/24.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonMethod : NSObject

+ (instancetype)methodCall;

//文字中插入图片
- (NSMutableAttributedString *)returenAttribute:(NSString *)string imageName:(NSString *)imageName imageBounds:(CGRect)imageBounds index:(NSInteger)index;

//颜色转换图片
- (UIImage*)createImageWithColor:(UIColor*)color frame:(CGRect)frame;

//计算文本宽高
- (CGFloat)returenLabelHeight:(NSString *)string size:(CGSize)size fontsize:(NSInteger)font isWidth:(BOOL)isWidth;

//小数点生成
- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money;
@end
