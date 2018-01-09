//
//  DMCreditDetailController.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/9.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditDetailController.h"
#import "DMCreditHeadView.h"
#import "DMCreditBaseCell.h"
#import "DMCreditInfoCell.h"
#import "DMCreditAssetInfoCell.h"
#import "DMCreditAssetDesCell.h"
#import "DMCarMortPerCell.h"
#import "DMCreditCpInfoCell.h"
#import "DMCreditCPHeadView.h"
#import "DMCreditCPCheckCell.h"
#import "elseiCarouselView.h"
#import "DMCreditRequestManager.h"
#import "DMCarPledgeModel.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"
#import "AZT_PDFReader.h"

#import "DMContractViewController.h"
@interface DMCreditDetailController ()<UITableViewDelegate,UITableViewDataSource,DMCreditHeadViewDelegate>{
    NSURLSessionDownloadTask *downLoadTask;
}
@property (nonatomic, strong) UITableView *tableView;

typedef NS_ENUM(NSInteger, SegmentType){
    BorrowInfo,
    CheckInfo
};

@property (nonatomic) SegmentType segmentType;

@property (nonatomic, strong) DMCarPledgeModel *infoModel;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *icarArray;
@end

@implementation DMCreditDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentType = BorrowInfo;
    
    [self.view addSubview:self.tableView];
    
    [self requsetData];
}


- (void)requsetData{
    
    if([self.guarantyStyle isEqualToString:@"CarInsurance"]||
       [self.guarantyStyle isEqualToString:@"车保智投"]){
        [[DMCreditRequestManager manager] getRequestCarInsuranceWithLoanId:self.loanId Success:^(DMCarPledgeModel *pledgeModel, NSArray<DMCarPledgeListModel *> *listModel) {
            self.infoModel = pledgeModel;
            self.icarArray = [NSArray arrayWithArray:listModel];
            if (self.infoModel.enterPrise) {
                self.creditType = CarInsuranceCompany;
            }else{
                self.creditType = CarInsurancePerson;
            }
            [self setHeadView];
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
        } failed:^{
            [self.tableView.mj_header endRefreshing];
        }];
    }else {
        [[DMCreditRequestManager manager] getRequstCarPledgeWithLoanId:self.loanId Success:^(DMCarPledgeModel *pledgeModel, NSArray<DMCarPledgeListModel *> *listModel) {
            self.infoModel = pledgeModel;
            self.icarArray = [NSArray arrayWithArray:listModel];
            if (self.infoModel.enterPrise) {
                self.creditType = CarMortgageCompany;
            }else{
                self.creditType = CarMortgagePerson;
            }
            [self setHeadView];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } failed:^{
            [self.tableView.mj_header endRefreshing];
        }];
    }
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [self setRefreshHeader:^{
            [weakSelf requsetData];
        }];
    }
    return _tableView;
}

- (void)setHeadView{
    DMCreditHeadView *headView = [[DMCreditHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.creditType==CarInsurancePerson?390:310) Type:self.creditType];
    headView.delegate = self;
    _tableView.tableHeaderView = headView;
    if (self.infoModel) {
        headView.icars = [NSArray arrayWithArray:self.icarArray];
        headView.infoModel = self.infoModel;
    }
    if ([self.infoModel.isLoanSettle isEqualToString:@"0"]||[self.infoModel.isUserHasLoan isEqualToString:@"0"]) {
        headView.frame = CGRectMake(0, 0, DMDeviceWidth, 170);
    }
}
#pragma mark
#pragma mark -- headview delegate 

