//
//  LunchView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/1/15.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LunchView.h"
#import "TAPageControl.h"
#import "HMTabBarViewController.h"
#import "AppDelegate.h"


@interface LunchView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) TAPageControl *pageControl;
@property (nonatomic, strong) UIButton *startButton;

@end

@implementation LunchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.backImage];
        [self.backImage addSubview:self.scrollView];
        [self.backImage addSubview:self.pageControl];
        [self.scrollView addSubview:self.startButton];

    }
    return self;
}

- (UIImageView *)backImage{
    if (_backImage == nil) {
        self.backImage = [[UIImageView alloc] initWithFrame:DMDeviceFrame];
        _backImage.image = [UIImage imageNamed:@"lunchbackimage"];
        _backImage.userInteractionEnabled = YES;
    }
    return _backImage;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:DMDeviceFrame];
        _scrollView.contentSize = CGSizeMake(DMDeviceWidth*self.imageArray.count, DMDeviceHeight);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < self.imageArray.count; i ++) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(DMDeviceWidth * i, 0, DMDeviceWidth, DMDeviceHeight)];
            imageview.image = [UIImage imageNamed:self.imageArray[i]];
            [_scrollView addSubview:imageview];
        }
    }
    return _scrollView;
}

- (TAPageControl *)pageControl{
    if (_pageControl == nil) {
        self.pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, DMDeviceHeight-50, DMDeviceWidth, 40)];
        _pageControl.numberOfPages = 3;
        _pageControl.spacingBetweenDots = 5;
        _pageControl.dotImage = [UIImage imageNamed:@"pagepointunselect"];
        _pageControl.currentDotImage = [UIImage imageNamed:@"pagepointselect"];
        _pageControl.dotSize = CGSizeMake(20, 5);
    }
    return _pageControl;
}

- (UIButton *)startButton{
    if (_startButton == nil) {
        self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _startButton.frame = CGRectMake(DMDeviceWidth * 2 +(DMDeviceWidth-200)/2, DMDeviceHeight-150, 200, 60);
        [_startButton setBackgroundImage:[UIImage imageNamed:@"startButton"] forState:UIControlStateNormal];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"startButton"] forState:UIControlStateHighlighted];
        [_startButton addTarget:self action:@selector(startEarnMoney:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (void)startEarnMoney:(UIButton *)btn{
    [self removeFromSuperview];
    if (self.start) {
        self.start();
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint p = scrollView.contentOffset;
    _pageControl.currentPage = p.x/self.bounds.size.width;
}


- (NSArray *)imageArray{
    if (_imageArray == nil) {
        self.imageArray = @[@"lunch1",@"lunch2",@"lunch3"];
    }
    return _imageArray;
}



@end
