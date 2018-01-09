//
//  CommonMethod.m
//  豆蔓理财
//
//  Created by bluesky on 2017/8/24.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "CommonMethod.h"

@implementation CommonMethod

+ (instancetype)methodCall {
    static CommonMethod *method = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method = [[self alloc] init];
    });
    return method;
}

//创建图片附件
- (NSAttributedString *)pitcureStringName:(NSString *)imageName imageBounds:(CGRect)imageBounds{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:imageName];
    attach.bounds = imageBounds;
    NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    return attachStr;
}

- (NSMutableAttributedString *)returenAttribute:(NSString *)string imageName:(NSString *)imageName imageBounds:(CGRect)imageBounds index:(NSInteger)index{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute insertAttributedString:[self pitcureStringName:imageName imageBounds:imageBounds] atIndex:index];
    
    return attribute;
}

//颜色转换图片
- (UIImage*)createImageWithColor:(UIColor*)color frame:(CGRect)frame {
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//计算文字宽高
- (CGFloat)returenLabelHeight:(NSString *)string size:(CGSize)size fontsize:(NSInteger)font isWidth:(BOOL)isWidth{
    
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:FONT_Regular(font)} context:nil];
    if (isWidth == YES) {
        return rect.size.width;
    }else {
        return rect.size.height;
    }
}

//生成小数点
- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    //小数显示的最大和最小位数
    formatter.maximumFractionDigits = 2;
    formatter.minimumFractionDigits = 2;
    
    return [formatter stringFromNumber:money];
}
@end
