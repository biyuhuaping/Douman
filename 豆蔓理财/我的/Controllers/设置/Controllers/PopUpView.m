//
//  PopUpView.m
//  豆蔓理财
//
//  Created by edz on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "PopUpView.h"

@interface PopUpView ()

@property (nonatomic, strong) UIView *promptbox;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *prompttitle;//
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation PopUpView

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithBtnTitle:(NSString *)Btntitle{
    
    self = [super initWithFrame:frame];
    
    if (self ) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

        [self.promptbox addSubview:self.img];
        [_promptbox addSubview:self.prompttitle];
        _prompttitle.text = title;
        [_promptbox addSubview:self.line];
        [_promptbox addSubview:self.btn];
        [_btn setTitle:Btntitle forState:UIControlStateNormal];

    }
    return self;
}

- (UIView *)promptbox {
    
    if (!_promptbox) {
        
        _promptbox  = [[UIView alloc] init];
        _promptbox.frame = CGRectMake((DMDeviceWidth - 270)/2, (DMDeviceHeight - 314/2)/2, 270, 314/2);
        _promptbox.backgroundColor = [UIColor whiteColor];
        [self addSubview:_promptbox];

    }
    return _promptbox;
}

- (UIImageView *)img {
    
    if (!_img) {
        _img = [[UIImageView alloc] init];
        _img.frame = CGRectMake((270-34)/2, 20, 34, 34);
        _img.image = [UIImage imageNamed:@"绑卡-确定"];
    }
    return _img;
}

- (UILabel *)prompttitle {
    
    if (!_prompttitle) {
        _prompttitle = [[UILabel alloc] init];
        _prompttitle.frame = CGRectMake(0, 20 + 16 + 34, 270, 14);
        _prompttitle.textAlignment = NSTextAlignmentCenter;
        _prompttitle.textColor = UIColorFromRGB(0xdfa93c);
        _prompttitle.font = SYSTEMFONT(14);
    }
    return _prompttitle;
}

- (UIImageView *)line {
    
    if (!_line) {
        _line = [[UIImageView alloc] init];
        _line.frame = CGRectMake(0, _prompttitle.frame.origin.y+_prompttitle.frame.size.height + 27, 270, 1);
        _line.image = [UIImage imageNamed:@"分割线"];
    }
    return _line;
}

- (UIButton *)btn {
    
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame =CGRectMake(0, 157 - 46, 270, 46);
        [_btn setTitleColor:UIColorFromRGB(0x445c85) forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btn;
}



//////delegate
- (void)buttonClick {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(Click)]) {
        
        [self.delegate Click];
    }
    

}


@end
