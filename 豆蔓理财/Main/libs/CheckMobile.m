//
//  CheckMobile.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/24.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "CheckMobile.h"

@implementation CheckMobile

+ (instancetype)manager{
    static CheckMobile *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CheckMobile alloc] init];
    });
    return manager;
}

//判断手机的合法性
- (BOOL)checkMobileNumber:(NSString *)checkStr{
    NSString * MOBILE = @"^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (([regextestmobile evaluateWithObject:checkStr] == YES)){
        return YES;
    }
    return NO;
}


@end
