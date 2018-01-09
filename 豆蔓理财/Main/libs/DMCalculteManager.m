//
//  DMCalculteManager.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/9/18.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMCalculteManager.h"

@implementation DMCalculteManager


+ (instancetype)manager{
    static DMCalculteManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DMCalculteManager alloc] init];
    });
    return manager;
}


- (NSString *)calculatePorfitWithAmount:(NSString *)amount Rate:(NSString *)rate Type:(ProfitType)type Month:(NSString *)month{
    double amount_f = [amount doubleValue];
    CGFloat month_f = [month floatValue];
    CGFloat rate_f = [rate doubleValue];
    CGFloat yuejiebenxi = 0.0;
    CGFloat yujishouyi = 0.0;
    
    if (amount_f == 0 || rate_f == 0) {
        return @"0.00";
    }
    
    if (type == kEqualAmountInterest){
        CGFloat monthRate = rate_f / 100 / 12;
        yuejiebenxi = (amount_f * (monthRate * pow(1 + monthRate, month_f))/(pow((1 + monthRate), month_f) - 1));
        yujishouyi = (month_f * yuejiebenxi - amount_f);
    }
    if (type == kPayInterestByMonth){
        yujishouyi = amount_f * rate_f/100/12 * month_f;
    }
    return [NSString stringWithFormat:@"%.2f",yujishouyi];
}



@end
