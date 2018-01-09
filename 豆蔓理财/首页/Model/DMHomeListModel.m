//
//  DMHomeListModel.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/27.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMHomeListModel.h"

@implementation DMHomeListModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"noviceTask"]) {
        self.noviceTask = nil;
    }
}

@end
