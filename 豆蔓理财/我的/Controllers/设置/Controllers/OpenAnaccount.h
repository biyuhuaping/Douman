//
//  OpenAnaccount.h
//  豆蔓理财
//
//  Created by edz on 2017/6/1.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpenAnaccountDelegate <NSObject>

@optional

- (void)openClick;
- (void)deleteClick;

@end


@interface OpenAnaccount : UIView



@property (nonatomic, weak)id<OpenAnaccountDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title;


@end
