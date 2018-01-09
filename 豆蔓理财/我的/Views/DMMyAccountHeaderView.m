//
//  DMMyAccountHeaderView.m
//  豆蔓理财
//
//  Created by bluesky on 2017/8/24.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMMyAccountHeaderView.h"
#import "CommonMethod.h"
#import "LJQMineModel.h"
#define accountSacle [UIScreen mainScreen].bounds.size.width / 375
@interface DMMyAccountHeaderView ()<UIScrollViewDelegate>

@property (nonatomic, strong)UILabel *totalEarnLabel;//累计收益
@property (nonatomic, strong)UILabel *totalEarnInfoLabel;

@property (nonatomic, strong)UILabel *myAssetLabel; //我的资产
@property (nonatomic, strong)UILabel *myAssetInfoLabel;

@property (nonatomic, strong)UIButton *showButton;

@property (nonatomic, strong)UIPageControl *pageControl;

@property (nonatomic, strong)UIImageView *bottomView;

@property (nonatomic, strong)UILabel *balanceLabel; //余额
@property (nonatomic, strong)UILabel *balanceInfoLabel;

@property (nonatomic, strong)UILabel *holdAssetLabel; //持有资产
@property (nonatomic, strong)UILabel *holdAssetInfoLabel;

@property (nonatomic, strong)UILabel *frozenAmountLabel; //冻结资产
@property (nonatomic, strong)UILabel *frozenAmountInfoLabel;

@property (nonatomic, strong)UIButton *topUpButton; //充值
@property (nonatomic, strong)UIButton *withDrawalButton;//提现

@property (nonatomic, strong)UIScrollView *topScrollView;

@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)UILabel *coverLabel;
@property (nonatomic, strong)UILabel *coverOtherLabel;
@property (nonatomic, strong)UILabel *coverTwoLabel;
@property (nonatomic, strong)UILabel *coverThreeLabel;

@property (nonatomic, strong)UILabel *frozenLabel;
@end

