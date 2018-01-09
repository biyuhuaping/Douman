//
//  CLTShareView.m
//  财路通理财
//
//  Created by wujianqiang on 2017/1/6.
//  Copyright © 2017年 wangguomin. All rights reserved.
//

#import "CLTShareView.h"

#define HEIGHT 212
#define WIDE 271

@interface CLTShareView ()

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UIButton *exitButton;

@end

@implementation CLTShareView


- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = DMDeviceFrame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.backImage.transform = CGAffineTransformMakeScale(0.01, 0.01);

        [self addSubview:self.backImage];
        [self.backImage addSubview:self.exitButton];
        
        
        NSArray *title = @[@"微信",@"朋友圈"];
        for (int i = 0; i < 2; i ++) {
            UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
            wechatButton.frame = CGRectMake((WIDE/2.f - 47)/2.f + (WIDE/2)*i, 70, 47, 47);
            [wechatButton setBackgroundImage:[UIImage imageNamed:title[i]] forState:UIControlStateNormal];
            [wechatButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            wechatButton.tag = i;
            [self.backImage addSubview:wechatButton];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * WIDE/2, 125, WIDE/2, 20)];
            label.text = title[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColorFromRGB(0x595757);
            label.font = [UIFont systemFontOfSize:13];
            [self.backImage addSubview:label];
        }
    }
    return self;
}

- (UIImageView *)backImage{
    if (!_backImage) {
        self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake((DMDeviceWidth-WIDE)/2.0, (DMDeviceHeight-HEIGHT)/2.0, WIDE, HEIGHT)];
        _backImage.image = [UIImage imageNamed:@"分享到"];
        _backImage.userInteractionEnabled = YES;
    }
    return _backImage;
}

- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.backImage.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1;
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.backImage.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self hide];
//}

- (void)shareAction:(UIButton *)button{
    [self hide];
    if (self.wechatBlock) {
        self.wechatBlock(button.tag);
    }
}

- (UIButton *)exitButton{
    if (!_exitButton) {
        self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitButton.frame = CGRectMake((WIDE-80)/2, HEIGHT-50, 80, 50);
        [_exitButton setBackgroundImage:[UIImage imageNamed:@"exitshare"] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}


@end
