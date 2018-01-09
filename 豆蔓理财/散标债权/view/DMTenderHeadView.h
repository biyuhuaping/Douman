//
//  DMTenderHeadView.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMScafferListModel;

@interface DMTenderHeadView : UIView

@property (nonatomic, copy) void(^SelectButton)(NSInteger index);

@property (nonatomic, strong) DMScafferListModel *listModel;


@end
