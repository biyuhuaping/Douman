//
//  LJQUpDown.h
//  LJQUpDownDemo
//
//  Created by mac on 2016/11/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickOnBlock)(NSInteger index,NSString *string);
@interface LJQUpDown : UIView

@property (nonatomic, copy)NSString *animationFlag; //区分下拉／回收
@property (nonatomic, copy)clickOnBlock ClickOnblock;

- (instancetype)showDropDown:(UIButton *)button Height:(CGFloat)height rowHeight:(NSInteger)rowHeight NameArr:(NSArray *)nameArr ImageArr:(NSArray *)imageArr AnimatonFlag:(NSString *)flag;

- (void)hiddenActionBtn:(UIButton *)sender;

@end
