//
//  LJQSystemMessageModel.h
//  豆蔓理财
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJQSystemMessageModel : NSObject

@property (nonatomic, copy)NSString *content;//内容
@property (nonatomic, copy)NSString *title;// 标题
@property (nonatomic, copy)NSString *status;//状态
@property (nonatomic, copy)NSString *sendTime;//发送时间
@property (nonatomic, copy)NSString *messageId;//消息ID

@end