- (void)getContract{
    if ([self.infoModel.contractStatus isEqualToString:@"0"]) {
        ShowMessage(@"满标可见合同");
    }else if([self.infoModel.contractStatus isEqualToString:@"1"]) {
        ShowMessage(@"合同生成中");
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DMCreditRequestManager manager] getCreditContactWithLoadId:self.infoModel.loanId Success:^(NSString *loanUrl) {
            [self downLoadPDF:loanUrl];
            [downLoadTask resume];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failed:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

//下载PDF文件
- (void)downLoadPDF:(NSString *)urlString {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //File Url
    NSString* fileUrl = urlString;
    //创建 Request
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    
    //下载进行中的事件
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度---%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        CGFloat number = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        if (number == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *string = [NSString stringWithFormat:@"%@.pdf",response.suggestedFilename];
        
        NSString *path = [cachesPath stringByAppendingPathComponent:string];
        
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *imgFilePath = [filePath path];
        //设置签章验证的颜色
        [[AZT_PDFReader getInstance] setShowSignatureViewMainColor:[UIColor whiteColor]];
        //打开阅读器
        [[AZT_PDFReader getInstance] openPDFWithViewCtr:self PDFPath:imgFilePath ViewCtrTitle:@"合同页"];
    }];
}


- (void)selectSegmentWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
            self.segmentType = BorrowInfo;
            [self.tableView reloadData];
            break;
        case 1:
            self.segmentType = CheckInfo;
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}


