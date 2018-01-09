//
//  LJQProductIntroductionvc.m
//  豆蔓理财
//
//  Created by mac on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQProductIntroductionvc.h"
#import "LJQProductInfoCell.h"

static NSString *const LJQProductIntroductionIdentifier = @"LJQProductInfoCell";
@interface LJQProductIntroductionvc ()

@property (nonatomic, strong)NSArray *ContentArr;

@property (nonatomic, strong)UIButton *sender;

@property (nonatomic, strong)NSArray *nameArr; //

@property (nonatomic, strong)NSArray *messageArr;

@end

@implementation LJQProductIntroductionvc

- (NSArray *)ContentArr {
    if (!_ContentArr) {
        self.ContentArr = @[];
    }
    return _ContentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *rateYear = [NSString stringWithFormat:@"%.1lf%%(不含加息)",self.assetRate];
    NSString *dayStr = [NSString stringWithFormat:@"%.0lf个月",self.assetDuration];
    
    if (self.assetRepaymentMethod == 0) {
        //等额本息
        self.nameArr = @[@"年化利率",@"投资期限",@"起投金额",@"收益结算",@"计息时间",@"提前结清",@"到期退出"];
        self.ContentArr = @[@" 结算日期\n以计息日为基准，每个自然月的当天为结算日\n(如遇当月无此日，则为当月最后一日)",@" 等额本息\n(计息日起每30天，返还当月本金和利息)"];
        self.messageArr = @[rateYear,dayStr,@"100元及其整数倍",@"",@[@"本期债权满标后，生成合同即计息"],@[@"当债权发生提前还款，则持有产品将进行提前结清操作———当月本息及剩余期限的本金将一次性进行结算，返回理财人账户。"],@[@"T + 7:产品到期后的7个工作日内，一次性返还理财用户(当月)本金和当月收益。",@"(以豆蔓智投打款时间为准)"]];
    }else {
        //按月付息到本
        self.nameArr = @[@"年化利率",@"投资期限",@"起投金额",@"收益结算",@"计息时间",@"到期退出"];
        self.ContentArr = @[@" 结算日期\n以计息日为基准，每个自然月的当天为结算日\n(如遇当月无此日，则为当月最后一日)",@" 按月付息 到期还本\n(计息日起每30天，返还当月利息，到期后返还本金)\n每月收益=本金*年化利率／365天*投资期限"];
         self.messageArr = @[rateYear,dayStr,@"100元及其整数倍",@"",@[@"本期债权满标后，生成合同即计息"],@[@"T + 7:产品到期后的7个工作日内，一次性返还理财用户(当月)本金和当月收益。",@"(以豆蔓智投打款时间为准)"]];
    }
    
    [self prepareForNavigationBackBtn];
    
   self.title = @"产品简介";
    self.tableView.separatorColor = UIColorFromRGB(0xf3f3f3);
    self.tableView.tableFooterView = [UIView new];
    [self setfootview];
    
    
    self.sender = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.sender.frame = CGRectMake((SCREENWIDTH - 180) / 2, DMDeviceHeight - 33, 180, 14);
    [self.sender setTitle:@"<豆蔓定期产品服务协议范本>" forState:(UIControlStateNormal)];
    self.sender.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self.sender setTitleColor:UIColorFromRGB(0x59b090) forState:(UIControlStateNormal)];
   // [[UIApplication sharedApplication].keyWindow addSubview:self.sender];
}

- (void)setfootview{
    if ([self.guarantyName isEqualToString:@"车保智投"]) {
        NSArray *imageArray = @[@"资金灵活",@"投资期限选择多样",@"车险分期债权",@"第三方降低债权风险"];
        CGFloat height = 120*(DMDeviceWidth-22)/375;
        UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, (13+height) * 4)];
        for (int i = 0; i < 4; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, (height + 13)*i, DMDeviceWidth-22, height)];
            imageView.image = [UIImage imageNamed:imageArray[i]];
            [footview addSubview:imageView];
        }
        self.tableView.tableFooterView = footview;
    }else{
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
   // [self.sender removeFromSuperview];
}

#pragma mark - Table view data source

- (void)prepareForNavigationBackBtn {
    
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToPrevious)];
    self.navigationItem.leftBarButtonItem = backBarBtn;
}

- (void)backToPrevious {
    [self.navigationController popViewControllerAnimated:true];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.nameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 | indexPath.row == 1 | indexPath.row == 2) {
        return 50;
    }else
        if (indexPath.row == 3) {
            return [self cellHeight:self.ContentArr];
        }else {
            return [self cellHeight:self.messageArr[indexPath.row]];
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LJQProductInfoCell *cell = [[LJQProductInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LJQProductInfoCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = self.nameArr[indexPath.row];
    if (indexPath.row == 0 | indexPath.row == 1 | indexPath.row == 2) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            cell.messageLabel.textColor = UIColorFromRGB(0xfebf00);
        }
        cell.messageLabel.text = self.messageArr[indexPath.row];
        cell.ishidenMessage = NO;
    }else {
        cell.ishidenMessage = YES;
        if (indexPath.row == 3) {
            [cell createOtherView:self.ContentArr color:UIColorFromRGB(0xf3bf00) indexPath:10];
        }else {
            if (indexPath.row == 4) {
                [cell createOtherView:self.messageArr[indexPath.row] color:UIColorFromRGB(0x595757) indexPath:11];
            }else {
                [cell createOtherView:self.messageArr[indexPath.row] color:UIColorFromRGB(0x595757) indexPath:12];

            }
           
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"若投资后超过7日本期债权仍未满标，则认购资金将退回至账户余额" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

- (CGFloat)cellHeight:(NSArray *)array {
    CGFloat maxy = 5;
    for (int i = 0; i < array.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%@",array[i]];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH - 140, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil];
        maxy = rect.size.height + maxy;
    }
    return maxy + 36;
    
}

@end
