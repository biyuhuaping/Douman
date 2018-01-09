//
//  GZInvestSignReminderView.h
//  豆蔓理财
//
//  Created by armada on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GZInvestSignSkipDelegate <NSObject>

- (void)skipToDetailOfInvestSign;

- (void)skipToAutoSignAuthProtocol;

@end

@interface GZInvestSignReminderView : UIView

+ (void)showPopviewToView:(UIView *)view;

+ (void)hidePopview;

+ (void)setDelegateOfSingletonWith:(id<GZInvestSignSkipDelegate>)delegate;

@end
