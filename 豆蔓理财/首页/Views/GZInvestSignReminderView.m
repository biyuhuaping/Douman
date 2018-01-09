//
//  GZInvestSignReminderView.m
//  豆蔓理财
//
//  Created by armada on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZInvestSignReminderView.h"

#import "UIButton+EnlargeTouchArea.h"

@interface GZInvestSignReminderView()

/** 提示框 */
@property(nonatomic, strong) UIView *alertView;
/** "提示"标题 */
@property(nonatomic, strong) UILabel *reminderTitleLabel;
/** 提示内容 */
@property(nonatomic, strong) UILabel *reminderContentLabel;
/** 签约协议 */
@property(nonatomic, strong) UILabel *protocolLabel;
/** 协议确认按钮 */
@property(nonatomic, strong) UIButton *confirmSignBtn;
/** 取消按钮 */
@property(nonatomic, strong) UIButton *cancelBtn;
/** 签约按钮 */
@property(nonatomic, strong) UIButton *signBtn;
/** 关闭按钮 */
@property(nonatomic, strong) UIButton *closeBtn;

@property(nonatomic, weak) id<GZInvestSignSkipDelegate> delegate;

@end

@implementation GZInvestSignReminderView

static GZInvestSignReminderView *singltonView;

#pragma mark - class Method

+ (void)showPopviewToView:(UIView *)view{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(singltonView == nil) {
            singltonView = [[GZInvestSignReminderView alloc]initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64-49)];
        }
    });
    
    [view addSubview:singltonView];
}

+ (void)hidePopview {
    
    singltonView.confirmSignBtn.selected = YES;
    
    [singltonView removeFromSuperview];
}

+ (void)setDelegateOfSingletonWith:(id<GZInvestSignSkipDelegate>)delegate {

    singltonView.delegate = delegate;
}
                  
#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.confirmSignBtn.selected = YES ;
        
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
        
        [self.signBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.signBtn setTitle:@"确定" forState:UIControlStateHighlighted];
        
        [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateHighlighted];
        
    }
    return self;
}

#pragma mark - Lazy Loading

- (UIView *)alertView {
    
    if (!_alertView) {
        
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 160)];
        _alertView.center = self.center;
        _alertView.layer.cornerRadius = 8.0f;
        _alertView.layer.masksToBounds = YES;
        
        _alertView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_alertView];
    }
    return _alertView;
}

- (UILabel *)reminderTitleLabel {
    
    if (!_reminderTitleLabel) {
        
        _reminderTitleLabel = [[UILabel alloc] init];
        [self.alertView addSubview:_reminderTitleLabel];
        [_reminderTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertView).offset(16);
            make.centerX.equalTo(self.alertView);
        }];
        [_reminderTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [_reminderTitleLabel setTextColor:UIColorFromRGB(0x595757)];
        _reminderTitleLabel.text = @"提示";
    }
    return _reminderTitleLabel;
}

- (UILabel *)reminderContentLabel {
    
    if (!_reminderContentLabel) {
        
        _reminderContentLabel = [[UILabel alloc] init];
        [self.alertView addSubview:_reminderContentLabel];
        [_reminderContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reminderTitleLabel.mas_bottom).offset(22);
            make.centerX.equalTo(self.alertView);
        }];
        [_reminderContentLabel setFont:[UIFont systemFontOfSize:14]];
        [_reminderContentLabel setTextColor:UIColorFromRGB(0xfd9726)];
        _reminderContentLabel.text = @"投资前，需要您的自动投标授权";
    }
    return _reminderContentLabel;
}

