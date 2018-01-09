//
//  AutomicTransferView.h
//  豆蔓理财
//
//  Created by mac on 2017/5/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^jumpToAutoMicTranster)();

typedef void(^jumpToAgreementBlock)();
@interface AutomicTransferView : UIView

@property (nonatomic, copy)jumpToAutoMicTranster autoMicTransfer;
@property (nonatomic, copy)jumpToAgreementBlock jumpToAgreement;

- (void)showView;
- (void)dismissFromView;

@end

typedef void(^closeViewViewBlock)();

typedef void(^confirmJumpToWeiShang)();
typedef void(^agreementBlock)();
@interface ItemTwoView : UIView

@property (nonatomic, copy)closeViewViewBlock closeViewBlock;

@property (nonatomic, copy)confirmJumpToWeiShang JumpToWeiShang;

@property (nonatomic, copy)agreementBlock agreement;

@end
