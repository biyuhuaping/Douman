//
//  DMScafferBuyModel.m
//  豆蔓理财
//
//  Created by edz on 2017/7/6.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMScafferBuyModel.h"
#import "DMScafferBuySubModel.h"
@implementation DMScafferBuyModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"annualCards":[DMScafferBuySubModel class]};
}

@end
