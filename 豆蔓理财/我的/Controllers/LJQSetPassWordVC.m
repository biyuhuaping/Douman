//
//  LJQSetPassWordVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQSetPassWordVC.h"
#import "LJQTradePassWordVC.h"
#import "LJQModifyLoginPWdVC.h"
#import "LLLockViewController.h"
#import "DMModifytransactionpassword ViewController.h"
#import "DMCreditRequestManager.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"


@interface LJQSetPassWordVC ()

@property (nonatomic, strong)NSArray *tittleArr;
@property (nonatomic, strong) UISwitch *switchBar;

@property (nonatomic, assign)BOOL isSetTrade;

@end

@implementation LJQSetPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"密码设置";
    [self isTradePassWord];
    self.tableView.rowHeight = 44;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"systemcell"];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (Lock) {
        [self.switchBar setOn:YES animated:YES];
    }else{
        [self.switchBar setOn:NO animated:YES];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tittleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemcell" forIndexPath:indexPath];
    cell.preservesSuperviewLayoutMargins = NO;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.tittleArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.tittleArr[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 2) {
        cell.accessoryView = self.switchBar;
    }else
    if (indexPath.row == 0 || indexPath.row == 3) {
         cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"修改"]];
    }
    else {
        if (self.isSetTrade == YES) {
             cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"修改"]];
        }else {
             cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingup"]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            //修改登陆密码
             [self.navigationController pushViewController:[[LJQModifyLoginPWdVC alloc] init] animated:YES];
            
        }
            break;
        case 1:
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[DMCreditRequestManager manager] replacePassWordSuccess:^(NSString *argument) {
                DMWebViewController *drawCash = [[DMWebViewController alloc] init];
                drawCash.title = @"交易密码";
                drawCash.parameter = argument;
                drawCash.webUrl = [[DMWebUrlManager manager] getsumapayUrl];
                [self.navigationController pushViewController:drawCash animated:YES];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } failed:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        }
            break;
        case 2:
        {
            //设置手势密码
            [self registePassWord];
        }
            break;
        case 3:
        {
            //修改手势密码
            [self changeRegusterPassWord];
        }
            break;
        case 4:
        {
            //修改交易密码
            
        }
            break;
            
        default:
            break;
    }
}

- (void)registePassWord{
    if (Lock) {
        
    }else{
        LLLockViewController *lockVC = [[LLLockViewController alloc] initWithType:LLLockViewTypeCreate];
        lockVC.leftType = @"return";
        [self.navigationController pushViewController:lockVC animated:YES];
    }
}

- (void)changeRegusterPassWord{
    if (Lock) {
        LLLockViewController *lockVC = [[LLLockViewController alloc] initWithType:LLLockViewTypeModify];
        lockVC.leftType = @"return";
        [self.navigationController pushViewController:lockVC animated:YES];
    }else{
        ShowMessage(@"请先设置手势密码");
    }
}

- (void)switchAction:(UISwitch *)switchBar{
    if (switchBar.on) {
        LLLockViewController *lockVC = [[LLLockViewController alloc] initWithType:LLLockViewTypeCreate];
        lockVC.leftType = @"return";
        [self.navigationController pushViewController:lockVC animated:YES];
    }else{
        LLLockViewController *lockVC = [[LLLockViewController alloc] initWithType:LLLockViewTypeClean];
        lockVC.leftType = @"return";
        [self.navigationController pushViewController:lockVC animated:YES];
    }
}


- (NSArray *)tittleArr {
    if (!_tittleArr) {
        self.tittleArr = @[@"登录密码",@"交易密码",@"手势密码",@"修改手势密码"];
    }
    return _tittleArr;
}

- (UISwitch *)switchBar{
    if (_switchBar == nil) {
        self.switchBar = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [_switchBar addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBar;
}

//是否设置交易密码
- (void)isTradePassWord {
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager LJQIsSetTradePassWordSuccessblock:^(NSString *result) {
        if ([result isEqualToString:@"true"]) {
            //设置过
            self.isSetTrade = YES;
        }else {
            self.isSetTrade = NO;
        }
        [self.tableView reloadData];
    } faild:^{
        
    }];
}



@end
