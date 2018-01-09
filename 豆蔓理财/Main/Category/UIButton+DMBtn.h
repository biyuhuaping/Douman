//
//  UIButton+DMBtn.h
//  豆蔓分解
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DMBtn)

+ (UIButton *)createBtnType:(UIButtonType)type BtnFrame:(CGRect)frame BtnTittle:(NSString *)tittle state:(UIControlState)state;

@end
