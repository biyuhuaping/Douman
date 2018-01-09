//
//  PopUpView.h
//  豆蔓理财
//
//  Created by edz on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpDelegate <NSObject>

- (void)Click;

@end

@interface PopUpView : UIView

@property (nonatomic, weak)id<PopUpDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithBtnTitle:(NSString *)Btntitle;

@end