@implementation DMMyAccountHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xa5bad9);
        self.userInteractionEnabled = YES;
        [self addSubview:self.topScrollView];
        
        [self.topScrollView addSubview:self.coverLabel];
        [self.topScrollView addSubview:self.coverOtherLabel];
        
        [self.topScrollView addSubview:self.totalEarnLabel];
        [self.topScrollView addSubview:self.totalEarnInfoLabel];
        
        [self.topScrollView addSubview:self.myAssetInfoLabel];
        [self.topScrollView addSubview:self.myAssetLabel];
        
        [self addSubview:self.showButton];
        [self addSubview:self.pageControl];
        [self addSubview:self.bottomView];
        [self addSubview:self.lineView];
        
        [self.bottomView addSubview:self.coverTwoLabel];
        [self.bottomView addSubview:self.coverThreeLabel];
        [self.bottomView addSubview:self.frozenLabel];
        
        [self.bottomView addSubview:self.balanceLabel];
        [self.bottomView addSubview:self.balanceInfoLabel];
        [self.bottomView addSubview:self.holdAssetLabel];
        [self.bottomView addSubview:self.holdAssetInfoLabel];
        [self.bottomView addSubview:self.withDrawalButton];
        [self.bottomView addSubview:self.topUpButton];
        [self.bottomView addSubview:self.frozenAmountInfoLabel];
        [self.bottomView addSubview:self.frozenAmountLabel];
    }
    return self;
}
- (void)setMineModel:(LJQMineModel *)mineModel {
    if (_mineModel != mineModel) {
        _mineModel = mineModel;
    }
    //累计收益
    self.totalEarnInfoLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty([@(_mineModel.totalInterest) stringValue]) ? @"0.00" : [[CommonMethod methodCall] stringFormatterDecimalStyle:@(_mineModel.totalInterest)]];
    
    //可用余额
    self.balanceInfoLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty([@(_mineModel.availableAmount) stringValue]) ? @"0.00" : [[CommonMethod methodCall] stringFormatterDecimalStyle:@(_mineModel.availableAmount)]];
    
    //持有资产
    self.holdAssetInfoLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty([@(_mineModel.hasAmount) stringValue]) ? @"0.00" : [[CommonMethod methodCall] stringFormatterDecimalStyle:@(_mineModel.hasAmount)]];
    
    //我的资产
    self.myAssetInfoLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty([@(_mineModel.totalAmount) stringValue]) ? @"0.00" : [[CommonMethod methodCall] stringFormatterDecimalStyle:@(_mineModel.totalAmount)]];
    
    if (_mineModel.frozenAmount != 0) {
        [self.balanceLabel setFrame:CGRectMake(0, 50*accountSacle, DMDeviceWidth / 3, 13)];
        [self.balanceInfoLabel setFrame:CGRectMake(0, (50 + 24) * accountSacle + 13, DMDeviceWidth / 3, 18)];
        [self.coverTwoLabel setFrame:CGRectMake(0, (50 + 24) * accountSacle + 13, DMDeviceWidth / 3, 18)];
        
        [self.frozenAmountLabel setFrame:CGRectMake(DMDeviceWidth / 3, 50*accountSacle, DMDeviceWidth / 3, 13)];
        [self.frozenAmountLabel setHidden:NO];
        [self.frozenAmountInfoLabel setFrame:CGRectMake(DMDeviceWidth / 3, (50 + 24) * accountSacle + 13, DMDeviceWidth / 3, 18)];
        [self.frozenAmountInfoLabel setHidden:NO];
        self.frozenAmountInfoLabel.text = [NSString stringWithFormat:@"%@",[[CommonMethod methodCall] stringFormatterDecimalStyle:@(_mineModel.frozenAmount)]];
        [self.frozenLabel setFrame:CGRectMake(DMDeviceWidth / 3, (50 + 24) * accountSacle + 13, DMDeviceWidth / 3, 18)];
        [self.frozenLabel setHidden:NO];
        
        [self.holdAssetLabel setFrame:CGRectMake(DMDeviceWidth / 3 * 2, 50*accountSacle, DMDeviceWidth / 3, 13)];
        [self.holdAssetInfoLabel setFrame:CGRectMake(DMDeviceWidth / 3 * 2, (50 + 24) * accountSacle + 13, DMDeviceWidth / 3, 18)];
        [self.coverThreeLabel setFrame:CGRectMake(DMDeviceWidth / 3 * 2, (50 + 24) * accountSacle + 13, DMDeviceWidth / 3, 18)];
    }else {
        [self.frozenLabel setHidden:YES];
        [self.frozenAmountLabel setHidden:YES];
        [self.frozenAmountInfoLabel setHidden:YES];
        
        [self.balanceLabel setFrame:CGRectMake(0, 50*accountSacle, DMDeviceWidth / 2, 13)];
        [self.balanceInfoLabel setFrame:CGRectMake(0, (50 + 24) * accountSacle + 13, DMDeviceWidth / 2, 18)];
        [self.coverTwoLabel setFrame:CGRectMake(0, (50 + 24) * accountSacle + 13, DMDeviceWidth / 2, 18)];
        
        [self.holdAssetLabel setFrame:CGRectMake(DMDeviceWidth / 2, 50*accountSacle, DMDeviceWidth / 2, 13)];
        [self.holdAssetInfoLabel setFrame:CGRectMake(DMDeviceWidth / 2, (50 + 24) * accountSacle + 13, DMDeviceWidth / 2, 18)];
        [self.coverThreeLabel setFrame:CGRectMake(DMDeviceWidth / 2, (50 + 24) * accountSacle + 13, DMDeviceWidth / 2, 18)];
        
    }
}

