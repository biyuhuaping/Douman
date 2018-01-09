//
//  DMCreditTransferView.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMCreditTransferModel.h"



@interface DMCreditTransferView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) DMCreditTransferModel *transferModel;



@property (nonatomic, copy) void(^TransferAction)();

@property (nonatomic, copy) void(^ProtocolAction)();


@end