#pragma mark
#pragma mark -- tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.creditType) {
        case CarInsurancePerson:
            if (self.segmentType == BorrowInfo) {
                if (self.infoModel) {
                    return 6;
                }else{
                    return 0;
                }
            }else{
                return 1;
            }
            break;
        case CarMortgagePerson:{
            if (self.segmentType == BorrowInfo) {
                return 6;
            }else{
                return 1;
            }
        }
            break;
        case CarMortgageCompany:{
            if (self.segmentType == BorrowInfo) {
                return 4;
            }else{
                return 5;
            }
        }
            break;
        case CarInsuranceCompany:
            if (self.segmentType == BorrowInfo) {
                return 4;
            }else{
                return 5;
            }
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.creditType) {
        case CarInsurancePerson:{
            if (self.segmentType == BorrowInfo) {
                DMCreditInfoCell *cell = [[DMCreditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                switch (indexPath.row) {
                    case 0:
                        cell.titleLabel.text = @"基本信息";
                        [cell setupValueWithTitleArray:@[@"姓名：",@"手机：",@"身份证："] detailArray:[self carBaseInfo]];
                        break;
                    case 1:
                        cell.titleLabel.text = @"债权信息";
                        [cell setCreditInfoWithTitleArray:@[@"借款金额：",@"借款期限：",@"还款方式：",@"借款用途：",@"风险提示：",@"还款保障："] detailArray:[self creditInfo]];
                        break;
                    case 2:
                        cell.titleLabel.text = @"保单信息";
                        [cell setPolicyWithTitleArray:@[@"保单号：",@"投保人：",@"第一受益人：",@"保单金额：",@"到期时间："] detailArray:[self policyInfo]];
                        break;
                    case 3:
                    {
                        DMCreditAssetInfoCell *cell = [[DMCreditAssetInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assetinfocell"];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.authenArray = [self authInfo];
                        [cell setupValueWithTitleArray:@[@"",@"",@"",@""] detailArray:@[@"房产",@"房贷",@"车产",@"车贷"]];
                        cell.backgroundColor = [UIColor clearColor];
                        return cell;
                    }
                        break;
                    case 4:
                    {
                        DMCreditAssetDesCell *cell = [[DMCreditAssetDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assetdescell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        if (self.infoModel.loanDescription) {
                            [cell setLoanDescript:self.infoModel.loanDescription];
                        }
                        cell.backgroundColor = [UIColor clearColor];
                        return cell;
                    }
                        break;
                    case 5:
                        cell.titleLabel.text = @"其他借款信息";
                        [cell setupValueWithTitleArray:@[@"平台借款总额：",@"借款总笔数：",@"借贷余额：",@"在还笔数：",@"逾期金额：",@"逾期笔数："] detailArray:[self otherBorrowInfo]];
                        break;
                    default:
                        break;
                }
                return cell;
            }else{
                DMCarMortPerCell *cell = [[DMCarMortPerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DMCarMortPerCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                cell.dataArray = @[@"身份证认证",@"手机认证",@"保单认证"];
                cell.authenArray = @[self.infoModel.idNumberAuthen,self.infoModel.mobileAuthen,self.infoModel.policyAuthen];
                return cell;
            }

        }break;
        case CarMortgagePerson:{
            if (self.segmentType == BorrowInfo) {
                if (indexPath.row == 0) {
                    DMCreditInfoCell *cell = [[DMCreditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.titleLabel.text = @"基本信息";
                    [cell setupValueWithTitleArray:@[@"姓名：",@"手机：",@"身份证："] detailArray:[self carBaseInfo]];
                    return cell;
                }else if (indexPath.row == 2){
                    DMCreditAssetInfoCell *cell = [[DMCreditAssetInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assetinfocell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.authenArray = [self authInfo];
                    [cell setupValueWithTitleArray:@[@"",@"",@"",@""] detailArray:@[@"房产",@"房贷",@"车产",@"车贷"]];
                    cell.backgroundColor = [UIColor clearColor];
                    return cell;
                }else if (indexPath.row == 3) {
                    DMCreditInfoCell *cell = [[DMCreditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    if ((self.infoModel.companyIndustry.length > 0 && self.infoModel.jobPositon.length > 0 && self.infoModel.totalYearOfService.length > 0 && self.infoModel.workProvince.length > 0)) {
                        cell.titleLabel.text = @"工作信息";
                        [cell setupValueWithTitleArray:@[@"所属行业：",@"职位：",@"工作年限：",@"工作省份："] detailArray:[self workInfo]];
                    }else{
                        cell.titleLabel.text = @"";
                        cell.imageView.hidden = YES;
                        cell.line.hidden = YES;
                    }
                    return cell;
                }else if (indexPath.row == 1) {
                    DMCreditInfoCell *cell = [[DMCreditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell1"];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"债权信息";
                    [cell setCreditInfoWithTitleArray:@[@"借款金额：",@"借款期限：",@"还款方式：",@"借款用途：",@"风险提示：",@"还款保障："] detailArray:[self creditInfo]];
                    return cell;
                }else if (indexPath.row==4){
                    DMCreditAssetDesCell *cell = [[DMCreditAssetDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assetdescell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (self.infoModel.loanDescription) {
                        [cell setLoanDescript:self.infoModel.loanDescription];
                    }
                    cell.backgroundColor = [UIColor clearColor];
                    return cell;
                }else{
                    DMCreditInfoCell *cell = [[DMCreditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell1"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.titleLabel.text = @"其他借款信息";
                    [cell setupValueWithTitleArray:@[@"平台借款总额：",@"借款总笔数：",@"借贷余额：",@"在还笔数：",@"逾期金额：",@"逾期笔数："] detailArray:[self otherBorrowInfo]];
                    return cell;
                }
            }else{
                DMCarMortPerCell *cell = [[DMCarMortPerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DMCarMortPerCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                if (![self.infoModel.house isEqualToString:@"1"]) {
                    cell.dataArray = @[@"身份证认证",@"收入证明",@"手机认证",@"车产证明",@"工作证明"];
                    cell.authenArray = @[self.infoModel.idNumberAuthen,self.infoModel.incomeAuthen,self.infoModel.mobileAuthen,self.infoModel.carAuthen,self.infoModel.jobAuthen];
                }else if(![self.infoModel.car isEqualToString:@"1"]){
                    cell.dataArray = @[@"身份证认证",@"收入证明",@"手机认证",@"房产证明",@"工作证明"];
                    cell.authenArray = @[self.infoModel.idNumberAuthen,self.infoModel.incomeAuthen,self.infoModel.mobileAuthen,self.infoModel.houseAuthen,self.infoModel.jobAuthen];
                }else if (![self.infoModel.car isEqualToString:@"1"] && ![self.infoModel.house isEqualToString:@"1"]){
                    cell.dataArray = @[@"身份证认证",@"收入证明",@"手机认证",@"工作证明"];
                    cell.authenArray = @[self.infoModel.idNumberAuthen,self.infoModel.incomeAuthen,self.infoModel.mobileAuthen,self.infoModel.jobAuthen];
                }else{
                    cell.dataArray = @[@"身份证认证",@"收入证明",@"手机认证",@"车产证明",@"工作证明",@"房产证明"];
                    cell.authenArray = @[self.infoModel.idNumberAuthen,self.infoModel.incomeAuthen,self.infoModel.mobileAuthen,self.infoModel.carAuthen,self.infoModel.jobAuthen,self.infoModel.houseAuthen];
                }
                return cell;
            }
        }
            break;
        case CarMortgageCompany:{
            if (self.segmentType == BorrowInfo) {
                DMCreditInfoCell *cell = [[DMCreditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                switch (indexPath.row) {
                    case 0:
                        cell.titleLabel.text = @"基本信息";
                        [cell setCompanyBaseInfoTitleArray:@[@"企业简称：",@"注册资本：",@"注册时间：",@"注册地址：",@"法定代表人："] detailArray:[self companyInfo]];
                        break;
                    case 1:
                        cell.titleLabel.text = @"债权信息";
                        [cell setCreditInfoWithTitleArray:@[@"借款金额：",@"借款期限：",@"还款方式：",@"借款用途：",@"风险提示：",@"还款保障："] detailArray:[self creditInfo]];
                        break;
                    case 2:{
                        DMCreditAssetDesCell *cell = [[DMCreditAssetDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assetdescell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        if (self.infoModel.loanDescription) {
                            [cell setLoanDescript:self.infoModel.loanDescription];
                        }
                        cell.backgroundColor = [UIColor clearColor];
                        return cell;
                    }
                        break;
                    case 3:
                        cell.titleLabel.text = @"其他借款信息";
                        [cell setupValueWithTitleArray:@[@"平台借款总额：",@"借款总笔数：",@"借贷余额：",@"在还笔数：",@"逾期金额：",@"逾期笔数："] detailArray:[self otherBorrowInfo]];
                        break;
                    default:
                        break;
                }
                return cell;
            }else{
                DMCreditCPCheckCell *cell = [[DMCreditCPCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DMCreditCPCheckCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                NSArray *titArr = @[@"信用报告",@"身份认证",@"营业执照",@"收入报告",@"实地报告"];
                [cell setTitleWithString:titArr[indexPath.row] checkdate:self.infoModel.timeSettled?self.infoModel.timeSettled:@"暂无"];
                return cell;
            }
        }   break;
        case CarInsuranceCompany:
            if (self.segmentType == BorrowInfo) {
                DMCreditInfoCell *cell = [[DMCreditInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                switch (indexPath.row) {
                    case 0:
                        cell.titleLabel.text = @"基本信息";
                        [cell setCompanyBaseInfoTitleArray:@[@"企业简称：",@"注册资本：",@"注册时间：",@"注册地址：",@"法定代表人："] detailArray:[self companyInfo]];
                        break;
                    case 1:
                        cell.titleLabel.text = @"债权信息";
                        [cell setCreditInfoWithTitleArray:@[@"借款金额：",@"借款期限：",@"还款方式：",@"借款用途：",@"风险提示：",@"还款保障："] detailArray:[self creditInfo]];
                        break;
                    case 2:
                        cell.titleLabel.text = @"保单信息";
                        [cell setPolicyWithTitleArray:@[@"保单号：",@"投保人：",@"第一受益人：",@"保单金额：",@"到期时间："] detailArray:[self policyInfo]];
                        break;
                    case 3:
                        cell.titleLabel.text = @"其他借款信息";
                        [cell setupValueWithTitleArray:@[@"平台借款总额：",@"借款总笔数：",@"借贷余额：",@"在还笔数：",@"逾期金额：",@"逾期笔数："] detailArray:[self otherBorrowInfo]];
                        break;
                    default:
                        break;
                }
                return cell;
            }else{
                DMCreditCPCheckCell *cell = [[DMCreditCPCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DMCreditCPCheckCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                NSArray *titArr = @[@"信用报告",@"身份认证",@"营业执照",@"收入报告",@"实地报告"];
                [cell setTitleWithString:titArr[indexPath.row] checkdate:self.infoModel.timeSettled?self.infoModel.timeSettled:@"暂无"];
                return cell;
            }
            break;
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ((self.creditType == CarMortgageCompany || self.creditType == CarInsuranceCompany) && self.segmentType == CheckInfo){
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 50)];
        
        DMCreditCPHeadView *headview = [[DMCreditCPHeadView alloc] initWithFrame:CGRectMake(10, 20, DMDeviceWidth-20, 30)];
        [backView addSubview:headview];
        return backView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ((self.creditType == CarMortgageCompany || self.creditType == CarInsuranceCompany) && self.segmentType == CheckInfo) {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.creditType) {
        case CarInsurancePerson:
            if (self.segmentType == BorrowInfo) {
                if (indexPath.row == 2) {
                    return 175;
                }else if (indexPath.row == 1){
                    CGFloat riskHeight = [self getCreditHeightWithText:[self creditInfo][4]];
                    CGFloat repaymentHeight = [self getCreditHeightWithText:[self creditInfo][5]];
                    return 115 + riskHeight + repaymentHeight;
                }else if (indexPath.row == 4){
                    return [self descriptHeight];
                }else if(indexPath.row == 5){
                    return 165;
                }else{
                    return 115;
                }
            }else{
                return 145;
            }
            break;
        case CarMortgagePerson:{
            if(indexPath.row == 4){
                return [self descriptHeight];
            }else if (indexPath.row == 1) {
                CGFloat riskHeight = [self getCreditHeightWithText:[self creditInfo][4]];
                CGFloat repaymentHeight = [self getCreditHeightWithText:[self creditInfo][5]];
                return 115 + riskHeight + repaymentHeight;
            }else if (indexPath.row == 3){
                if (self.infoModel.companyIndustry.length > 0 && self.infoModel.jobPositon.length > 0 && self.infoModel.totalYearOfService.length > 0 && self.infoModel.workProvince.length > 0){
                    return 115;
                }else{
                    return 0;
                }
            }else if (indexPath.row == 5){
                return 165;
            }else{
                return 115;
            }
        }
            break;
        case CarMortgageCompany:
            if (self.segmentType == BorrowInfo) {
                if (indexPath.row == 0) {
                    return 175;
                }else if (indexPath.row == 1){
                    CGFloat riskHeight = [self getCreditHeightWithText:[self creditInfo][4]];
                    CGFloat repaymentHeight = [self getCreditHeightWithText:[self creditInfo][5]];
                    return 115 + riskHeight + repaymentHeight;
                }else if (indexPath.row == 3){
                    return 165;
                }else{
                    return [self descriptHeight];
                }
            }else{
                return 30;
            }
            break;
        case CarInsuranceCompany:
            if (self.segmentType == BorrowInfo) {
                if (indexPath.row==3||indexPath.row==0||indexPath.row==2) {
                    return 165;
                }else{
                    CGFloat riskHeight = [self getCreditHeightWithText:[self creditInfo][4]];
                    CGFloat repaymentHeight = [self getCreditHeightWithText:[self creditInfo][5]];
                    return 115 + riskHeight + repaymentHeight;
                }
            }else{
                return 30;
            }
            break;
        default:
            break;
    }
}

- (NSArray *)dataArray{
    if (_dataArray ==nil) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}

- (NSArray *)icarArray{
    if (_icarArray == nil) {
        self.icarArray = [@[] copy];
    }
    return _icarArray;
}

- (CGFloat)descriptHeight{
    CGRect rect;
    if (self.infoModel.loanDescription) {
        rect = [self.infoModel.loanDescription boundingRectWithSize:CGSizeMake(DMDeviceWidth -30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:10]} context:nil];
    }
    return rect.size.height + 10+35+10;
}

- (NSArray *)baseInfo{
    return @[[self borrowName],
             self.infoModel.dateOfBirth?self.infoModel.dateOfBirth:@"",
             self.infoModel.educationLevel?self.infoModel.educationLevel:@"",
             self.infoModel.nativeAddress?self.infoModel.nativeAddress:@""];
}

- (NSArray *)workInfo{
    return @[self.infoModel.companyIndustry?self.infoModel.companyIndustry:@"",
             self.infoModel.jobPositon?self.infoModel.jobPositon:@"",
             self.infoModel.totalYearOfService?self.infoModel.totalYearOfService:@"",
             self.infoModel.workProvince?self.infoModel.workProvince:@""];
}

- (NSArray *)authInfo{
    return @[self.infoModel.house?self.infoModel.house:@"0",
             self.infoModel.houseLoan?self.infoModel.houseLoan:@"0",
             self.infoModel.car?self.infoModel.car:@"0",
             self.infoModel.carLoan?self.infoModel.carLoan:@"0"];
}
                     
- (NSArray *)companyInfo{
    return @[self.infoModel.shortName?self.infoModel.shortName:@"",
             self.infoModel.registeredCapital?[NSString insertCommaWithString:self.infoModel.registeredCapital]:@"",
             self.infoModel.timeEstablished?self.infoModel.timeEstablished:@"",
             self.infoModel.registeredLocation?self.infoModel.registeredLocation:@"",
             self.infoModel.legalPersonName?self.infoModel.legalPersonName:@""];
}

// 车险分期
- (NSArray *)carBaseInfo{
    return @[[self borrowName],
             [self mobileNumber],
             [self idNumber]];
}

- (NSString *)mobileNumber{
    if (self.infoModel.mobile.length == 11) {
        NSString *start = [self.infoModel.mobile substringToIndex:3];
        NSString *end = [self.infoModel.mobile substringFromIndex:9];
        return [NSString stringWithFormat:@"%@******%@",start,end];
    }else{
        return @"";
    }
}

- (NSString *)borrowName{
    if (self.infoModel.borrowerName.length > 0) {
        if (self.infoModel.borrowerName.length == 1) {
            return self.infoModel.borrowerName;
        }else{
            NSString *sub = [self.infoModel.borrowerName substringToIndex:1];
            NSString *name = [sub stringByAppendingString:@"**"];
            return name;
        }
    }else{
        return @"";
    }
}

- (NSString *)idNumber{
    if (self.infoModel.idNumber.length > 4) {
        NSString * sub = [self.infoModel.idNumber substringToIndex:4];
        NSString * perIdNum = [sub stringByAppendingString:@"**************"];
        return perIdNum;
    }else{
        return @"";
    }
}

- (NSArray *)creditInfo{
    NSString *amount;
    if (self.infoModel.loanAmount) {
        amount = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",[self.infoModel.loanAmount doubleValue]]];
    }else{
        amount = @"";
    }
    return @[amount,
             self.infoModel.period?[self.infoModel.period stringByAppendingString:self.infoModel.termUnit==1?@"天":@"个月"]:@"",
             self.infoModel.method?([self.infoModel.method isEqualToString:@"MonthlyInterest"]?@"按月付息":@"等额本息"):@"",
             self.infoModel.purpose?self.infoModel.purpose:@"",
             self.infoModel.riskInfo?self.infoModel.riskInfo:@"",
             self.infoModel.repaymentGuaranty?self.infoModel.repaymentGuaranty:@""];
}

- (NSArray *)otherBorrowInfo{
    return @[[NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",self.infoModel.totalLoanAmount]],
             [NSString stringWithFormat:@"%d",self.infoModel.totalLoanCount],
             [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",self.infoModel.undueLoanAmount]],
             [NSString stringWithFormat:@"%d",self.infoModel.undueLoanCount],
             [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",self.infoModel.overdueLoanAmount]],
             [NSString stringWithFormat:@"%d",self.infoModel.overdueLoanCount],
             ];
}

- (NSArray *)policyInfo{
    NSString *amount;
    if (self.infoModel.amountOfPolicy) {
        amount = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",[self.infoModel.amountOfPolicy doubleValue]]];
    }else{
        amount = @"";
    }
    return @[self.infoModel.numOfPolicy?self.infoModel.numOfPolicy:@"",
             self.infoModel.policyHolder?self.infoModel.policyHolder:@"",
             self.infoModel.firstBeneficiary?self.infoModel.firstBeneficiary:@"",
             amount,
             self.infoModel.dateOfPolicy?self.infoModel.dateOfPolicy:@""];
}

- (CGFloat)getCreditHeightWithText:(NSString *)text{
    [text stringByAppendingString:@"债权高度："];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(DMDeviceWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:13]} context:nil];
    return rect.size.height + 17;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"合同页加载完成");
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];

}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"合同页显示完成");
    
    //电子签章PDF返回时隐藏Tabbar
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
}

@end