- (void)layoutSubviews {
    
    CGFloat width = [[CommonMethod methodCall] returenLabelHeight:@"累计收益（元）" size:CGSizeMake(DMDeviceWidth, 14.f) fontsize:14.f isWidth:YES];
    UIImage *showImage = [UIImage imageNamed:@"lighten_iconlighten_icon"];
    
    [self.totalEarnLabel setFrame:CGRectMake((DMDeviceWidth - showImage.size.width - width - 10) / 2 + DMDeviceWidth, 6, width, 14.f)];
    [self.myAssetLabel setFrame:CGRectMake((DMDeviceWidth - showImage.size.width - width - 10) / 2, 6, width, 14.f)];
    [self.showButton setFrame:CGRectMake(LJQ_VIEW_MaxX(self.myAssetLabel) + 5 - showImage.size.width / 2, 7 - showImage.size.height / 2, showImage.size.width * 2, showImage.size.height * 2)];
    [self.showButton setImageEdgeInsets:UIEdgeInsetsMake(showImage.size.height / 2, showImage.size.width / 2, showImage.size.height / 2, showImage.size.width / 2)];
}



//展示金额显示状态
- (void)showAmountToHidden:(UIButton *)sender {
    
    [self addAnimationToViewWithView:self];
    if (sender.selected) {
        [self.topScrollView bringSubviewToFront:self.totalEarnInfoLabel];
        [self.topScrollView bringSubviewToFront:self.myAssetInfoLabel];
        [self.bottomView bringSubviewToFront:self.balanceInfoLabel];
        [self.bottomView bringSubviewToFront:self.holdAssetInfoLabel];
        [self.bottomView bringSubviewToFront:self.frozenAmountInfoLabel];
         [self.showButton setImage:[[UIImage imageNamed:@"lighten_iconlighten_icon"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]forState:(UIControlStateNormal)];
        sender.selected = !sender.selected;
    }else {
        [self.topScrollView bringSubviewToFront:self.coverLabel];
        [self.topScrollView bringSubviewToFront:self.coverOtherLabel];
        [self.bottomView bringSubviewToFront:self.coverTwoLabel];
        [self.bottomView bringSubviewToFront:self.coverThreeLabel];
        [self.bottomView bringSubviewToFront:self.frozenLabel];
        
        [self.showButton setImage:[[UIImage imageNamed:@"notshownotshow"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]forState:(UIControlStateNormal)];
        
        sender.selected = !sender.selected;
    }
}

//提现操作
- (void)accountWithDrawal:(UIButton *)sender {
    !self.myAccountToWithDrawal ? : self.myAccountToWithDrawal();
}

//充值操作
- (void)accountTopUp:(UIButton *)sender {
    !self.myAccountToTopUp ? : self.myAccountToTopUp();
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
     [self.showButton setHidden:YES];
   // [self scrollViewAddAnimationWithView:self.topScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == YES) {
         [self.showButton setHidden:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = self.topScrollView.contentOffset.x / self.topScrollView.frame.size.width;
    [self.pageControl setCurrentPage:page];
}

#pragma lazyLoading

- (UIScrollView *)topScrollView {
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 120)];
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.contentSize = CGSizeMake(DMDeviceWidth * 2, 120);
        _topScrollView.scrollEnabled = YES;
        _topScrollView.pagingEnabled = YES;
        _topScrollView.delegate = self;
        [_topScrollView setDelaysContentTouches:NO];
    }
    return _topScrollView;
}

- (UILabel *)totalEarnLabel {
  CGFloat width = [[CommonMethod methodCall] returenLabelHeight:@"累计收益（元）" size:CGSizeMake(DMDeviceWidth, 14.f) fontsize:14.f isWidth:YES];
    if (!_totalEarnLabel) {
        _totalEarnLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth, 6, width, 15) labelColor:UIColorFromRGB(0xffffff) textAlignment:NSTextAlignmentCenter textFont:14.f];
        _totalEarnLabel.font = FONT_Light(14.f);
        _totalEarnLabel.backgroundColor = UIColorFromRGB(0xa5bad9);
        _totalEarnLabel.text = @"累计收益（元）";
    }
    return _totalEarnLabel;
}

