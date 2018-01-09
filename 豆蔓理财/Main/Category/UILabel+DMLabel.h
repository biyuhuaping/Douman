//
//  UILabel+DMLabel.h
//  豆蔓分解
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DMAttributeTapActionDelegate <NSObject>

- (void)DM_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index;

@end

@interface DMAttributeModel : NSObject

@property (nonatomic, copy)NSString *str;
@property (nonatomic, assign)NSRange range;

@end


@interface UILabel (DMLabel)

@property (nonatomic, assign)BOOL enabledTapEffect;

@property (nonatomic, retain)NSMutableArray *attributeSrings;

//label 字段的点击事件

/*
strings : label中点击事件的字段
 string : 点中的字段
 range : 字段在文本中的范围
 index : 字段在事件队列中的位置
 */
- (void)DM_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                 tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick;

- (void)DM_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                   delegate:(id <DMAttributeTapActionDelegate> )delegate;


+ (UILabel *)createLabelFrame:(CGRect)frame labelColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment textFont:(CGFloat)font;

- (void)AttributeString:(NSString *)string DIC:(NSDictionary *)dic range:(NSRange)range;

@end
