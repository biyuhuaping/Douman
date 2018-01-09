//
//  HUDManager.h
//  财路通理财
//
//  Created by wujianqiang on 2016/11/8.
//  Copyright © 2016年 wangguomin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDManager : NSObject

+ (instancetype)manager;

- (void)showHUDWithView:(UIView *)view;

- (void)hide;

- (void)showHudWithText:(NSString *)text;

@end