- (UIButton *)showButton {
    UIImage *showImage = [[UIImage imageNamed:@"lighten_iconlighten_icon"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    if (!_showButton) {
        _showButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _showButton.showsTouchWhenHighlighted = NO;
        [_showButton setFrame:CGRectMake(0, 0, showImage.size.width * 2, showImage.size.height * 2)];
        [_showButton setImage:[showImage imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]forState:(UIControlStateNormal)];
        [_showButton addTarget:self action:@selector(showAmountToHidden:) forControlEvents:(UIControlEventTouchUpInside)];
        [_showButton setImageEdgeInsets:UIEdgeInsetsMake(showImage.size.height / 2, showImage.size.width / 2, showImage.size.height / 2, showImage.size.width / 2)];
    }
    return _showButton;
}

- (UILabel *)totalEarnInfoLabel {
    if (!_totalEarnInfoLabel) {
        _totalEarnInfoLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth, 6 + 15 + 26, DMDeviceWidth, 36) labelColor:UIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) textFont:35.f];
        _totalEarnInfoLabel.backgroundColor = UIColorFromRGB(0xa5bad9);
        _totalEarnInfoLabel.font = FONT_Light(35.f);
        _totalEarnInfoLabel.text = @"0.00";
    }
    return _totalEarnInfoLabel;
}

- (UILabel *)myAssetLabel {
    CGFloat width = [[CommonMethod methodCall] returenLabelHeight:@"累计收益（元）" size:CGSizeMake(DMDeviceWidth, 14.f) fontsize:14.f isWidth:YES];
    if (!_myAssetLabel) {
        _myAssetLabel = [UILabel createLabelFrame:CGRectMake(0, 6, width, 15) labelColor:UIColorFromRGB(0xffffff) textAlignment:NSTextAlignmentCenter textFont:14.f];
        _myAssetLabel.font = FONT_Light(14.f);
        _myAssetLabel.backgroundColor = UIColorFromRGB(0xa5bad9);
        _myAssetLabel.text = @"我的资产（元）";
    }
    return _myAssetLabel;
}

- (UILabel *)myAssetInfoLabel {
    if (!_myAssetInfoLabel) {
        _myAssetInfoLabel = [UILabel createLabelFrame:CGRectMake(0, 6 + 15 + 26, DMDeviceWidth, 36) labelColor:UIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) textFont:35.f];
        _myAssetInfoLabel.backgroundColor = UIColorFromRGB(0xa5bad9);
        _myAssetInfoLabel.font = FONT_Light(35.f);
        _myAssetInfoLabel.text = @"0.00";
    }
    return _myAssetInfoLabel;
}

- (UILabel *)coverLabel {
    if (!_coverLabel) {
        _coverLabel = [UILabel createLabelFrame:CGRectMake(0, 6 + 15 + 26, DMDeviceWidth, 36) labelColor:UIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) textFont:30.f];
        _coverLabel.backgroundColor = UIColorFromRGB(0xa5bad9);
        _coverLabel.font = FONT_Light(30.f);
        _coverLabel.text = @"*****";
    }
    return _coverLabel;
}

