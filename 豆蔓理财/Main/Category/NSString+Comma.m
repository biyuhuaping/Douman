//
//  NSString+Comma.m
//  豆蔓理财
//
//  Created by wujianqiang on 2016/12/26.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "NSString+Comma.h"

@implementation NSString (Comma)

+ (NSString *)removeCommaWithString:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    return str;
}

+ (NSString *)insertCommaWithString:(NSString *)str{
    NSString *intStr;
    NSString *floStr;
    if ([str containsString:@"."]) {
        NSRange range = [str rangeOfString:@"."];
        floStr = [str substringFromIndex:range.location];
        intStr = [str substringToIndex:range.location];
    }else{
        floStr = @"";
        intStr = str;
    }
    if (intStr.length <= 3) {
        return [intStr stringByAppendingString:floStr];
    }else{
        NSInteger length = intStr.length;
        NSInteger count = length/3;
        NSInteger y = length%3;
        
        NSString *tit = [intStr substringToIndex:y] ;
        NSMutableString *det = [[intStr substringFromIndex:y] mutableCopy];
        
        for (int i = 0; i < count; i ++) {
            NSInteger index = i + i * 3;
            [det insertString:@"," atIndex:index];
        }
        if (y == 0) {
            det = [[det substringFromIndex:1] mutableCopy];
        }
        intStr = [tit stringByAppendingString:det];
        return [intStr stringByAppendingString:floStr];
    }
}
@end