- (UILabel *)protocolLabel {
    
    if (!_protocolLabel) {
        
        _protocolLabel = [[UILabel alloc] init];
        [self.alertView addSubview:_protocolLabel];
        [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reminderContentLabel.mas_bottom).offset(18);
            make.centerX.equalTo(self.alertView).offset(10);
        }];
        
        NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:@"阅读并同意" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x8C8C8C)}];
        
        [mutableAttributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"<自动投标授权协议>" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x1bb182)}]];
        
        _protocolLabel.attributedText = mutableAttributedStr;
        _protocolLabel.enabledTapEffect = NO;
        
        __weak __typeof(self) weakSelf = self;
        [_protocolLabel DM_addAttributeTapActionWithStrings:@[@"<自动投标授权协议>"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            //跳转投标授权协议
            [strongSelf.delegate skipToAutoSignAuthProtocol];
        }];
        
    }
    return _protocolLabel;
}

- (UIButton *)confirmSignBtn {
    
    if (!_confirmSignBtn) {
        
        _confirmSignBtn = [[UIButton alloc] init];
        [self.alertView addSubview:_confirmSignBtn];
        [_confirmSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.protocolLabel.mas_left).offset(-5);
            make.centerY.equalTo(self.protocolLabel);
            make.width.mas_equalTo(@12);
            make.height.mas_equalTo(@12);
        }];
        [_confirmSignBtn setBackgroundImage:[UIImage imageNamed:@"勾选框-默认"] forState:UIControlStateNormal];
        [_confirmSignBtn setBackgroundImage:[UIImage imageNamed:@"勾选框-默认"] forState:UIControlStateHighlighted];
        [_confirmSignBtn setBackgroundImage:[UIImage imageNamed:@"勾选框-选中"] forState:UIControlStateSelected];
        _confirmSignBtn.selected = YES;
        [_confirmSignBtn addTarget:self action:@selector(confirmSignBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmSignBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    }
    return _confirmSignBtn;
}

- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        
        _cancelBtn = [[UIButton alloc] init];
        [self.alertView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertView);
            make.bottom.equalTo(self.alertView);
            make.width.mas_equalTo(@(self.alertView.frame.size.width/2));
            make.height.mas_equalTo(@35);
        }];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_cancelBtn setTitleColor:UIColorFromRGB(0x929397) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromRGB(0x929397) forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(closeReminderView) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _cancelBtn.layer.borderWidth = 0.5f;
    }
    return _cancelBtn;
}

- (UIButton *)signBtn {
    
    if (!_signBtn) {
        
        _signBtn = [[UIButton alloc] init];
        [self addSubview:_signBtn];
        [_signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.alertView);
            make.bottom.equalTo(self.alertView);
            make.width.mas_equalTo(@(self.alertView.frame.size.width/2));
            make.height.mas_equalTo(@35);
        }];
        [_signBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_signBtn setTitleColor:UIColorFromRGB(0xfd9726) forState:UIControlStateNormal];
        [_signBtn setTitleColor:UIColorFromRGB(0xfd9726) forState:UIControlStateHighlighted];
        [_signBtn addTarget:self action:@selector(signBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _signBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _signBtn.layer.borderWidth = 0.5f;
    }
    return _signBtn;
}

- (UIButton *)closeBtn {
    
    if (!_closeBtn) {
        
        _closeBtn = [[UIButton alloc] init];
        [self.alertView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertView).offset(5);
            make.right.equalTo(self.alertView).offset(-5);
            make.width.mas_equalTo(@18);
            make.height.mas_equalTo(@18);
        }];
        
        [_closeBtn addTarget:self action:@selector(closeReminderView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

#pragma mark - Button Click

- (void)closeReminderView {
    singltonView.confirmSignBtn.selected = YES;
    [self removeFromSuperview];
}

- (void)signBtnClicked:(UIButton *)sender {
    
    if (self.confirmSignBtn.selected) {
        
        [GZInvestSignReminderView hidePopview];
        
        [self.delegate skipToDetailOfInvestSign];
        
    }else {
     
        ShowMessage(@"请阅读并同意<自动投标授权协议>");
    }
}

- (void)confirmSignBtnClicked:(UIButton *)sender {
    self.confirmSignBtn.selected = !self.confirmSignBtn.selected;
}

@end
