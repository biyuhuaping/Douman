//
//  MenuButton.h
//  titleViewTest
//
//  Created by wujianqiang on 16/9/26.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuButtonDelegate <NSObject>

- (void)selectButtonWithIndex:(NSInteger)index;

@end

@interface MenuButton : UIView

- (instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArray SelectColor:(UIColor *)selectColor UnselectColor:(UIColor *)unselectcolor;

@property (nonatomic, weak) id<MenuButtonDelegate>delegate;


/**
 设置选中那个button
 */
- (void)setSelectButtonWithIndex:(NSInteger)index;

@end
