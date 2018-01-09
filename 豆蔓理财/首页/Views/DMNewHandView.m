//
//  DMNewHandView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/6/15.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMNewHandView.h"
#import "TAPageControl.h"
@interface DMNewHandView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) TAPageControl *pageControl;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation DMNewHandView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = DMDeviceFrame;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self addSubview:self.backView];
        [self.backView addSubview:self.scrollView];
//        [self.backView addSubview:self.pageControl];
        
        
        [UIView animateWithDuration:2.0
                              delay:0.3
             usingSpringWithDamping:0.7
              initialSpringVelocity:5.0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.backView.center = CGPointMake(self.center.x, self.center.y);
                         }
                         completion:nil];

    }
    return self;
}

- (UIView *)backView{
    if (!_backView) {
        self.backView= [[UIView alloc] initWithFrame:CGRectMake(0, -DMDeviceHeight, DMDeviceWidth, DMDeviceHeight)];
    }
    return _backView;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:DMDeviceFrame];
        _scrollView.contentSize = CGSizeMake(DMDeviceWidth*self.imageArray.count, DMDeviceHeight);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < self.imageArray.count; i ++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(DMDeviceWidth * i + DMDeviceWidth/2, DMDeviceHeight/2+(96*DMDeviceHeight/568), 1,(58*DMDeviceHeight/568))];
            lineView.backgroundColor = UIColorFromRGB(0xfd657b);
            [_scrollView addSubview:lineView];

            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(DMDeviceWidth * i + 1, 0, 367 * DMDeviceWidth/375, DMDeviceHeight)];
            imageview.contentMode = UIViewContentModeScaleAspectFit;
            imageview.image = [UIImage imageNamed:self.imageArray[i]];
            [_scrollView addSubview:imageview];
            
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            closeButton.frame = CGRectMake(DMDeviceWidth * i + DMDeviceWidth/2 - 18, DMDeviceHeight/2+(DMDeviceHeight-355*DMDeviceHeight/667)/2+22*DMDeviceHeight/667 , 37, 37);
            [closeButton setImage: [UIImage imageNamed:@"关闭icon"] forState:UIControlStateNormal];
            [closeButton addTarget:self action:@selector(pushCloseButton) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:closeButton];
            
            UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
            openButton.frame = CGRectMake(DMDeviceWidth * i + (DMDeviceWidth-144)/2, DMDeviceHeight/2+ (40*DMDeviceHeight/568), 144, 32);
            [openButton setTitle:self.titleArray[i] forState:UIControlStateNormal];
            openButton.titleLabel.textColor = [UIColor whiteColor];
            openButton.titleLabel.font = [UIFont systemFontOfSize:14];
            openButton.backgroundColor = UIColorFromRGB(0xfd6a79);
            openButton.layer.cornerRadius = 16;
            openButton.layer.masksToBounds = YES;
            openButton.tag = i;
            [openButton addTarget:self action:@selector(pushOpenButton:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:openButton];
            
        }
    }
    return _scrollView;
}

- (TAPageControl *)pageControl{
    if (_pageControl == nil) {
        self.pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, DMDeviceHeight/2+(65*DMDeviceHeight/568), DMDeviceWidth, 40)];
        _pageControl.numberOfPages = 2;
        _pageControl.spacingBetweenDots = 5;
        _pageControl.dotImage = [UIImage imageNamed:@"newhand_unselect"];
        _pageControl.currentDotImage = [UIImage imageNamed:@"newhand_select"];
        _pageControl.dotSize = CGSizeMake(20, 5);
    }
    return _pageControl;
}

- (NSArray *)imageArray{
    if (_imageArray == nil) {
        self.imageArray = @[@"newhand2"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = @[@"注册立即领取"];
    }
    return _titleArray;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint p = scrollView.contentOffset;
    _pageControl.currentPage = p.x/self.bounds.size.width;
}


- (void)pushCloseButton{
    [self removeFromSuperview];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)pushOpenButton:(UIButton *)sender{
    [self removeFromSuperview];
    if (sender.tag == 0) {
//        if (self.detailBlock) {
//            self.detailBlock();
//        }
        if (self.registerBlock) {
            self.registerBlock();
        }

    }else{

    }
}


@end
