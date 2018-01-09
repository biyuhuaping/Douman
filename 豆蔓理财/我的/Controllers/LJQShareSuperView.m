//
//  LJQShareSuperView.m
//  豆蔓理财
//
//  Created by mac on 2017/1/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQShareSuperView.h"
#import "LJQShareView.h"

@interface LJQShareSuperView ()

@property (nonatomic, strong)LJQShareView *shareView;

@end

@implementation LJQShareSuperView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:((float)((0x262626 & 0xFF0000) >> 16))/255.0 green:((float)((0x262626 & 0xFF00) >> 8))/255.0 blue:((float)(0x262626 & 0xFF))/255.0 alpha:0.5];
        [self setViewUp];
    }
    return self;
}

- (void)setViewUp {
    UIImage *iamge = [UIImage imageNamed:@"分享到"];
    self.shareView  = [[LJQShareView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 104, (DMDeviceWidth - 104) * iamge.size.height / iamge.size.width)];
    self.shareView.alpha = 1;
    self.shareView.center = CGPointMake(DMDeviceWidth / 2, DMDeviceHeight / 2);
    
    CGFloat scale = (DMDeviceWidth - 104)  / iamge.size.width;
    
    self.shareView.transform = CGAffineTransformMakeScale(scale, scale);
    [self addSubview:self.shareView];
    
    
    __weak LJQShareSuperView *weakSelf = self;
    self.shareView.closeView = ^() {
        [weakSelf removeFromSuperview];
    };
    
    self.shareView.shareGood = ^(NSInteger index) {
        if (index == 0) {
            //分享好友
            NSLog(@"分享好友");
            [[ShareManager sharedManager] sharedFrindWithType:sharedTypeWeChat
                                                andController:weakSelf
                                                      andText:@"豆蔓智投"
                                                     andImage:[UIImage imageNamed:@"shareimage"]
                                                      Content:@"注册送现金礼包"
                                                          Url:@"www.douman.com"];
            [weakSelf removeFromSuperview];
        }
        if (index == 1) {
            //分享朋友圈
            NSLog(@"分享朋友");
            [[ShareManager sharedManager] sharedFrindWithType:sharedTypeFriendQurn
                                                andController:weakSelf
                                                      andText:@"豆蔓智投"
                                                     andImage:[UIImage imageNamed:@"shareimage"]
                                                      Content:@"注册送现金礼包"
                                                          Url:@"www.douman.com"];

            [weakSelf removeFromSuperview];
        }
    };
}

@end
