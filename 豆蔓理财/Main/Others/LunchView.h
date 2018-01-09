//
//  LunchView.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/1/15.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StartBlock)();

@interface LunchView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, copy) StartBlock start;

@end
