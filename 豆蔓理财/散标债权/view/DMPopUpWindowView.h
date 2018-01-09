//
//  DMPopUpWindowView.h
//  豆蔓理财
//
//  Created by edz on 2017/7/31.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^confirmEventBlock)(NSInteger number);
@interface DMPopUpWindowView : UIView

@property (nonatomic, copy)confirmEventBlock jumpToAgreement;

- (void)showView;
- (void)dismissFromView;
- (instancetype)initWithIsMessageStr:(NSArray *)MessageStr buttonTitle:(NSArray *)buttonTitle btnColorArr:(NSArray *)btnColorArr flag:(NSInteger)flag;

@end


typedef void(^agreementBlock)(NSInteger flagNumber);
@interface DMPopUpView : UIView

- (instancetype)initWithFrame:(CGRect)frame isOpenMessage:(NSArray *)messageArr btnTitle:(NSArray *)btnTitle btnColorArr:(NSArray *)btnColorArr flag:(NSInteger)flag;

@property (nonatomic, copy)agreementBlock agreement;

@end
