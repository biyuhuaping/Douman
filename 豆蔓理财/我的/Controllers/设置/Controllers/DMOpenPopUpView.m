//
//  DMOpenPopUpView.m
//  豆蔓理财
//
//  Created by edz on 2017/5/9.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMOpenPopUpView.h"

@interface DMOpenPopUpView ()

@property (nonatomic, strong)UIView *view;
@property (nonatomic, strong)UIView *backview;

@property (nonatomic, strong)UILabel *title;
@property (nonatomic, strong)UIButton *delete;
@property (nonatomic, strong)UIImageView *logo;
@property (nonatomic, strong)UILabel *remind;
@property (nonatomic, strong)UIImageView *line;
@property (nonatomic, strong)UIButton *btn;


@end

@implementation DMOpenPopUpView

- (instancetype) initWithFrame:(CGRect)frame HasBandCard:(BOOL)hasBandCard{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.view];
        [self addSubview:self.backview];
        [_backview addSubview:self.title];
        [_backview addSubview:self.delete];
        [_backview addSubview:self.logo];
        [_backview addSubview:self.remind];
        [_backview addSubview:self.line];
        [_backview addSubview:self.btn];
        [_btn setTitle:hasBandCard?@"立即绑卡":@"立即开通" forState:UIControlStateNormal];
        
    }
    
    return self;
}

- (UIView *)view {
    
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.frame = CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight);
        _view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _view.userInteractionEnabled = YES;
        [_view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteClick)]];
    }
    return _view;
}

- (UIView *)backview {
    
    if (!_backview) {
        _backview = [[UIView alloc] init];
        _backview.frame = CGRectMake((DMDeviceWidth-270)/2, (DMDeviceHeight-373/2-64)/2, 270, 373/2);
        _backview.backgroundColor = [UIColor whiteColor];
        _backview.layer.cornerRadius = 15;
    }
    return _backview;

}


- (UILabel *)title {
    
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.frame = CGRectMake(0, 19, 270, 14);
        _title.font = SYSTEMFONT(14);
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = UIColorFromRGB(0x595757);
        _title.text = @"豆蔓智投接入徽商银行存管账户";
    }
    
    return _title;
}

- (UIButton *)delete {
    
    if (!_delete) {
        _delete = [UIButton buttonWithType:UIButtonTypeCustom];
        _delete.frame = CGRectMake(270 - 18 - 3, 3, 15+6, 15+6);
        [_delete setImageEdgeInsets:UIEdgeInsetsMake(0, -13, 0, 0)];
        //[_delete setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [_delete setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [_delete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _delete;
}

- (void)deleteClick {
    
    [self removeFromSuperview];

    [[NSUserDefaults standardUserDefaults] setObject:@"show" forKey:@"showview"];
}


- (UIImageView *) logo {
    
    if (!_logo) {
        _logo = [[UIImageView alloc] init];
        _logo.frame = CGRectMake((270-242)/2, 55, 242, 55/2);
        _logo.image = [UIImage imageNamed:@"弹窗logo"];
    }
    
    return _logo;

}



- (UILabel *)remind {
    
    if (!_remind) {
        _remind = [[UILabel alloc] init];
        _remind.frame = CGRectMake(0, 373/2 - 130/2-12, 270, 12);
        _remind.font = SYSTEMFONT(12);
        _remind.textAlignment = NSTextAlignmentCenter;
        _remind.textColor = UIColorFromRGB(0xfd9726);
        _remind.text = @"为保障您的资金安全，请先开通银行存管账户";
    }

    return _remind;
}

- (UIImageView *) line {
    
    if (!_line) {
        
        _line = [[UIImageView alloc] init];
        _line.frame = CGRectMake(0, 373/2 - 130/2+13, 270, 1);
        _line.image = [UIImage imageNamed:@"分割线"];

    }
    
    return _line;
}

- (UIButton *) btn {
    
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame =CGRectMake(0, 141, 270, 40);
        [_btn setTitleColor:UIColorFromRGB(0x445c85) forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        _btn.titleLabel.font = SYSTEMFONT(15);
    }
    
    
    return _btn;
}

- (void)buttonClick {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(openpopupClick)] ) {
        [self.delegate openpopupClick];
        [self removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:@"show" forKey:@"showview"];
    }
}


@end
