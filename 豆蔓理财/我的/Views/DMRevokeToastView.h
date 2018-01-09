//
//  DMRevokeToastView.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMRevokeToastView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)show;


@property (nonatomic, copy) void(^RevokeAction)();


@end
