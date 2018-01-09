//
//  LJQTransactionView.h
//  豆蔓分解页面
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonSelectedBlock)(NSInteger index);

typedef void(^leftTimeBlock)(NSString *string);
typedef void(^rightTimeBlock)(NSString *string);

@interface LJQTransactionView : UIView

@property (nonatomic, copy)buttonSelectedBlock buttonSelectedBK;
@property (nonatomic, copy)leftTimeBlock leftTime;
@property (nonatomic, copy)rightTimeBlock rightTime;

- (void)dismiss;

@end
