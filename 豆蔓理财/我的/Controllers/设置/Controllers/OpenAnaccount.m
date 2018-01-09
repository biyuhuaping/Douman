//
//  OpenAnaccount.m
//  豆蔓理财
//
//  Created by edz on 2017/6/1.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "OpenAnaccount.h"

@interface OpenAnaccount ()

@property (nonatomic, strong)UIView *view;
@property (nonatomic, strong)UIView *backview;

@property (nonatomic, strong)UILabel *titleL;
@property (nonatomic, strong)UIButton *delete;
@property (nonatomic, strong)UILabel *remind;
@property (nonatomic, strong)UIImageView *line;
@property (nonatomic, strong)UIButton *btn;

@property (nonatomic, copy)NSString *title;

@end

@implementation OpenAnaccount

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.title = title;
        
        [self addSubview:self.view];
        [self addSubview:self.backview];
        //[_backview addSubview:self.titleL];
        [_backview addSubview:self.delete];
        [_backview addSubview:self.remind];
        [_backview addSubview:self.line];
        [_backview addSubview:self.btn];
        
        
    }
    
    
    return self;
    
}

- (UIView *)view {
    
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.frame = CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight);
        _view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
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

- (UILabel *)titleL {
    
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.frame = CGRectMake(0, 19, 270, 14);
        _titleL.font = SYSTEMFONT(14);
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.textColor = UIColorFromRGB(0x595757);
        _titleL.text = self.title;
    }
    
    return _titleL;
}

- (UIButton *)delete {
    
    if (!_delete) {
        _delete = [UIButton buttonWithType:UIButtonTypeCustom];
        _delete.frame = CGRectMake(270 - 18 - 10, 6, 15, 15);
        [_delete setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [_delete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _delete;
}

- (UILabel *)remind {
    
    if (!_remind) {
        _remind = [[UILabel alloc] init];
        _remind.frame = CGRectMake(0, 70, 270, 16);
        _remind.font = SYSTEMFONT(16);
        _remind.textAlignment = NSTextAlignmentCenter;
        _remind.textColor = UIColorFromRGB(0xfd9726);
        _remind.text = self.title;
    }
    
    return _remind;
}

- (UIImageView *) line {
    
    if (!_line) {
        
        _line = [[UIImageView alloc] init];
        _line.frame = CGRectMake(0, 136, 270, 1);
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
        if ([self.title isEqualToString:@"开户成功"]) {
            [_btn setTitle:@"设置交易密码" forState:UIControlStateNormal];
        } else {
            [_btn setTitle:@"重新开户" forState:UIControlStateNormal];
        }
        
    }
    
    
    return _btn;
}

- (void)deleteClick {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteClick)] ) {
        
        [self.delegate deleteClick];
        
        [self removeFromSuperview];
    }

    
}

- (void)buttonClick {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(openClick)] ) {
        
        [self.delegate openClick];
        
        [self removeFromSuperview];
    }

    
}



@end
