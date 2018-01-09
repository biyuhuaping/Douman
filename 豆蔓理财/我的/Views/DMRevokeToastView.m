//
//  DMRevokeToastView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRevokeToastView.h"


@interface DMRevokeToastView ()

@property (nonatomic, strong) UIView *backView;

@end

@implementation DMRevokeToastView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.frame = DMDeviceFrame;
        [self creatViews];
        
        
    }
    return self;
}

- (void)creatViews{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake((DMDeviceWidth-270)/2,(DMDeviceHeight-155)/2, 270, 155)];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(135, 105, 135, 50)];
    [confirmBtn setTitleColor:UIColorFromRGB(0xfd9726) forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_backView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmAciton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 105, 135, 50)];
    [cancelBtn setTitleColor:UIColorFromRGB(0x929397) forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_backView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 270, 45)];
    titleLabel.text = @"确认撤销";
    titleLabel.textColor = UIColorFromRGB(0x595757);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.backView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 230, 50)];
    detailLabel.text = @"撤销后，您为转让的债权金额需本债权到期后拿回";
    detailLabel.textColor = UIColorFromRGB(0xfd9726);
    detailLabel.numberOfLines = 2;
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = [UIFont systemFontOfSize:14];
    [self.backView addSubview:detailLabel];
    
    UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(134.5, 105, 1, 50)];
    vline.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [_backView addSubview:vline];
    UIView *Hline = [[UIView alloc] initWithFrame:CGRectMake(0, 105, 270, 1)];
    Hline.backgroundColor = UIColorFromRGB(0xf9f9f9);
    [_backView addSubview:Hline];

}

- (void)show{
    self.backView.alpha=0;
    self.backView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 1;
        self.backView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)confirmAciton{
    [self hide];
    if (self.RevokeAction) {
        self.RevokeAction();
    }
}

- (void)cancelAction{
    [self hide];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0;
        self.backView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
