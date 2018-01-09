//
//  DMRobotHeaderView.m
//  豆蔓理财
//
//  Created by edz on 2017/8/2.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobotHeaderView.h"
#import "DMRobtOpeningModel.h"
#import <SDWebImage/UIImage+GIF.h>
@interface  DMRobotHeaderView ()<UIWebViewDelegate>

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

@implementation DMRobotHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pitcureView];
        [self addSubview:self.webView];
        [self.webView addSubview:self.timeLabel];
        [self.webView addSubview:self.personCountLabel];
        [self.webView addSubview:self.countdownLabel];
        [self.webView addSubview:self.numberLabel];
        // [self.timer fire];
//        [self.webView addSubview:self.backBtn];
//        [self.webView addSubview:self.tittle];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chagnebuttonTime) name:@"changebtnstatus" object:nil];
    }
    return self;
}

- (void)chagnebuttonTime {
    self.openModel.surplusTime = 0;
}


- (void)setOpenModel:(DMRobtOpeningModel *)openModel {
    if (_openModel != openModel) {
        _openModel = openModel;
    }
    if (openModel) {
        NSString *number;
        if (!isOrEmpty(_openModel.subNum) && !isOrEmpty(_openModel.joinTimes)) {
            number = [@([_openModel.joinTimes integerValue] - [_openModel.subNum integerValue]) stringValue];
        }
        NSString *string = [NSString stringWithFormat:@"%@/%@",isOrEmpty(_openModel.subNum) ? @"50" : number,isOrEmpty(_openModel.joinTimes) ? @"50" : _openModel.joinTimes];
        
        if ([_openModel.saleStatus isEqualToString:@"0"]) {
            
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"可加入" ofType:@"gif"];
            NSURL *url = [NSURL fileURLWithPath:path];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [_webView loadRequest:request];
            
            
            self.count = [_openModel.surplusTime integerValue] / 1000;
            [self.timer fire];
            self.personCountLabel.text = [NSString stringWithFormat:@"%@/%@",isOrEmpty(_openModel.joinTimes) ? @"50" : _openModel.joinTimes,isOrEmpty(_openModel.joinTimes) ? @"50" : _openModel.joinTimes];;
        }else if ([_openModel.saleStatus isEqualToString:@"1"]) {
            
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"可加入" ofType:@"gif"];
            NSURL *url = [NSURL fileURLWithPath:path];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [_webView loadRequest:request];
            self.timeLabel.text = @"00:00:00";
            [self.timer invalidate];
            self.timer = nil;
            if ([_openModel.subNum isEqualToString:_openModel.joinTimes]) {
                self.personCountLabel.text = string;
            }else {
                self.personCountLabel.attributedText = [self StringChangeAttributeWithString:string rangeString:@"/"];
            }
            
        }else {
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"已结束" ofType:@"gif"];
            NSURL *url = [NSURL fileURLWithPath:path];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [_webView loadRequest:request];
            
            self.timeLabel.text = @"00:00:00";
            //倒计时
            [self.timer invalidate];
            self.timer = nil;
            
            if ([_openModel.subNum isEqualToString:_openModel.joinTimes]) {
                self.personCountLabel.text = string;
            }else {
                self.personCountLabel.attributedText = [self StringChangeAttributeWithString:string rangeString:@"/"];
            }
        }
    }else{
        self.timeLabel.text = @"00:00:00";
        _personCountLabel.text = @"--/--";
        //倒计时
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (NSMutableAttributedString *)StringChangeAttributeWithString:(NSString *)string rangeString:(NSString *)rangString{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:rangString];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xfefeff)} range:NSMakeRange(0, range.location)];
    return attributeStr;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.pitcureView removeFromSuperview];
}

- (UIImageView *)pitcureView {
    if (!_pitcureView) {
        _pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceWidth * 494 / 750)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"可加入" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        _pitcureView.image = image;
        _pitcureView.userInteractionEnabled = YES;
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
        _webView.delegate = self;
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
    if (self.count < 1) {
        self.timeLabel.text = @"00:00:00";
        [self.timer invalidate];
        self.timer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeInvalidate" object:nil];
        
    }else {
        NSInteger hour = self.count / 3600;
        NSInteger minute = (self.count - hour * 3600) / 60;
        NSInteger second = (self.count) % 60;
        NSLog(@"----%@",[NSString stringWithFormat:@"%ld:%.2ld:%.2ld",(long)hour,(long)minute,(long)second]);
        self.timeLabel.text = [NSString stringWithFormat:@"%ld:%.2ld:%.2ld",(long)hour,(long)minute,(long)second];
    }
   
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(20, 30, 22/2, 40/2);
        [_backBtn setImage:[[[UIImage imageNamed:@"robotjiantou"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"robotjiantou"] forState:UIControlStateHighlighted];
        [_backBtn setImage:[UIImage imageNamed:@"robotjiantou"] forState:UIControlStateSelected ];
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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint center = self.backBtn.center;
    CGFloat r = self.backBtn.frame.size.height * 2;
    CGFloat newR = sqrt((center.x - point.x) * (center.x - point.x) + (center.y - point.y) * (center.y - point.y));
    if (newR > r) {
        return NO;
    }else {
        return YES;
    }
}

- (void)robotBackClick:(UIButton *)sender {
    !self.robotBackAction ? : self.robotBackAction();
}

- (void)dealloc {
    [self.timer invalidate];
}


@end
