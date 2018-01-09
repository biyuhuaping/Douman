//
//  LJQDebtManageView.h
//  豆蔓理财
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^selectedEventBlock)(UIButton *btn);
@interface LJQDebtManageView : UIView

@property (nonatomic, copy)selectedEventBlock block;

@property (nonatomic, strong)UIButton *selectedBtn;

- (instancetype)initWithFrame:(CGRect)frame selectedColor:(UIColor *)selectedColor;

@end
