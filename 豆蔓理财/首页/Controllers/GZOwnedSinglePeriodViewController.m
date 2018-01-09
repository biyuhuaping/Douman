//
//  GZOwnedSinglePeriodViewController.m
//  豆蔓理财
//
//  Created by armada on 2016/12/13.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZOwnedSinglePeriodViewController.h"

#import "GZPurchaseProgressView.h"
#import "DMCreditAssetListModel.h"
#import "GZSinglePeriodTableViewCell.h"
#import "DMCreditRequestManager.h"
#import "DMCreditDetailController.h"
#import "DMCurrentClaimsViewController.h"
#import "DMHoldingAssetsViewController.h"
#import "DMSingleLoanModel.h"
@interface GZOwnedSinglePeriodViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UIImageView *backgroundImgView;
}

/** 债权期数 */
@property(nonatomic,strong) UILabel *periodLabel;
/** 债权类型 */
@property(nonatomic,strong) UILabel *typeLabel;
/** 债权来源 */
@property(nonatomic,strong) UILabel *resourceLabel;
/** 债权总数 */
@property(nonatomic,strong) UILabel *totalNumLabel;
/** 筹标详情 */
@property(nonatomic,strong) GZPurchaseProgressView *progressView;
/** 筹标进度百分比 */
@property(nonatomic,strong) UILabel *progressLabel;
/** 债权列表 */
@property(nonatomic,strong) UITableView *debtsListTableView;
/** 数据源 */
@property(nonatomic,strong) NSMutableArray *dataSource;
/** 合同+ */
//@property(nonatomic,strong) UIButton *contractBtn;
//本期筹标详情
@property (nonatomic, strong)UIButton * currentDetailBtn;

@property (nonatomic, strong) DMCreditAssetListModel *assetModel;

@end

@implementation GZOwnedSinglePeriodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareForNavigationItem];
    self.navigationItem.title = @"持有单期债权";

    self.periodLabel.text = @"第0期";
    self.typeLabel.text = @"";
    self.resourceLabel.text = @"";
    self.totalNumLabel.text = @"0个";
    self.progressView.progress = 0;
    self.progressLabel.text = @"0%";
//    self.contractBtn.hidden = NO;
    [self.debtsListTableView reloadData];
    
    [self requestDataWithPage:1];
}

- (void)refresh{
    [self requestDataWithPage:1];
}

- (void)requestDataWithPage:(int)page{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *p = [@(page) stringValue];
    [[DMCreditRequestManager manager] getSingleHoldCreditWithAssetId:self.assetId page:p Success:^(DMCreditAssetListModel *assetModel, NSArray<DMSingleLoanModel *> *loanList) {
        self.assetModel = assetModel;
        self.dataSource = [NSMutableArray arrayWithArray:loanList];
        [self setUpValue];
        [self.debtsListTableView reloadData];
        [self.debtsListTableView.mj_header endRefreshing];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } Failed:^{
        [self.debtsListTableView.mj_header endRefreshing];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)setUpValue{
    if (self.assetModel) {
        self.periodLabel.text = [NSString stringWithFormat:@"第%@期",self.assetModel.periods];
        self.typeLabel.text = self.assetModel.loanType;
        self.resourceLabel.text = self.assetModel.sourceOfAssets;
        self.totalNumLabel.text = [NSString stringWithFormat:@"债权%@个",self.assetModel.loanNum];
        self.progressView.progress = [self.assetModel.purchaseRatio floatValue]/100.f;
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",self.assetModel.purchaseRatio.floatValue];
        if ([self.assetModel.purchaseRatio floatValue]/100.f == 1) {
            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:@"本期筹标详情" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x51e0a2)}];
            [_currentDetailBtn setAttributedTitle:attStr forState:UIControlStateNormal];
            _currentDetailBtn.userInteractionEnabled = NO;
        }else{
            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:@"本期筹标详情" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:UIColorFromRGB(0x51e0a2)}];
            [_currentDetailBtn setAttributedTitle:attStr forState:UIControlStateNormal];
            [_currentDetailBtn setAttributedTitle:attStr forState:UIControlStateHighlighted];
            _currentDetailBtn.userInteractionEnabled = YES;
        }
    }
}


