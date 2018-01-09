//
//  DMMyServerHeaderView.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMMyServerModel;
@interface DMMyServerHeaderView : UIView


@property (nonatomic, copy) void(^SelectButton)(NSInteger index);
@property (nonatomic, strong) DMMyServerModel *serverModel;

@end
