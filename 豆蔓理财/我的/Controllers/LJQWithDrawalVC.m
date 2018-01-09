//
//  LJQWithDrawalVC.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQWithDrawalVC.h"
#import "LJQwithDrawalCell.h"
#import "LJQWithDrawalNoCell.h"
#import "DMCreditRequestManager.h"
#import "LJQOpenAccountVC.h"
#import "LJQConfirmWithDrawalVC.h"
#import "DMSearchViewController.h"
static NSString *const cellIdentifier = @"withdrawalcell";
static NSString *const cellNoIdentifier = @"withdrawalnocell";
@interface LJQWithDrawalVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *MyTableView;
@property (nonatomic, strong)UIView *footView;
@property (nonatomic, strong)UIView *promptView;

@property (nonatomic, strong)NSArray<NSString *> *accountNameArr;
@property (nonatomic, copy)NSString *openAccountName; //开户支行名称
@end

@implementation LJQWithDrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isOrBankCard = YES;
    
    self.title = @"提现";
   
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    // Do any additional setup after loading the view.
    self.MyTableView = [[UITableView alloc] initWithFrame: [UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.MyTableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.MyTableView registerClass:[LJQwithDrawalCell class] forCellReuseIdentifier:cellIdentifier];
    [self.MyTableView registerClass:[LJQWithDrawalNoCell class] forCellReuseIdentifier:cellNoIdentifier];
    self.MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    self.MyTableView.rowHeight = 305 + 280 * (SCREENWIDTH - 40) / 668 ;
    self.MyTableView.tableFooterView = [self creteBten];
    [self.view addSubview:self.MyTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenkeyBoard)];
    [self.MyTableView addGestureRecognizer:tap];

     [self requestUserInfoData];
}

- (void)hiddenkeyBoard {
    [self.MyTableView endEditing:YES];
}

- (UIView *)creteBten {
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 400)];
        UIButton *button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        UIImage *image = [UIImage imageNamed:@"温馨提示"];
        button1.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        button1.center = CGPointMake(SCREENWIDTH / 2, 14 + image.size.height / 2);
        [button1 setBackgroundImage:image forState:(UIControlStateNormal)];
        [button1 setBackgroundImage:image forState:(UIControlStateHighlighted)];
        [button1 addTarget: self action:@selector(promptEvent:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.footView addSubview:button1];
    return self.footView;
}


