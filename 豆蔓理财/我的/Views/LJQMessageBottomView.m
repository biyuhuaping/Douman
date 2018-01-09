//
//  LJQMessageBottomView.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQMessageBottomView.h"

@implementation LJQMessageBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [self setUp];
    }
    return self;
}

- (void)setUp {
    NSArray *array = @[@"全选",@"标记已读",@"删除"];
    for (NSInteger number = 0; number < 3; number++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(SCREENWIDTH / 3 * number, 0, SCREENWIDTH / 3, 49);
        if (number == 0) {
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ((SCREENWIDTH / 3) / 2 - 25));
        }
        if (number == 2) {
            button.titleEdgeInsets = UIEdgeInsetsMake(0, ((SCREENWIDTH / 3) / 2 - 25), 0, 0);
        }
        button.tag = 10000 + number;
        [button setTitle:array[number] forState:(UIControlStateNormal)];
        [button setTitleColor:UIColorFromRGB(0x445c85) forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [button addTarget:self action:@selector(selectedAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];
    }
}

- (void)selectedAction:(UIButton *)sender {
    
    if (sender.tag == 10000) {
        if (sender.selected) {
            sender.selected = !sender.selected;
            [sender setTitle:@"全选" forState:(UIControlStateNormal)];
        }else {
            sender.selected = !sender.selected;
            [sender setTitle:@"取消" forState:(UIControlStateNormal)];
        }
    }
    self.block(sender.tag - 10000,sender.selected);
}

@end
