//
//  DMCreditManageViewController.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/2.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMCreditManageViewController.h"
#import "ManageMenuButton.h"
#import "DMCreditManageCell.h"
#import "DMRevokeToastView.h"
#import "DMCreditTransferViewController.h"
#import "DMCreditRequestManager.h"
#import "DMTransferContractViewController.h"

@interface DMCreditManageViewController ()<DMCreditManageCellDelegate,ManageMenuButtonDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *footlabel;

@property (nonatomic, strong) ManageMenuButton *menuButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DMRevokeToastView *revokeView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *transferId;

@end

@implementation DMCreditManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"债权管理";
    self.img.hidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f9);

    self.status = @"";
    self.manageType = kCanTransfer;
    
    [self.view addSubview:self.menuButton];
    [self.view addSubview:self.tableView];

    [[UIApplication sharedApplication].keyWindow addSubview:self.revokeView];
    self.revokeView.hidden = YES;
    
    [self requestDataWithStatus:@""];
    

}

- (void)requestDataWithStatus:(NSString *)status{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DMCreditRequestManager manager] getCreditTransferStatus:status Success:^(NSArray<DMCreditTransferModel *> *listModel) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.dataArray = [NSMutableArray arrayWithArray:listModel];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self setFootView];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)setFootView{
    if (self.dataArray.count==0) {
        self.tableView.tableFooterView = self.footlabel;
    }else{
        self.tableView.tableFooterView = [UIView new];
    }
}

- (UILabel *)footlabel{
    if (_footlabel == nil) {
        self.footlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 200)];
        _footlabel.text = @"没有相关数据";
        _footlabel.textColor = UIColorFromRGB(0x787878);
        _footlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _footlabel;
}

- (ManageMenuButton *)menuButton{
    if (_menuButton == nil) {
        self.menuButton = [[ManageMenuButton alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 44)];
        _menuButton.backgroundColor = UIColorFromRGB(0xffffff);
        _menuButton.delegate = self;
    }
    return _menuButton;
}

- (void)selectButtonWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
            self.status = @"";
            self.manageType = kCanTransfer;
            break;
        case 1:
            self.status = @"OPEN";
            self.manageType = kTransferIng;
            break;
        case 2:
            self.status = @"FINISHED";
            self.manageType = kHadtransfer;
            break;
        default:
            break;
    }
    [self requestDataWithStatus:self.status];
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, DMDeviceWidth, DMDeviceHeight-44-64) style:UITableViewStylePlain];
        [_tableView registerClass:[DMCreditManageCell class] forCellReuseIdentifier:@"DMCreditManageCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf5f5f9);
        _tableView.rowHeight = 12+115;
        _tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestDataWithStatus:self.status];
        }];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMCreditManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DMCreditManageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.manageType = self.manageType;
    cell.tag = indexPath.row;
    cell.delegate = self;
    if (self.dataArray.count > indexPath.row) {
        cell.transferModel = self.dataArray[indexPath.row];
    }
    return cell;
}

//撤销
- (void)revokeCreditWithIndex:(NSInteger)index{
    [self.revokeView show];
    DMCreditTransferModel *transferModel = self.dataArray[index];
    self.transferId = transferModel.transferId;
    
    __weak __typeof(self) weakSelf = self;
    self.revokeView.RevokeAction = ^{
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [[DMCreditRequestManager manager] revokeCreditTransferId:weakSelf.transferId Success:^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.dataArray removeObjectAtIndex:index];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            NSArray *indexPaths = @[indexPath];
            [weakSelf.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
            [weakSelf setFootView];
            [weakSelf.tableView reloadData];
        } failed:^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    };
}

// 转让
- (void)transferCreditWithIndex:(NSInteger)index{
    DMCreditTransferViewController *transferVC = [[DMCreditTransferViewController alloc] init];
    transferVC.transferModel = self.dataArray[index];
    [self.navigationController pushViewController:transferVC animated:YES];
    
    transferVC.TransferCompletion = ^{
        [self.dataArray removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        NSArray *indexPaths = @[indexPath];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        [self setFootView];
        [self.tableView reloadData];
    };
}

// 合同
- (void)contractWithIndex:(NSInteger)index{
    DMTransferContractViewController *contractVC = [[DMTransferContractViewController alloc] init];
    DMCreditTransferModel *model = self.dataArray[index];
    contractVC.assignId = model.transferId;
    [self.navigationController pushViewController:contractVC animated:YES];
}
- (DMRevokeToastView *)revokeView{
    if (!_revokeView) {
        self.revokeView = [[DMRevokeToastView alloc] initWithFrame:DMDeviceFrame];
    }
    return _revokeView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}
@end
