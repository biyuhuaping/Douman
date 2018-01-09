//
//  OpenAccountStatusView.h
//  豆蔓理财
//
//  Created by mac on 2017/6/5.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^jumpToAutoMicTranster)();

typedef void(^jumpToAgreementBlock)();
@interface OpenAccountStatusView : UIView

@property (nonatomic, copy)jumpToAutoMicTranster autoMicTransfer;
@property (nonatomic, copy)jumpToAgreementBlock jumpToAgreement;

- (instancetype)initWithIsOpenAccount:(NSInteger)openAccount;
- (void)showView;
- (void)dismissFromView;

@end


typedef void(^closeViewViewBlock)();

typedef void(^confirmJumpToWeiShang)();
typedef void(^agreementBlock)();
@interface ItemThreeView : UIView

@property (nonatomic, copy)closeViewViewBlock closeViewBlock;

@property (nonatomic, copy)confirmJumpToWeiShang JumpToWeiShang;

- (instancetype)initWithFrame:(CGRect)frame isOpenAccount:(NSInteger)openAccount;

@property (nonatomic, copy)agreementBlock agreement;

@end
