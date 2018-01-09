//
//  DMRobtCell.m
//  豆蔓理财
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobtCell.h"
#import <SDWebImage/UIImage+GIF.h>
#import "DMRobtOpeningModel.h"
@interface DMRobtCell ()

@property (nonatomic, strong)UIImageView *pitcureView;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *personCountLabel;
@property (nonatomic, strong)UILabel *countdownLabel;
@property (nonatomic, strong)UILabel *numberLabel;

@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger count;


@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UILabel *tittle;
@end

@implementation DMRobtCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self.contentView addSubview:self.pitcureView];
        [self.contentView addSubview:self.webView];
        [self.webView addSubview:self.timeLabel];
        [self.webView addSubview:self.personCountLabel];
        [self.webView addSubview:self.countdownLabel];
        [self.webView addSubview:self.numberLabel];
       // [self.timer fire];
        [self.webView addSubview:self.backBtn];
        [self.webView addSubview:self.tittle];
    }
    return self;
}


- (void)setOpenModel:(DMRobtOpeningModel *)openModel {
    if (_openModel != openModel) {
        _openModel = openModel;
    }
    
    
    
    if ([_openModel.saleStatus isEqualToString:@"1"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"可加入" ofType:@"gif"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        
        self.count = [_openModel.surplusTime integerValue];
        if (self.count > 0) {
            [self.timer fire];
        }
    }else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"已结束" ofType:@"gif"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
    NSString *string = [NSString stringWithFormat:@"%@/%@",isOrEmpty(_openModel.subNum) ? @"50" : _openModel.subNum,isOrEmpty(_openModel.joinTimes) ? @"50" : _openModel.joinTimes];
    if ([_openModel.subNum isEqualToString:_openModel.joinTimes]) {
        self.personCountLabel.text = string;
    }
    self.personCountLabel.attributedText = [self StringChangeAttributeWithString:string rangeString:@"/"];
    
    
}

- (NSMutableAttributedString *)StringChangeAttributeWithString:(NSString *)string rangeString:(NSString *)rangString{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:rangString];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xfefeff)} range:NSMakeRange(0, range.location)];
    return attributeStr;
}

- (UIImageView *)pitcureView {
    if (!_pitcureView) {
        _pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceWidth * 494 / 750)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"可加入" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        _pitcureView.image = image;
    }
    return _pitcureView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceWidth * 494 / 750)];
        _webView.scalesPageToFit = YES;
        _webView.scrollView.scrollEnabled = NO;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"可加入" ofType:@"gif"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        [_webView reload];
    }
    return _webView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel createLabelFrame:CGRectMake(12, 72, 100, 15) labelColor:UIColorFromRGB(0xfefeff) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
        _timeLabel.text = @"00:00:00";
    }
    return _timeLabel;
}

- (UILabel *)countdownLabel {
    if (!_countdownLabel) {
        _countdownLabel = [UILabel createLabelFrame:CGRectMake(12, 90, 100, 15) labelColor:UIColorFromRGB(0x84a6ea) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
        _countdownLabel.text = @"开放倒计时";
    }
    return _countdownLabel;
}

- (UILabel *)personCountLabel {
    if (!_personCountLabel) {
        _personCountLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth - 12 - 100, 72, 100, 15) labelColor:UIColorFromRGB(0x84a6ea) textAlignment:(NSTextAlignmentRight) textFont:14.f];
        _personCountLabel.text = @"--/--";
    }
    return _personCountLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth - 12 - 100, 90, 100, 15) labelColor:UIColorFromRGB(0x84a6ea) textAlignment:(NSTextAlignmentRight) textFont:14.f];
        _numberLabel.text = @"剩余人数";
    }
    return _numberLabel;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(daojishiEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)daojishiEvent {
    self.count--;
    
    if (self.count == 0) {
        return;
    }
    NSInteger hour = self.count / 3600;
    NSInteger minute = (self.count - hour * 3600) / 60;
    NSInteger second = (self.count - 3600 * hour - 60 * minute);
    self.timeLabel.text = [NSString stringWithFormat:@"%ld:%ld:%ld",hour,minute,second];
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(20, 30, 22/2, 40/2);
        [_backBtn setBackgroundImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected ];
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_backBtn addTarget: self action:@selector(robotBackClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)tittle {
    if (!_tittle) {
        _tittle = [UILabel createLabelFrame:CGRectMake((DMDeviceWidth - 200) / 2, 30, 200, 20) labelColor:UIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) textFont:18.f];
        _tittle.text = @"小豆机器人";
    }
    return _tittle;
}

- (void)robotBackClick:(UIButton *)sender {
    !self.robotBackAction ? : self.robotBackAction();
}

- (void)dealloc {
    [self.timer invalidate];
}

@end