- (void)prepareForNavigationItem {
    
    UIButton *investDetailBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
//    [investDetailBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-15"] forState:UIControlStateNormal];
//    [investDetailBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-15"] forState:UIControlStateHighlighted];
    [investDetailBtn setBackgroundColor:[UIColor clearColor]];
    investDetailBtn.layer.borderColor = MainRed.CGColor;
    investDetailBtn.layer.cornerRadius = 13;
    investDetailBtn.layer.borderWidth = 1.0f;
    investDetailBtn.layer.masksToBounds = YES;
    [investDetailBtn setTitle:@"投资详情" forState:UIControlStateNormal];
    [investDetailBtn setTitleColor:MainRed forState:UIControlStateNormal];
    [investDetailBtn setTitleColor:MainRed forState:UIControlStateHighlighted];
    [investDetailBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
    [investDetailBtn addTarget:self action:@selector(investDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:investDetailBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - Lazy loading

- (UILabel *)periodLabel {
    
    if(!_periodLabel) {
        _periodLabel = [[UILabel alloc]init];
        [self.view addSubview:_periodLabel];
        [_periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(22);
            make.left.equalTo(self.view).offset(10);
            make.height.mas_equalTo(@20);
        }];
        
        [_periodLabel setTextAlignment:NSTextAlignmentCenter];
        [_periodLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
        [_periodLabel setTextColor:DarkGray];
    }
    return _periodLabel;
}

- (UILabel *)typeLabel {
    
    if(!_typeLabel) {
//        UIImageView *borderImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形-15"]];
        UIImageView *borderImgView = [[UIImageView alloc] init];
        borderImgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:borderImgView];
        [borderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.periodLabel.mas_right).offset(2);
            make.centerY.equalTo(self.periodLabel);
            make.width.mas_equalTo(@75);
            make.height.mas_equalTo(@25);
        }];
        
        _typeLabel = [[UILabel alloc]init];
        [borderImgView addSubview:_typeLabel];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(borderImgView).insets(UIEdgeInsetsZero);
        }];
        [_typeLabel setTextAlignment:NSTextAlignmentCenter];
        [_typeLabel setFont:[UIFont systemFontOfSize:11]];
        [_typeLabel setTextColor:MainRed];
        
        _typeLabel.layer.borderWidth = 1.0f;
        _typeLabel.layer.borderColor = MainRed.CGColor;
        _typeLabel.backgroundColor = mainBack;
        _typeLabel.layer.cornerRadius = 8;
        _typeLabel.layer.masksToBounds = YES;
    }
    return _typeLabel;
}

- (UILabel *)resourceLabel {
    
    if(!_resourceLabel) {
        
        UILabel *resourceTitleLabel = [[UILabel alloc]init];
        [self.view addSubview:resourceTitleLabel];
        [resourceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.periodLabel);
            make.top.equalTo(self.periodLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(@20);
        }];
        [resourceTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [resourceTitleLabel setTextColor:LightGray];
        [resourceTitleLabel setFont:[UIFont systemFontOfSize:11]];
        [resourceTitleLabel setText:@"债权来源："];
        
        _resourceLabel = [[UILabel alloc]init];
        [self.view addSubview:_resourceLabel];
        [_resourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(resourceTitleLabel.mas_right);
            make.centerY.equalTo(resourceTitleLabel);
            make.height.mas_equalTo(@15);
        }];
        [_resourceLabel setTextAlignment:NSTextAlignmentCenter];
        [_resourceLabel setTextColor:DarkGray];
        [_resourceLabel setFont:[UIFont systemFontOfSize:11]];
    }
    return _resourceLabel;
}

- (UILabel *)totalNumLabel {
    
    if(!_totalNumLabel) {
        
        UILabel *totalNumTitleLabel = [[UILabel alloc]init];
        [self.view addSubview:totalNumTitleLabel];
        [totalNumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view).offset(40);
            make.centerY.equalTo(self.resourceLabel);
            make.height.mas_equalTo(@20);
        }];
        [totalNumTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [totalNumTitleLabel setTextColor:LightGray];
        [totalNumTitleLabel setFont:[UIFont systemFontOfSize:11]];
        [totalNumTitleLabel setText:@"债权总数："];
        
        _totalNumLabel = [[UILabel alloc]init];
        [self.view addSubview:_totalNumLabel];
        [_totalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(totalNumTitleLabel.mas_right);
            make.centerY.equalTo(totalNumTitleLabel);
            make.height.mas_equalTo(@15);
        }];
        [_totalNumLabel setTextAlignment:NSTextAlignmentCenter];
        [_totalNumLabel setTextColor:DarkGray];
        [_totalNumLabel setFont:[UIFont systemFontOfSize:11]];
        
    }
    return _totalNumLabel;
}

