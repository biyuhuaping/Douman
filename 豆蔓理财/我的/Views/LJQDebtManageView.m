//
//  LJQDebtManageView.m
//  豆蔓理财
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQDebtManageView.h"

@interface LJQDebtManageView ()

@property (nonatomic, strong)UIView *silderView;
@property (nonatomic, strong)UIColor *selectedColor;

@end

@implementation LJQDebtManageView

- (instancetype)initWithFrame:(CGRect)frame selectedColor:(UIColor *)selectedColor {
    self = [super initWithFrame:frame];
    self.selectedColor = selectedColor;
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    NSArray *array = @[@"可转让",@"转让中",@"已转让"];
    for (NSInteger number = 0; number < array.count; number++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [button setFrame:CGRectMake(SCREENWIDTH / 3 * number, 0, SCREENWIDTH / 3, 39)];
         [button setTitleColor:UIColorFromRGB(0x878787) forState:(UIControlStateNormal)];
        
        if (number == 0) {
            
            [button setTitleColor:UIColorFromRGB(0x445c85) forState:(UIControlStateNormal)];
            self.selectedBtn = button;
        }
        
        button.tag = 2000 + number;
        [button setTitle:array[number] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(selectedAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
    }
    
    self.silderView = [[UIView alloc] initWithFrame:CGRectMake((SCREENWIDTH / 3 - 70) / 2, 39, 70, 1)];
    self.silderView.backgroundColor = self.selectedColor;
    [self addSubview:self.silderView];
    
    
}

- (void)selectedAction:(UIButton *)sender {
    
    if (self.selectedBtn.tag == sender.tag) {
        [sender setTitleColor:UIColorFromRGB(0x445c85) forState:(UIControlStateNormal)];
        
    }else {
        [sender setTitleColor:UIColorFromRGB(0x445c85) forState:(UIControlStateNormal)];
        [self.selectedBtn setTitleColor:UIColorFromRGB(0x878787) forState:(UIControlStateNormal)];
        [UIView animateWithDuration:0.3 animations:^{
            [self.silderView setFrame:CGRectMake(sender.frame.origin.x + (SCREENWIDTH / 3 - 70) / 2, 39, 70, 1)];
        }];
    }
    self.selectedBtn = sender;
    self.block(sender);
    
}

@end
