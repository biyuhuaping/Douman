//
//  LJQTextFieldAndImage.h
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TextFieldMode) {
    TextFieldModeNone,
    TextFieldModeLogin,
    TextFieldModeTrade
};


typedef void(^compareString)(UITextField *textField);
@interface LJQTextFieldAndImage : UIView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName space:(CGFloat)spaceX Height:(CGFloat)height string:(NSString *)string;
@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, copy)compareString comStrBK;

@property (nonatomic)TextFieldMode keyMode;

@end
