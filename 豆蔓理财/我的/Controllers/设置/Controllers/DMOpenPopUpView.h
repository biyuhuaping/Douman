//
//  DMOpenPopUpView.h
//  豆蔓理财
//
//  Created by edz on 2017/5/9.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpenPopUpDelegate <NSObject>

@optional

- (void)openpopupClick;

@end

@interface DMOpenPopUpView : UIView


/**
 @param hasBandCard NO  立即开通   YES 立即绑卡
 */
- (instancetype)initWithFrame:(CGRect)frame HasBandCard:(BOOL)hasBandCard;

@property (nonatomic, weak)id<OpenPopUpDelegate>delegate;



@end
