//
//  DMCalaulateView.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/2/16.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMCalaulateView : UIView

- (instancetype)initWithInvestAmount:(NSString *)amount
                                Type:(NSString *)type
                                Rate:(NSString *)rate
                               Month:(int)month;


@end
