//
//  DMCreditTransferViewController.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMCreditTransferViewController.h"
#import "DMCreditTransferView.h"
#import "DMCreditRequestManager.h"
#import "DMWebViewController.h"
@interface DMCreditTransferViewController ()

@property (nonatomic, strong) DMCreditTransferView *transferView;

@end

@implementation DMCreditTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.img.hidden = YES;
    self.title = @"确认转让";
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f9);
    [self.view addSubview:self.transferView];
    
    self.transferView.transferModel = self.transferModel;

    
    __weak __typeof(self) weakSelf = self;
    self.transferView.TransferAction = ^{
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [[DMCreditRequestManager manager] startCreditTransferInvestId:weakSelf.transferModel.INVEST_ID Success:^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if (weakSelf.TransferCompletion) {
                    weakSelf.TransferCompletion();
                }
            });
        } failed:^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    };
    
    self.transferView.ProtocolAction = ^{
        [weakSelf getWebViewWithUrl:[NSString stringWithFormat:@"%@%@",weburl,@"mzc/help/protocol/cjfxtsh?fromapp=1"] Title:@"风险提示函" Type:@""];
    };
}
- (void)getWebViewWithUrl:(NSString *) url Title:(NSString *)title Type:(NSString *)type{
    DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
    chargeVC.title = title;
    chargeVC.type = type;
    chargeVC.webUrl = url;
    [self.navigationController pushViewController:chargeVC animated:YES];
}


- (DMCreditTransferView *)transferView{
    if (!_transferView) {
        self.transferView = [[DMCreditTransferView alloc] initWithFrame:CGRectMake(0, 15, DMDeviceWidth, 400)];
        _transferView.backgroundColor = [UIColor whiteColor];
    }
    return _transferView;
}

@end