- (UILabel *)coverOtherLabel {
    if (!_coverOtherLabel) {
        _coverOtherLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth, 6 + 15 + 26, DMDeviceWidth, 36) labelColor:UIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) textFont:30.f];
        _coverOtherLabel.backgroundColor = UIColorFromRGB(0xa5bad9);
        _coverOtherLabel.font = FONT_Light(30.f);
        _coverOtherLabel.text = @"*****";
    }
    return _coverOtherLabel;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(DMDeviceWidth / 2 - 7, 6 + 15 + 26 + 36 + 36 , 1, 1)];
        _pageControl.numberOfPages = 2;
        _pageControl.currentPage = 0;
        [_pageControl setValue:[[UIImage imageNamed:@"lunbodian_moren"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forKey:@"_pageImage"];
        [_pageControl setValue:[[UIImage imageNamed:@"lunbodian_xuanzhong"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]forKey:@"_currentPageImage"];
    }
    return _pageControl;
}

- (UIImageView *)bottomView {
    UIImage *image = [UIImage imageNamed:@"MyAccountStyle"];
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6 + 15 + 26 + 36 + 36 + 5, DMDeviceWidth, DMDeviceWidth *image.size.height / image.size.width)];
        _bottomView.image = image;
        _bottomView.userInteractionEnabled = YES;
    }
    return _bottomView;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [UILabel createLabelFrame:CGRectMake(0, 50*accountSacle, DMDeviceWidth / 2, 13) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _balanceLabel.font = FONT_Regular(12.f);
        _balanceLabel.text = @"可用余额（元）";
    }
    return _balanceLabel;
}

- (UILabel *)balanceInfoLabel {
    if (!_balanceInfoLabel) {
        _balanceInfoLabel = [UILabel createLabelFrame:CGRectMake(0, (50 + 24) * accountSacle + 13, DMDeviceWidth / 2, 18) labelColor:UIColorFromRGB(0xfc6f57) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
        _balanceInfoLabel.backgroundColor = UIColorFromRGB(0xffffff);
        _balanceInfoLabel.font = FONT_Light(17.f);
        _balanceInfoLabel.text = @"0.00";
    }
    return _balanceInfoLabel;
}

- (UILabel *)coverTwoLabel {
    if (!_coverTwoLabel) {
        _coverTwoLabel = [UILabel createLabelFrame:CGRectMake(0, (50 + 24) * accountSacle + 13, DMDeviceWidth / 2, 18) labelColor:UIColorFromRGB(0xfc6f57) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
        _coverTwoLabel.backgroundColor = UIColorFromRGB(0xffffff);
        _coverTwoLabel.font = FONT_Light(17.f);
        _coverTwoLabel.text = @"****";
    }
    return _coverTwoLabel;
}

- (UILabel *)holdAssetLabel {
    if (!_holdAssetLabel) {
        _holdAssetLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 2, 50*accountSacle, DMDeviceWidth / 2, 13) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _holdAssetLabel.font = FONT_Regular(12.f);
        _holdAssetLabel.text = @"持有资产";
    }
    return _holdAssetLabel;
}

- (UILabel *)holdAssetInfoLabel {
    if (!_holdAssetInfoLabel) {
        _holdAssetInfoLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 2, (50 + 24) * accountSacle + 13, DMDeviceWidth / 2, 18) labelColor:UIColorFromRGB(0xfc6f57) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
        _holdAssetInfoLabel.font = FONT_Light(17.f);
        _holdAssetInfoLabel.backgroundColor = UIColorFromRGB(0xffffff);
        _holdAssetInfoLabel.text = @"0.00";
    }
    return _holdAssetInfoLabel;
}

- (UILabel *)coverThreeLabel {
    if (!_coverThreeLabel) {
        _coverThreeLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 2, (50 + 24) * accountSacle + 13, DMDeviceWidth / 2, 18) labelColor:UIColorFromRGB(0xfc6f57) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
        _coverThreeLabel.backgroundColor = UIColorFromRGB(0xffffff);
        _coverThreeLabel.font = FONT_Light(17.f);
        _coverThreeLabel.text = @"****";
    }
    return _coverThreeLabel;
}

