//
//  DMMyAccountInfoVC.m
//  豆蔓理财
//
//  Created by bluesky on 2017/8/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMMyAccountInfoVC.h"
#import "LJQUserInfoVC.h"
#import "DMPreservationRecordVC.h"
#import "DMWebViewController.h"
#import "RiskMeasurementVC.h"
#import "DMAccountInfoCell.h"

#import "DMWebUrlManager.h"
#import "LJQUserInfoModel.h"
@interface DMMyAccountInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *InfoTextArr;
@property (nonatomic, strong)LJQUserInfoModel *userModel;
@property (nonatomic, strong)NSArray<NSString *> *nameOfJumpVCArr;

@end

static NSString *const accountInfoIdentifer = @"DMAccountInfoCell";
@implementation DMMyAccountInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户信息";
    [self.view addSubview:self.tableView];
    
    [self getMyAccountInfoMessage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.InfoTextArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMAccountInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:accountInfoIdentifer forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellName = self.InfoTextArr[indexPath.row];
    if (indexPath.row == 2) {
        if ([self.userModel.signFlag isEqualToString:@"1"]) {
            cell.showText = @"已开启";
            cell.textStyle = showTextStyleWithColor;
        }else {
            cell.showText = @"未开启";
            cell.textStyle = showTextStyleNone;
        }
    }
    if (indexPath.row == 3) {
        if (!isOrEmpty(self.userModel.investType) | [self.userModel.investType isEqualToString:@"Null"]) {
            cell.showText = self.userModel.investType;
            cell.textStyle = showTextStyleWithColor;
        }else {
            cell.showText = @"未测评";
            cell.textStyle = showTextStyleNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        DMWebViewController *jumpVC = [[DMWebViewController alloc] init];
        jumpVC.title = @"自动投标签约";
        jumpVC.webUrl = [[DMWebUrlManager manager] getAutoMakeABid];
        [self.navigationController pushViewController:jumpVC animated:YES];
    }else {
        NSString *vcString = self.nameOfJumpVCArr[indexPath.row];
        Class vcClass = NSClassFromString(vcString);
        DMBaseViewController *jumpVC = [[vcClass alloc] init];
        if (indexPath.row == 3) {
            jumpVC.title = @"风险测评";
        }
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
}

//获取个人信息
- (void)getMyAccountInfoMessage {
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager LJQUserInfoDataSourceSuccessBlock:^(NSInteger index, LJQUserInfoModel *model, NSString *message) {
       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.userModel = model;
        [self.tableView reloadData];
    } faild:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DMAccountInfoCell class] forCellReuseIdentifier:accountInfoIdentifer];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray *)InfoTextArr {
    if (!_InfoTextArr) {
        _InfoTextArr = [@[@"账户详情",@"保全记录",@"自动投标",@"风险测评"] copy];
    }
    return _InfoTextArr;
}

- (NSArray<NSString *> *)nameOfJumpVCArr {
    if (!_nameOfJumpVCArr) {
        _nameOfJumpVCArr = [@[@"LJQUserInfoVC",@"DMPreservationRecordVC",@"",@"RiskMeasurementVC"] copy];
    }
    return _nameOfJumpVCArr;
}
@end
