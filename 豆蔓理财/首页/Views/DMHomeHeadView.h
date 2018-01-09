//
//  DMHomeHeadView.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/26.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DMHomeHeadViewDelegate <NSObject>

- (void)loginAction;

- (void)didSelectButtonWithIndex:(NSInteger)index;

- (void)didSelectNoticeWithIndex:(NSInteger)index;

- (void)didSelectBannerWithIndex:(NSInteger)index;

@end


@interface DMHomeHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSArray *noticeArray;


@property (nonatomic, weak) id<DMHomeHeadViewDelegate>delegate;


@end
