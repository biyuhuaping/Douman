//
//  MenuButton.m
//  titleViewTest
//
//  Created by wujianqiang on 16/9/26.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "MenuButton.h"


//#define SelectColor UIColorFromRGB(0xffd542)
//#define UnSelectColor UIColorFromRGB(0x4b6ca7)
@interface MenuButton ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *botLine;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat buttonWide;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *unSecectColor;
@end


@implementation MenuButton


- (instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArray SelectColor:(UIColor *)selectColor UnselectColor:(UIColor *)unselectcolor{
    self = [super initWithFrame:frame];
    if (self) {
        if (titleArray.count < 4) {
            self.buttonWide = self.bounds.size.width/titleArray.count;
        }else{
            self.buttonWide = self.bounds.size.width/3.5;
        }
        self.selectColor = selectColor;
        self.unSecectColor = unselectcolor;
        
        [self creatButtonWithTitleArray:titleArray];
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.botLine];
    }
    return self;
}

- (void)creatButtonWithTitleArray:(NSArray *)titleArray{
    CGFloat buttonWide = self.buttonWide;
    self.scrollView.contentSize = CGSizeMake(titleArray.count * buttonWide, 42);
    
    
    for (int i = 0; i < titleArray.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonWide, 0, buttonWide, 42);
        button.tag = i;
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = FONT_Regular(14);
        
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTitleColor:self.unSecectColor forState:UIControlStateNormal];
        if (i==0) {
            button.selected = YES;
        }
        
        [self.buttonArray addObject:button];
        [self.scrollView addSubview:button];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonAction:(UIButton *)button{
    if (button.selected == YES) {
        
    }else{
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        button.selected = YES;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.botLine.frame = CGRectMake((button.tag) * (self.buttonWide)+self.buttonWide/4, 42, self.buttonWide/2, 2);
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
    
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.botLine.frame = CGRectMake((index) * (self.buttonWide) + self.buttonWide/4, 42, self.buttonWide/2, 2);
//    } completion:nil];

}


- (UIView *)botLine{
    if (_botLine == nil) {
        self.botLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.bounds.size.width*2, 1)];
        _botLine.backgroundColor = MainF5;
    }
    return _botLine;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
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











