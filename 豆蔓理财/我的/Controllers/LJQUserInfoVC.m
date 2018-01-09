//
//  LJQUserInfoVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQUserInfoVC.h"
#import "LJQUserInfoCell.h"
#import "LJQUserInfoTwoCell.h"
#import "LJQUserInfoModel.h"
#import "DMRealNameCertifyViewController.h"
#import "DMAddBandCardViewController.h"

#import "DMCodeViewController.h"

#import "LJQUserInfoThreeCell.h"


static NSString *const LJQUserInfoVCIdentifier = @"LJQUserInfoVCCell";
static NSString *const LJQUserInfoVCTwoIdentifier = @"LJQUserInfoVCTwoCell";
static NSString *const LJQUserInfoVCThreeIdentifier = @"LJQUserInfoThreeCell";
@interface LJQUserInfoVC (){
    NSDictionary *userdic;
}

@property (nonatomic, strong)NSArray *nameArr;
@property (nonatomic, strong)UIView *promptView;
@property (nonatomic, assign)BOOL isCard;
@property (nonatomic, strong)LJQUserInfoModel *userModel;
@property (nonatomic, assign)BOOL isRealNamed;
@end

@implementation LJQUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"账户信息";
//    [self requestUserInfoData];
    [self.tableView registerClass:[LJQUserInfoCell class] forCellReuseIdentifier:LJQUserInfoVCIdentifier];
    self.tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.tableView.separatorColor = UIColorFromRGB(0xf3f3f3);
    self.tableView.separatorInset = UIEdgeInsetsMake(DMDeviceWidth, 0, 0, 0);
    [self.tableView registerClass:[LJQUserInfoTwoCell class] forCellReuseIdentifier:LJQUserInfoVCTwoIdentifier];
    [self.tableView registerClass:[LJQUserInfoThreeCell class] forCellReuseIdentifier:LJQUserInfoVCThreeIdentifier];
    self.tableView.tableFooterView = [self CreateBottomView:6.f];
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self requestUserInfoData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)CreateBottomView:(CGFloat)rect {
    self.promptView = [[UIView alloc] initWithFrame:CGRectMake(0, rect, SCREENWIDTH, 200)];
    self.promptView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel *label = [UILabel createLabelFrame:CGRectMake(30, 27, 100, 13) labelColor:UIColorFromRGB(0x71757e) textAlignment:(NSTextAlignmentLeft) textFont:13.f];
    label.text = @"温馨提示";
    [self.promptView addSubview:label];
    CGFloat maxy = CGRectGetMaxY(label.frame) +10;
    NSArray *array = @[@"1.若操作提现，提现资金将汇入此银行卡；",@"2.若需要解绑银行卡，请联系客服400-003-3939。"];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        UIImage *image = [UIImage imageNamed:@"添加银行卡"];
        if (self.isCard == YES) {
            return 71;
        }else {
            return image.size.height * DMDeviceWidth / image.size.width;
        }
    }else if(indexPath.row == 0) {
        UIImage *image = [UIImage imageNamed:@"电子交易账户"];
        return (DMDeviceWidth - 20) * image.size.height / image.size.width + 20;
    }
    else {
        return 44;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        LJQUserInfoTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:LJQUserInfoVCTwoIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isCard = self.isCard;
        cell.model = self.userModel;
        cell.addBankBlock = ^(UIButton *sender ){
            
            DMCodeViewController *addBankView = [[DMCodeViewController alloc] init];
            addBankView.dic = userdic;
            [self.navigationController pushViewController:addBankView animated:YES];

        };
        return cell;

    } else if (indexPath.row == 0) {
        LJQUserInfoThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:LJQUserInfoVCThreeIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(-DMDeviceWidth, 0, DMDeviceWidth, 0);
        cell.infoModel = self.userModel;
        if (isOrEmpty(CARD_NUMBER)) {
            cell.isOpenAccount = NO;
        }else {
            cell.isOpenAccount = YES;
        }
        return cell;
    }
    else {
        LJQUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LJQUserInfoVCIdentifier forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = self.nameArr[indexPath.row - 1];
        
        if (indexPath.row == 1) {
            cell.infoLabel.text = self.userModel.mobile;
        }else
            if (indexPath.row == 2) {
                cell.infoLabel.text = self.userModel.name;
            }else
                if (indexPath.row == 3) {
                    cell.infoLabel.text = [self returnIdString:self.userModel.idNumber];
                }
        if (indexPath.row == 2) {

            cell.isRealName = self.isRealNamed;
        }else {
            cell.isRealName = YES;
        }
        __weak LJQUserInfoVC *weakSelf = self;
        cell.realNameBlock = ^(UIButton *sender ) {
          //开始实名认证
            NSLog(@"开始实名认证");

            DMCodeViewController *addBankView = [[DMCodeViewController alloc] init];
            addBankView.dic = userdic;
            [weakSelf.navigationController pushViewController:addBankView animated:YES];


        };
        
        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (isOrEmpty(CARD_NUMBER)) {
            DMCodeViewController *addBankView = [[DMCodeViewController alloc] init];
            addBankView.dic = userdic;
            [self.navigationController pushViewController:addBankView animated:YES];
        }
    }
}

- (NSArray *)nameArr {
    if (!_nameArr) {
        self.nameArr = @[@"用户名/手机号",@"真实姓名",@"身份证号",@"银行卡信息"];
    }
    return _nameArr;
}

- (NSString *)returnIdString:(NSString *)string {
    NSString *str = string;
    for (int length = 0; length < string.length; length++) {
        if (length > 3 && length < string.length - 4) {
            str = [str stringByReplacingCharactersInRange:NSMakeRange(length, 1) withString:@"*"];
        }
    }
    return str;
}

//用户信息
- (void)requestUserInfoData {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[LJQMineRequestManager RequestManager] LJQUserInfoDataSourceSuccessBlock:^(NSInteger index, LJQUserInfoModel *model, NSString *message) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (!isOrEmpty(model.name)) {
            [[NSUserDefaults standardUserDefaults] setObject:model.name forKey:@"realName"];
        }
        if (!isOrEmpty(model.cardNbr)) {
            [[NSUserDefaults standardUserDefaults] setObject:model.cardNbr forKey:@"cardNbr"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.userModel = model;
        
        if (!isOrEmpty(model.cardNbr)) {
            if (model.account != nil) {
                self.isCard = YES;
            }else {
                self.isCard = NO;
            }
        }
        
        if (model.name != nil) {
            self.isRealNamed = YES;
        }else {
            self.isRealNamed = NO;
        }
        [self.tableView reloadData];
    } faild:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

@end
