//
//  LJQMessageTopView.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQMessageTopView.h"
@interface LJQMessageTopView ()

@property (nonatomic, strong)UIView *silderView;
@property (nonatomic, strong)UIColor *selectedColor;
@property (nonatomic, strong)UIButton *editButton;


@end

@implementation LJQMessageTopView

- (instancetype)initWithFrame:(CGRect)frame selectedColor:(UIColor *)selectedColor {
    self = [super initWithFrame:frame];
    self.selectedColor = selectedColor;
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    NSArray *array = @[@"平台公告",@"系统消息"];
    for (NSInteger number = 0; number < 2; number++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        if (number == 0) {
            button.frame = CGRectMake( 81, 0, 70, 39);
            [button setTitleColor:UIColorFromRGB(0x445c85) forState:(UIControlStateNormal)];
            self.selectedBtn = button;
        }
        if (number == 1) {
            button.frame = CGRectMake(SCREENWIDTH - 151, 0, 70, 39);
            [button setTitleColor:UIColorFromRGB(0x878787) forState:(UIControlStateNormal)];
            
        }
        button.tag = 2000 + number;
        [button setTitle:array[number] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(selectedAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
    }
    
    self.silderView = [[UIView alloc] initWithFrame:CGRectMake( 81, 39, 70, 1)];
    self.silderView.backgroundColor = self.selectedColor;
    [self addSubview:self.silderView];
    
    
    self.editButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.editButton.frame = CGRectMake(SCREENWIDTH - 44, 0, 26, 40);
    self.editButton.hidden = YES;
    [self.editButton setTitle:@"编辑" forState:(UIControlStateNormal)];
    [self.editButton setTitleColor:UIColorFromRGB(0x878787) forState:(UIControlStateNormal)];
    self.editButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [self.editButton addTarget:self action:@selector(EditAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.editButton];
}

- (void)selectedAction:(UIButton *)sender {
    
    if (sender.tag == 2000) {
        self.editButton.hidden = YES;
    }else {
        self.editButton.hidden = NO;
    }

    
    if (self.selectedBtn.tag == sender.tag) {
        [sender setTitleColor:UIColorFromRGB(0x445c85) forState:(UIControlStateNormal)];
       
    }else {
        [sender setTitleColor:UIColorFromRGB(0x445c85) forState:(UIControlStateNormal)];
        [self.selectedBtn setTitleColor:UIColorFromRGB(0x878787) forState:(UIControlStateNormal)];
        [UIView animateWithDuration:0.3 animations:^{
            [self.silderView setFrame:CGRectMake(sender.frame.origin.x, 39, 70, 1)];
        }];
    }
    self.selectedBtn = sender;
    self.block(sender);
    
}

- (void)EditAction:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = !sender.selected;
        [sender setTitle:@"编辑" forState:(UIControlStateNormal)];
    }else {
        sender.selected = !sender.selected;
        [sender setTitle:@"完成" forState:(UIControlStateNormal)];
    }
    
    self.editBlock(sender);
}


@end
