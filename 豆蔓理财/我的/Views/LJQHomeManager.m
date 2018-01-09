//
//  LJQHomeManager.m
//  豆蔓理财
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQHomeManager.h"

@implementation LJQHomeManager

+ (instancetype)shareHomeManager {
   static LJQHomeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LJQHomeManager alloc] init];
    });
    return manager;
}

@end
