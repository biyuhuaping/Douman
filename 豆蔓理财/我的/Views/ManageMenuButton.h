//
//  ManageMenuButton.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/2.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManageMenuButtonDelegate <NSObject>

- (void)selectButtonWithIndex:(NSInteger)index;

@end

@interface ManageMenuButton : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<ManageMenuButtonDelegate>delegate;

/**
 设置选中那个button
 */
- (void)setSelectButtonWithIndex:(NSInteger)index;

@end
