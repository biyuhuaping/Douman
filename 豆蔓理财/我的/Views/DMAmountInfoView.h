//
//  DMAmountInfoView.h
//  豆蔓理财
//
//  Created by edz on 2017/6/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^confirmEventBlock)(NSInteger number);

@interface DMAmountInfoView : UIView

@property (nonatomic, copy)confirmEventBlock jumpToAgreement;

- (void)showView;
- (void)dismissFromView;
- (instancetype)initWithIsOpenAccount:(NSString *)openAccount flag:(NSInteger)flag;

@end

typedef void(^agreementBlock)(NSInteger flagNumber);
@interface ItemFourView : UIView

- (instancetype)initWithFrame:(CGRect)frame isOpenAccount:(NSString *)openAccount flag:(NSInteger)flag;

@property (nonatomic, copy)agreementBlock agreement;

@end