- (UIView *)CreateBottomView:(CGFloat)rect {
    self.promptView = [[UIView alloc] initWithFrame:CGRectMake(0, rect, SCREENWIDTH, 400)];
    self.promptView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    UILabel *label = [UILabel createLabelFrame:CGRectMake(30, 27, 100, 13) labelColor:UIColorFromRGB(0x71757e) textAlignment:(NSTextAlignmentLeft) textFont:13.f];
    label.text = @"提现说明";
    [self.promptView addSubview:label];
    CGFloat maxy = CGRectGetMaxY(label.frame) +10;
    NSArray *array = @[@"1.请确保您输入的提现金额，以及银行账号信息准确无误；",@"2.如果您填写的提现信息不正确可能会导致提现失败，由此产生的提现费用将不予返还；",@"3.提现到账时间：实时到账",@"4.提现时间：由于各银行系统维护时间多选择夜间，为了避免您的提现受影响，建议23:30—00:30不进行提现操作；",@"5.单笔提现最高5万，每日提现笔数最多6笔；",@"6.工行、农行、中行、建行每日最多提现30万，其他银行每日最多提现20万；",@"7.提现单笔手续费说明：手续费每笔2元；",@"8.平台禁止洗钱，银行卡套现，虚假交易等行为，一经发现并确认，将终止该账户的使用；",@"9.如有任何提现疑问，请联系客服400-003-3939；"];
    for (int i = 0; i < array.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%@",array[i]];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH - 60, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} context:nil];
        
        UILabel *label1 = [UILabel createLabelFrame:CGRectMake(30, maxy, SCREENWIDTH - 60, rect.size.height) labelColor:UIColorFromRGB(0xb4b4b4) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        label1.numberOfLines = 0;
        label1.text = array[i];
        [self.promptView addSubview:label1];
        
        maxy = rect.size.height + maxy;
    }
    
    return self.promptView;
}



#pragma 提示
- (void)promptEvent:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = !sender.selected;
        [self.promptView removeFromSuperview];
    }else {
        sender.selected = !sender.selected;
        [sender.superview addSubview:[self CreateBottomView:CGRectGetMaxY(sender.frame)]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.isOrBankCard) {
        LJQwithDrawalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.userModel;
        cell.amountLabel.text = self.availableAmount;
        cell.allWithDrawalBK = ^(NSString *string){
            if ([string doubleValue] >= 1) {
                
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"余额不足，暂无法全部提现" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    //操作方式
                }];
                [alert addAction:cancleAction];
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:^{
                    
                }];

            }
        };
        //立即提现
        cell.withDrawalBK = ^(UIButton *sender,NSString *string,NSString *branchName) {
            
            if ([self isBetweenFromHour:23 toHour:24 fromMinute:30 toMinute:0] || [self isBetweenFromHour:0 toHour:0 fromMinute:0 toMinute:30]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"此时间为银行系统维护时间，23:30—00:30不可进行提现" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }else
            if (string.length > 0) {
                if ([string doubleValue] < 3) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提现金额不能低于3元" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                } else if ([string doubleValue] > 50000) {
//                    if ([self.accountNameArr containsObject:self.userModel.bank]) {
//                        if (branchName.length <= 0 || [branchName isEqualToString:@"请选择支行名称"]) {
//                            ShowMessage(@"请选择支行名称");
//                        }else {
//                            self.openAccountName = branchName;
//                            [self jumpToConfirmWithDrawal:string];
//                        }
//                    }else {
//                        self.openAccountName = nil;
//                        [self jumpToConfirmWithDrawal:string];
//                    }
                    
                    
                    if ([SOURCE isEqualToString:@"BACK"]) {
                        if (branchName.length <= 0 || [branchName isEqualToString:@"请选择支行名称"]) {
                            self.openAccountName = nil;
                        }else {
                            self.openAccountName = branchName;
                        }
                        
                        [self jumpToConfirmWithDrawal:string];
                    }else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"单笔提现金额不能大于5万元" preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    
                }
                else {
                    
                    if (branchName.length <= 0 || [branchName isEqualToString:@"请选择支行名称"]) {
                        self.openAccountName = nil;
                    }else {
                        self.openAccountName = branchName;
                    }
                    
                    [self jumpToConfirmWithDrawal:string];
                }
            }else {
                ShowMessage(@"请输入提现金额");
            }
        };
        
        //忘记支行名称
        cell.forgetOpenAccountName = ^{
            DMSearchViewController *search = [[DMSearchViewController alloc] init];
            search.backAccountName = ^(NSString *string) {
                
                self.openAccountName = string;
                
                [self.MyTableView reloadData];
            };
            
            [self.navigationController pushViewController:search animated:YES];
        };
    
        NSString *accountName = isOrEmpty(self.userModel.branch) ? @"请选择支行名称" : self.userModel.branch;
        cell.accountTextField.text = !isOrEmpty(self.openAccountName) ? self.openAccountName:accountName;
        return cell;

 //   }
  //      else {
//        LJQWithDrawalNoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNoIdentifier forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//
//    }
}

- (NSArray<NSString *> *)accountNameArr {
    if (!_accountNameArr) {
        _accountNameArr = [@[@"中国工商银行",@"中国农业银行",@"中国银行",@"中国建设银行",@"南京银行"] copy];
    }
    return _accountNameArr;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


//用户信息
- (void)requestUserInfoData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] LJQUserInfoDataSourceSuccessBlock:^(NSInteger index, LJQUserInfoModel *model, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.userModel = model;
        self.isOrBankCard = YES;
        [self.MyTableView reloadData];
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)jumpToConfirmWithDrawal:(NSString *)string {
    LJQConfirmWithDrawalVC *confirem = [[LJQConfirmWithDrawalVC alloc] init];
    confirem.WithDrawalAmount = string;
    confirem.openBranchName = self.openAccountName;
    [self.navigationController pushViewController:confirem animated:YES];
}

//判断时间是否处于某个时间段
- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour fromMinute:(NSInteger)fromMin toMinute:(NSInteger)toMin{
    NSDate *date8 = [self getCustomDateWithHour:fromHour andMinute:fromMin];
    NSDate *date23 = [self getCustomDateWithHour:toHour andMinute:toMin];
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
    {
     return YES;
    }
         return NO;
}

- (NSDate *)getCustomDateWithHour:(NSInteger)hour andMinute:(NSInteger)minute{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 生成当天的component
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    // 根据resultCalendar和resultComps生成日期
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

@end
