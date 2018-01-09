//
//  LJQTopUpFinishVC.m
//  豆蔓理财
//
//  Created by mac on 2017/5/9.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQTopUpFinishVC.h"
#import "LJQTransactionDetailVC.h"
#import "LJQWithDrawalVC.h"
#import "DMLoginRequestManager.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"
@interface LJQTopUpFinishVC ()

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIImageView *pitcureView;
@property (nonatomic, strong)UILabel *resultLabel;
@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;

@property (nonatomic, assign)NSInteger flag; //标识
@property (nonatomic, copy)NSString *withDrawalString; //剩余金额
@end

@implementation LJQTopUpFinishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self requestMineData];
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.bottomView];
    
    [self.bottomView addSubview:self.pitcureView];
    [self.bottomView addSubview:self.resultLabel];
    [self.bottomView addSubview:self.messageLabel];
    [self.bottomView addSubview:self.leftButton];
    [self.bottomView addSubview:self.rightButton];
    
   
}

- (void)setLJQActionType:(ActionType)LJQActionType {
     UIImage *image1 = [UIImage imageNamed:@"成功"];
    switch (LJQActionType) {
        case ActionTypeWithTopUpSuccess:
        {
            [self.pitcureView setImage:[UIImage imageNamed:@"成功"]];
            self.resultLabel.text = @"充值成功";
            self.messageLabel.text = @"您成功充值100.00元";
            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"继续充值"] forState:(UIControlStateNormal)];
             [self.rightButton setBackgroundImage:[UIImage imageNamed:@"查看余额"] forState:(UIControlStateNormal)];
            self.flag = 1;
        }
            break;
            case ActionTypeWithTopUpFaild:
        {
           
            UIImage *image = [UIImage imageNamed:@"继续充值"];
            [self.pitcureView setImage:[UIImage imageNamed:@"失败"]];
            self.resultLabel.text = @"充值失败";
            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"继续充值"] forState:(UIControlStateNormal)];
            [self.leftButton setFrame:CGRectMake( (DMDeviceWidth - image.size.width) / 2, 31 + image1.size.height + 30 + 31 + 15 + 48, image.size.width, image.size.height)];
            [self.rightButton setHidden:YES];
            
             self.flag = 2;
        }
            break;
            case ActionTypeWithWithDrawalSuccess:
        {
            [self.pitcureView setImage:[UIImage imageNamed:@"成功"]];
            self.resultLabel.text = @"提现成功";
            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"继续提现"] forState:(UIControlStateNormal)];
            [self.rightButton setBackgroundImage:[UIImage imageNamed:@"查看提现记录"] forState:(UIControlStateNormal)];
            
             self.flag = 3;
        }
            break;
            case ActionTypeWithWithDrawalFaild:
        {
            UIImage *image = [UIImage imageNamed:@"继续充值"];
            [self.pitcureView setImage:[UIImage imageNamed:@"失败"]];
            self.resultLabel.text = @"提现失败";
            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"继续提现"] forState:(UIControlStateNormal)];
            [self.leftButton setFrame:CGRectMake( (DMDeviceWidth - image.size.width) / 2, 31 + image1.size.height + 30 + 31 + 15 + 48, image.size.width, image.size.height)];
            [self.rightButton setHidden:YES];
            
             self.flag = 4;
        }
            break;
            
        default:
            break;
    }
}

- (void)setMessageString:(NSString *)messageString {
    _messageString = messageString;
     UIImage *image = [UIImage imageNamed:@"成功"];
    CGFloat heiht = [self returenLabelHeight:_messageString size:CGSizeMake(DMDeviceWidth - 30, 60) fontsize:14 isWidth:NO];
    [self.messageLabel setFrame:CGRectMake(15, 31 + image.size.height + 61, DMDeviceWidth - 30, heiht)];
    self.messageLabel.text = _messageString;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, DMDeviceWidth, 240)];
        _bottomView.layer.cornerRadius = 6;
        _bottomView.layer.masksToBounds = YES;
        _bottomView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _bottomView;
}