- (GZPurchaseProgressView *)progressView {
    
    if(!_progressView) {
        
//        backgroundImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"进度条模块底色背景"]];
        backgroundImgView = [[UIImageView alloc] init];
        backgroundImgView.backgroundColor = [UIColor clearColor];
        backgroundImgView.userInteractionEnabled = YES;
        [self.view addSubview:backgroundImgView];
        [backgroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.resourceLabel.mas_bottom).offset(8);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(@50);
        }];
        
        _progressView = [[GZPurchaseProgressView alloc]initWithFrame:CGRectMake(0, 0, DMDeviceWidth-140, 3)];
        [backgroundImgView addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundImgView).offset(90);
            make.centerY.equalTo(backgroundImgView);
             make.width.mas_equalTo(@(DMDeviceWidth-140));
        }];
        
        self.currentDetailBtn = [[UIButton alloc]init];
        [backgroundImgView addSubview:_currentDetailBtn];
        [_currentDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_progressView.mas_left);
            make.centerY.equalTo(backgroundImgView);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@90);
        }];
        
        [_currentDetailBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        //[currentDetailBtn.titleLabel setAttributedText:attStr];
        [_currentDetailBtn addTarget:self action:@selector(currentDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _progressLabel = [[UILabel alloc]init];
        [backgroundImgView addSubview:_progressLabel];
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backgroundImgView).offset(-5);
            make.centerY.equalTo(backgroundImgView);
            make.height.mas_equalTo(@20);
        }];
        [_progressLabel setTextAlignment:NSTextAlignmentCenter];
        [_progressLabel setTextColor:DarkGray];
        [_progressLabel setFont:[UIFont systemFontOfSize:11]];
    }
    return _progressView;
}

- (UITableView *)debtsListTableView {
    
    if(!_debtsListTableView) {
        
        _debtsListTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_debtsListTableView];
        [_debtsListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backgroundImgView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        _debtsListTableView.backgroundColor = [UIColor clearColor];
        _debtsListTableView.showsVerticalScrollIndicator = NO;
        _debtsListTableView.showsHorizontalScrollIndicator = NO;
        _debtsListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _debtsListTableView.delegate = self;
        _debtsListTableView.dataSource = self;
        [_debtsListTableView registerClass:[GZSinglePeriodTableViewCell self] forCellReuseIdentifier:@"SinglePeriodCell"];
        _debtsListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        [self.view addSubview:_debtsListTableView];
        
    }
    return _debtsListTableView;
}

- (NSMutableArray *)dataSource {
    
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GZSinglePeriodTableViewCell *cell = [GZSinglePeriodTableViewCell cellWithTableView:self.debtsListTableView];
    [cell setOrderLabelWithNum:[NSString stringWithFormat:@"%d",indexPath.row+1]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // cell.loanModel = self.dataSource[indexPath.row];
    [cell setLoanModel:self.dataSource[indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DMCreditDetailController *creditVC = [[DMCreditDetailController alloc] init];
    DMSingleLoanModel *loanModel = self.dataSource[indexPath.row];
    creditVC.loanId = loanModel.loadId;
    creditVC.guarantyStyle = loanModel.guarantyStyle;
    creditVC.title = loanModel.title;
    NSLog(@"%@",loanModel.guarantyStyle);
    [self.navigationController pushViewController:creditVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - click action 

//持有资产详情
- (void)investDetailBtnClick {
    
    DMHoldingAssetsViewController *havc = [[DMHoldingAssetsViewController alloc]init];
    havc.push = YES;
    havc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:havc animated:YES];
    
}
//筹标进度
- (void)currentDetailBtnClick {
    
    DMCurrentClaimsViewController *ccvc = [[DMCurrentClaimsViewController alloc]init];
    ccvc.navigationItem.title = @"本期债权";
    ccvc.assetId = self.assetId;
    [self.navigationController pushViewController:ccvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)switchType:(NSString *)type{
    if ([type isEqualToString:@"CarPledge"]) {
        return @"车辆质押";
    }else if ([type isEqualToString:@"CarInsurance"]) {
        return @"车保智投";
    }else if ([type isEqualToString:@"ConsumerInstallment"]) {
        return @"分期慧投";
    }else if ([type isEqualToString:@"CarMortgate"]) {
        return @"车辆抵押";
    }else if ([type isEqualToString:@"FinanceLease"]) {
        return @"融资租赁";
    }else {
        return @"";
    }
}

@end
