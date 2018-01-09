//
//  DMNewHandView.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/6/15.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMNewHandView : UIView

@property (nonatomic, copy) void(^registerBlock)();

@property (nonatomic, copy) void(^detailBlock)();


@property (nonatomic, copy) void(^closeBlock)();

@end
