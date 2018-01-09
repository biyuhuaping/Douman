//
//  CLTShareView.h
//  财路通理财
//
//  Created by wujianqiang on 2017/1/6.
//  Copyright © 2017年 wangguomin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTShareView : UIView

- (void)show;

- (void)hide;

@property (nonatomic, copy) void(^wechatBlock)(NSInteger index);


@end
