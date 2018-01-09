//
//  LJQHomeManager.h
//  豆蔓理财
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJQHomeManager : NSObject

@property (nonatomic, assign)NSInteger isOpen;

+ (instancetype)shareHomeManager;

@end
