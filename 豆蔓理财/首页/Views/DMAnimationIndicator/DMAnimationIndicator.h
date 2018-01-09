//
//  DMAnimationIndicator.h
//  豆蔓理财
//
//  Created by edz on 2016/12/7.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMAnimationIndicator : UIView

@property(nonatomic,strong) CABasicAnimation *strokeEndAnimation;


@property(nonatomic, assign)CGFloat totalBidpercent;


- (instancetype)initWithFrame:(CGRect)frame totalBidpercent:(CGFloat )totalBidpercent;

@end
