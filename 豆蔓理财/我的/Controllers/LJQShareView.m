//
//  LJQShareView.m
//  豆蔓理财
//
//  Created by mac on 2017/1/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQShareView.h"

@interface LJQShareView ()

@property (nonatomic, strong)UIImageView *bottomView;

@end

@implementation LJQShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
        [self createBtn];
        [self createCloseBtn];
    }
    return self;
}

- (void)setUp {
    
    UIImage *iamge = [UIImage imageNamed:@"分享到"];
    self.bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 104, (DMDeviceWidth - 104) * iamge.size.height / iamge.size.width)];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.image = iamge;
    [self addSubview:self.bottomView];
}

- (void)createBtn {
    NSArray<NSString *> *imgArr = @[@"微信",@"朋友圈"];
    NSArray<NSString *> *nameArr = @[@"微信好友",@"朋友圈"];

    UIImage *image = [UIImage imageNamed:@"微信"];
    for (int space = 0; space < 2; space++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setBackgroundImage:[UIImage imageNamed:imgArr[space]] forState:(UIControlStateNormal)];
        [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        if (space == 0) {
            button.center = CGPointMake(52 + image.size.width / 2, LJQ_VIEW_Height(self.bottomView) / 2 - 20);
        }
        if (space == 1) {
            button.center = CGPointMake(LJQ_VIEW_Width(self) - (52 + image.size.width / 2), LJQ_VIEW_Height(self.bottomView) / 2 - 20);
        }
        button.tag = 100 + space;
        [button addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.bottomView addSubview:button];
        
        UILabel *label = [UILabel createLabelFrame:CGRectMake(button.frame.origin.x - 5, LJQ_VIEW_MaxY(button) + 10, image.size.width + 10, 15) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:13.f];
        label.text = nameArr[space];
        [self.bottomView addSubview:label];
    }
}

- (void)createCloseBtn {
    
    UIImage *image = [UIImage imageNamed:@"关闭"];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setBackgroundImage:image forState:(UIControlStateNormal)];
    [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    button.center = CGPointMake(LJQ_VIEW_Width(self.bottomView) / 2, LJQ_VIEW_Height(self.bottomView) - image.size.height / 2 - 11);
    [button addTarget:self action:@selector(closeViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView addSubview:button];
}

- (void)shareAction:(UIButton *)sender {
    self.shareGood(sender.tag - 100);
}

- (void)closeViewAction:(UIButton *)sender {
    
    NSLog(@"123");
    self.closeView();
}

@end
