//
//  LJQOpenAccountVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQOpenAccountVC.h"
#import "LJQOpenAccCell.h"
#import "LJQOpenAccountCell.h"

#import "LJQConfirmWithDrawalVC.h"
@interface LJQOpenAccountVC ()

@end

static NSString *const LJQOpenAccIdentifier = @"LJQOpenAccCell";
static NSString *const LJQOpenAccountIdentifier = @"LJQOpenAccountVCCell";
@implementation LJQOpenAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //设置开户行
    
    [self.tableView registerClass:[LJQOpenAccountCell class] forCellReuseIdentifier:LJQOpenAccountIdentifier];
    [self.tableView registerClass:[LJQOpenAccCell class] forCellReuseIdentifier:LJQOpenAccIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
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

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 280 * (SCREENWIDTH - 40) / 668 + 32;
    }else {
        return 210;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LJQOpenAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:LJQOpenAccountIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        LJQOpenAccCell *cell = [tableView dequeueReusableCellWithIdentifier:LJQOpenAccIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.confirmBK = ^(UIButton *sender) {
            [self.navigationController pushViewController:[[LJQConfirmWithDrawalVC alloc] init] animated:YES];
        };
        return cell;
    }
}

@end
