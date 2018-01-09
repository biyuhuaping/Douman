//
//  ManageMenuButton.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/2.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "ManageMenuButton.h"

#define SelectColor UIColorFromRGB(0x445c85)
#define UnSelectColor UIColorFromRGB(0x787878)
#define ButtonWide self.bounds.size.width/3.0
#define BOTHEIGHT 42
#define BTNHEIGHT 44

@interface ManageMenuButton ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *botLine;
@property (nonatomic, strong) UIScrollView *scrollView;


@end


@implementation ManageMenuButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatButton];
        //        [self creatMidLine];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.botLine];
    }
    return self;
}

- (void)creatButton{
    NSArray *titleArray = @[@"可转让",@"转让中",@"已转让"];
    CGFloat buttonWide = ButtonWide;
    self.scrollView.contentSize = CGSizeMake(titleArray.count * buttonWide, BTNHEIGHT);
    
    
    for (int i = 0; i < titleArray.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonWide, 0, buttonWide, BTNHEIGHT);
        button.tag = i;
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
        
        [button setTitleColor:SelectColor forState:UIControlStateSelected];
        [button setTitleColor:UnSelectColor forState:UIControlStateNormal];
        if (i==0) {
            button.selected = YES;
        }
        
        [self.buttonArray addObject:button];
        [self.scrollView addSubview:button];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//- (void)creatMidLine{
//    for (int i = 1; i < 4; i ++) {
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width/4.0)*i, 16, 1, 10)];
//        lineView.backgroundColor = UIColorFromRGB(0xcccccc);
//        [self addSubview:lineView];
//    }
//}

- (void)buttonAction:(UIButton *)button{
    if (button.selected == YES) {
        
    }else{
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        button.selected = YES;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.botLine.frame = CGRectMake((button.tag) * (ButtonWide)+ButtonWide/6, BOTHEIGHT, ButtonWide*2/3, 2);
        } completion:nil];
        
        [self.delegate selectButtonWithIndex:button.tag];
    }
}

- (void)setSelectButtonWithIndex:(NSInteger)index{
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == index) {
            obj.selected = YES;
        }else{
            obj.selected = NO;
        }
    }];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.botLine.frame = CGRectMake((index) * (ButtonWide) + ButtonWide/6, BOTHEIGHT, ButtonWide*2/3, 2);
    } completion:nil];
    
}


- (UIView *)botLine{
    if (_botLine == nil) {
        self.botLine = [[UIView alloc] initWithFrame:CGRectMake(ButtonWide/6, BOTHEIGHT, ButtonWide*2/3, 2)];
        _botLine.backgroundColor = SelectColor;
    }
    return _botLine;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, BTNHEIGHT)];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (NSMutableArray *)buttonArray{
    if (_buttonArray == nil) {
        self.buttonArray = [@[] mutableCopy];
    }
    return _buttonArray;
}



@end
