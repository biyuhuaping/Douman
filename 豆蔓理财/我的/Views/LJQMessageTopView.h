//
//  LJQMessageTopView.h
//  豆蔓分解页面
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^editEvent)(UIButton *sender);

typedef void(^selectedEventBlock)(UIButton *btn);

@interface LJQMessageTopView : UIView

@property (nonatomic, copy)selectedEventBlock block;
@property (nonatomic, copy)editEvent editBlock;
@property (nonatomic, strong)UIButton *selectedBtn;

- (instancetype)initWithFrame:(CGRect)frame selectedColor:(UIColor *)selectedColor;

@end