- (UILabel *)frozenAmountLabel {
    if (!_frozenAmountLabel) {
        _frozenAmountLabel = [UILabel createLabelFrame:CGRectMake(0, 50*accountSacle, 0, 13) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _frozenAmountLabel.font = FONT_Regular(12.f);
        _frozenAmountLabel.hidden = YES;
        _frozenAmountLabel.text = @"冻结中（元）";
    }
    return _frozenAmountLabel;
}

- (UILabel *)frozenAmountInfoLabel {
    if (!_frozenAmountInfoLabel) {
        _frozenAmountInfoLabel = [UILabel createLabelFrame:CGRectMake(0, (50 + 24) * accountSacle + 13, 0, 18) labelColor:UIColorFromRGB(0xfc6f57) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
        _frozenAmountInfoLabel.font = FONT_Light(17.f);
        _frozenAmountInfoLabel.backgroundColor = UIColorFromRGB(0xffffff);
        _frozenAmountInfoLabel.text = @"0.00";
        _frozenAmountInfoLabel.hidden = YES;
    }
    return _frozenAmountInfoLabel;
}

- (UILabel *)frozenLabel {
    if (!_frozenLabel) {
        _frozenLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 2, (50 + 24) * accountSacle + 13, DMDeviceWidth / 2, 18) labelColor:UIColorFromRGB(0xfc6f57) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
        _frozenLabel.backgroundColor = UIColorFromRGB(0xffffff);
        _frozenLabel.font = FONT_Light(17.f);
        _frozenLabel.text = @"****";
        _frozenLabel.hidden = YES;

    }
    return _frozenLabel;
}

- (UIButton *)withDrawalButton {
    UIImage *withDrawalImage = [UIImage imageNamed:@"tixian_button"];
    if (!_withDrawalButton) {
        _withDrawalButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_withDrawalButton setFrame:CGRectMake(26, (50 + 24 + 31) * accountSacle + 13 + 18, withDrawalImage.size.width, withDrawalImage.size.height)];
        [_withDrawalButton setBackgroundImage:withDrawalImage forState:(UIControlStateNormal)];
        [_withDrawalButton setTitle:@"提现" forState:(UIControlStateNormal)];
        [_withDrawalButton setTitleColor:UIColorFromRGB(0xffa190) forState:(UIControlStateNormal)];
        _withDrawalButton.titleLabel.font = FONT_Regular(15.f);
        [_withDrawalButton addTarget:self action:@selector(accountWithDrawal:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _withDrawalButton;
}

- (UIButton *)topUpButton {
    UIImage *topUpImage = [UIImage imageNamed:@"chongzhi_button"];
    if (!_topUpButton) {
        _topUpButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _topUpButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_topUpButton setFrame:CGRectMake(DMDeviceWidth - 26 - topUpImage.size.width, (50 + 24 + 31) * accountSacle + 13 + 18, topUpImage.size.width, topUpImage.size.height)];
        [_topUpButton setBackgroundImage:topUpImage forState:(UIControlStateNormal)];
        [_topUpButton setTitle:@"充值" forState:(UIControlStateNormal)];
        [_topUpButton setTitleColor:UIColorFromRGB(0xffffff) forState:(UIControlStateNormal)];
        _topUpButton.titleLabel.font = FONT_Regular(15.f);
        [_topUpButton addTarget:self action:@selector(accountTopUp:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _topUpButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, LJQ_VIEW_Height(self) - 1, DMDeviceWidth, 1)];
        _lineView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _lineView;
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    CGPoint center = self.showButton.center;
//    CGFloat r = self.showButton.frame.size.width * 2;
//    CGFloat newR = sqrt((center.x - point.x) * (center.x - point.x) + (center.y - point.y) * (center.y - point.y));
//    if (newR > r) {
//        return YES;
//    }else {
//        return YES;
//    }
//}

- (void)addAnimationToViewWithView:(UIView *)view {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    animation.subtype = kCATruncationMiddle;
    animation.type = @"rippleEffect";
    [view.layer addAnimation:animation forKey:nil];
}

- (void)scrollViewAddAnimationWithView:(UIView *)view {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    animation.subtype = kCATruncationMiddle;
    animation.type = kCATransitionReveal;
    [view.layer addAnimation:animation forKey:nil];
}
@end
