//
//  DMHomeHeadView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/26.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMHomeHeadView.h"
#import "DMHomeBannerModel.h"


@interface DMHomeHeadView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UIImageView *noticeView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView1;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *loginBtn;

@end


@implementation DMHomeHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.cycleScrollView1];
        [self addSubview:self.noticeView];
        [self addSubview:self.lineView];
        [self addSubview:self.loginBtn];

        NSArray *titleArray = @[@"新手专享",@"安全保障",@"资金存管",@"优质资产"];
        NSArray *imageArray = @[@"home_new",@"home_safe",@"home_bank",@"home_asset"];
        for (int i = 0; i < titleArray.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i * DMDeviceWidth/4, BANNER_HEIGHT+40, DMDeviceWidth/4, 70);
            button.tag = i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth/4, 50)];
            imageview.image = [UIImage imageNamed:imageArray[i]];
            imageview.contentMode = UIViewContentModeCenter;
            [button addSubview:imageview];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, DMDeviceWidth/4, 40)];
            label.text = titleArray[i];
            label.textColor = DarkGray;
            label.font = FONT_Regular(11);
            label.textAlignment = NSTextAlignmentCenter;
            [button addSubview:label];
        }
    }
    return self;
}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        self.cycleScrollView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, DMDeviceWidth, BANNER_HEIGHT) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.tag = 0;
    }
    return _cycleScrollView;
}

- (UIImageView *)noticeView{
    if (!_noticeView) {
        self.noticeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, BANNER_HEIGHT, 40, 40)];
        _noticeView.contentMode = UIViewContentModeCenter;
        _noticeView.image = [UIImage imageNamed:@"home_notice"];
    }
    return _noticeView;
}

- (SDCycleScrollView *)cycleScrollView1{
    if (!_cycleScrollView1) {
        self.cycleScrollView1 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(30, BANNER_HEIGHT, DMDeviceWidth, 40) delegate:self placeholderImage:nil];
        _cycleScrollView1.backgroundColor = UIColorFromRGB(0xffffff);
        _cycleScrollView1.titleLabelTextColor = DarkGray;
        _cycleScrollView1.titleLabelTextFont = FONT_Light(12);
        _cycleScrollView1.titleLabelBackgroundColor = UIColorFromRGB(0xffffff);
        _cycleScrollView1.scrollDirection = UICollectionViewScrollDirectionVertical;
        _cycleScrollView1.onlyDisplayText = YES;
        _cycleScrollView1.tag = 1;
    }
    return _cycleScrollView1;
}

- (UIView *)lineView{
    if (!_lineView) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, BANNER_HEIGHT+39.5, DMDeviceWidth, 0.5)];
        _lineView.backgroundColor = MainLine;
    }
    return _lineView;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(DMDeviceWidth-40, 10, 40, 40);
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"home_login"] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}



#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView.tag == 0) {
        if (self.delegate) {
            [self.delegate didSelectBannerWithIndex:index];
        }
    }else{
        if (self.delegate) {
            [self.delegate didSelectNoticeWithIndex:index];
        }
    }
}


- (void)buttonAction:(UIButton *)button{
    if (self.delegate) {
        [self.delegate didSelectButtonWithIndex:button.tag];
    }
}

- (void)loginAction:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate loginAction];
    }
}

- (void)setBannerArray:(NSArray *)bannerArray{
    _bannerArray = [NSArray arrayWithArray:bannerArray];
    
    NSMutableArray *imagesURLStrings = [NSMutableArray arrayWithCapacity:0];
    [bannerArray enumerateObjectsUsingBlock:^(DMHomeBannerModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imagesURLStrings addObject:obj.THUMBNAILIMAGE];
    }];
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    
    if (AccessToken) {
        self.loginBtn.hidden = YES;
    }else{
        self.loginBtn.hidden = NO;
    }
}

- (void)setNoticeArray:(NSArray *)noticeArray{
    _noticeArray = [NSArray arrayWithArray:noticeArray];
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
    [noticeArray enumerateObjectsUsingBlock:^(DMHomeBannerModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArray addObject:obj.TITLE];
    }];
    _cycleScrollView1.titlesGroup = [titleArray copy];
}



@end