- (UIImageView *)pitcureView {
    UIImage *image = [UIImage imageNamed:@"成功"];
    if (!_pitcureView) {
        _pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake((DMDeviceWidth - image.size.width) / 2, 31, image.size.width, image.size.height)];
    }
    return _pitcureView;
}

- (UILabel *)resultLabel {
    UIImage *image = [UIImage imageNamed:@"成功"];
    if (!_resultLabel) {
        _resultLabel = [UILabel createLabelFrame:CGRectMake(0, 31 + image.size.height + 12, DMDeviceWidth, 18) labelColor:UIColorFromRGB(0x1bb182) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
    }
    return _resultLabel;
}

- (UILabel *)messageLabel {
    UIImage *image = [UIImage imageNamed:@"成功"];
    if (!_messageLabel) {
        _messageLabel = [UILabel createLabelFrame:CGRectMake(0, 31 + image.size.height + 61, DMDeviceWidth, 15) labelColor:UIColorFromRGB(0x505050) textAlignment:(NSTextAlignmentCenter) textFont:14.f];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIButton *)leftButton {
    UIImage *image1 = [UIImage imageNamed:@"成功"];
    UIImage *image = [UIImage imageNamed:@"继续充值"];
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_leftButton setFrame:CGRectMake(59, 31 + image1.size.height + 30 + 31 + 15 + 48, image.size.width, image.size.height)];
        [_leftButton addTarget:self action:@selector(jumpToGoGo:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    UIImage *image1 = [UIImage imageNamed:@"成功"];
    UIImage *image = [UIImage imageNamed:@"继续充值"];
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightButton setFrame:CGRectMake(DMDeviceWidth - image.size.width - 59, 31 + image1.size.height + 30 + 31 + 15 + 48, image.size.width, image.size.height)];
        [_rightButton addTarget:self action:@selector(backToGoGo:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightButton;
}

- (CGFloat)returenLabelHeight:(NSString *)string size:(CGSize)size fontsize:(NSInteger)font isWidth:(BOOL)isWidth{
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    if (isWidth == YES) {
        return rect.size.width;
    }else {
        return rect.size.height;
    }
}

- (void)jumpToGoGo:(UIButton *)sender {
    if (self.flag == 1 | self.flag == 2) {
        ShowMessage(@"继续充值");
    }else
    if (self.flag == 3 | self.flag == 4) {
        [self.tabBarController setSelectedIndex:2];
        [self.navigationController popToRootViewControllerAnimated:YES];
        LJQWithDrawalVC *withDrawal = [[LJQWithDrawalVC alloc] init];
        withDrawal.availableAmount = self.withDrawalString;
        [self.navigationController pushViewController:withDrawal animated:YES];
    }
}

- (void)backToGoGo:(UIButton *)sender {
    if (self.flag == 1) {
        [self.tabBarController setSelectedIndex:2];
        [self.navigationController popToRootViewControllerAnimated:YES];
        DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
        chargeVC.title = @"充值";
        chargeVC.type = @"charge";
        chargeVC.webUrl = [[DMWebUrlManager manager] getChargeUrl];
        [self.navigationController pushViewController:chargeVC animated:YES];
    }
    
    if (self.flag == 3) {
        [self.tabBarController setSelectedIndex:2];
        [self.navigationController popToRootViewControllerAnimated:YES];
        LJQTransactionDetailVC *detail = [[LJQTransactionDetailVC alloc] init];
        detail.selectType = @"WITHDRAW";
        [self.navigationController pushViewController:detail animated:YES];
    }
}


- (void)requestMineData {
    if (AccessToken) {
        LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
        [manager LJQRequestMineDataStringSuccessBlock:^(NSInteger index, LJQMineModel *mineModel) {
            if (index == 0) {
                self.withDrawalString = [self stringFormatterDecimalStyle:@(mineModel.availableAmount)];
                self.withDrawalString = [self returnDecimalString:self.withDrawalString];
            }else if (index == 1) {
                ShowMessage(@"未登录");
                [[DMLoginRequestManager manager] exit];
            }else {
                ShowMessage(@"获取用户信息失败");
                [[DMLoginRequestManager manager] exit];
            }
        } faildBlock:^{
            ShowMessage(@"请重新登录");
            [[DMLoginRequestManager manager] exit];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
