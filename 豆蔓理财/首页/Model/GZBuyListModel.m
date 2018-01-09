//
//  GZBuyListModel.m
//  豆蔓理财
//
//  Created by armada on 2016/12/21.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZBuyListModel.h"

@implementation GZBuyListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"investAmount":@[@"amount",@"investAmount"]};
}



@end
