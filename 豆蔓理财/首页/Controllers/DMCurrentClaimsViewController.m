//
//  DMCurrentClaimsViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/12/6.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMCurrentClaimsViewController.h"
#import "DMAnimationIndicator.h"
#import "DMHoldingAssetsViewController.h"
#import "DMHoldDetailsViewController.h"
#import "DMCreditDetailController.h"
#import "GZHomePageRequestManager.h"

#import "DMCurrentClaimsTableViewCell.h"
#import "DMLoginViewController.h"


@interface DMCurrentClaimsViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UILabel *bidNumberL;
    UILabel *guarantStyleL;
    UILabel *sourceOfAssetsL;
    UILabel *totalAmountL;
    
    int currentPage;
    
    NSString *str;
}

@property (nonatomic, strong)UIButton *detailsB;
@property (nonatomic, strong)UILabel *stageL;
@property (nonatomic, strong)UIImageView *CircularImg;
@property (nonatomic, strong)UIButton *noticeB;
@property (nonatomic, strong)UITableView *CurrenClaimsTV;
@property (nonatomic, strong)DMAnimationIndicator *indicator;

@property (nonatomic, strong)UIButton *button;

@property (nonatomic, assign)CGFloat proportion;
@property (nonatomic, assign)BOOL sure;

//数据
@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong) UIButton *abutton;
@property (nonatomic, strong) UIImageView *bottomLine;


@end

@implementation DMCurrentClaimsViewController


- (instancetype) init {
    
    self = [super init];
    if (self) {
        
        _proportion = 375.00/320.00;
        _sure = true;

        currentPage =1;
    }
    return self;
}

#pragma mark - Life Cycle


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[GZHomePageRequestManager defaultManager] requestForHomePageLoansInfoOfAssetWithAssetID:self.assetId UserID:USER_ID successBlock:^(BOOL result, NSString *message, NSString *sourceOfAssets, NSString *periods, NSString *guarantStyle, NSString *totalAmount, NSString *bidNumber, NSString *totalBidpercent, NSNumber *userHasLoan, NSString *assetId, NSString *guarant) {
        
        
        if (result) {
            _stageL.text = [NSString stringWithFormat:@"第%@期",periods];
            bidNumberL.text = [NSString stringWithFormat:@"债权个数:%@",bidNumber];
            
            if ([guarantStyle isEqualToString:@"车险分期"]) {
                guarantStyle =@"车保智投";
            }
            str = guarantStyle;
            guarantStyleL.text  = [NSString stringWithFormat:@"%@类",guarantStyle];
            sourceOfAssetsL.text = [NSString stringWithFormat:@"来源:%@",sourceOfAssets];
            totalAmountL.text = [NSString stringWithFormat:@"债权总额:%@",totalAmount];
            _indicator.totalBidpercent= [totalBidpercent floatValue];
            if (userHasLoan.doubleValue == 0) {
            } else if (userHasLoan.doubleValue == 1){
                [self CreateNavstyle:@"1"];
            } else {
                [self CreateNavstyle:@"2"];
            }
        } else {
            ShowMessage(message);
        }

    } failureBlock:^(NSError *err) {
        
    }];

    
    [[GZHomePageRequestManager defaultManager]requestForHomePagegetLoanListWithAssetID:self.assetId Page:@"1" Size:@"10" successBlock:^(BOOL result, NSString *message, NSArray<GZLoanListModel *> *loanList, NSString *assetId) {
        if (result) {
            self.dataSource = [NSMutableArray arrayWithArray:loanList];
            [_CurrenClaimsTV reloadData];
        } else {
            ShowMessage(message);
        }

    } failureBlock:^(NSError *err) {
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"本期债权";

    [self.view addSubview:self.stageL];
    [self.view addSubview:self.CreateCircularImg];
    [self.view addSubview:self.indicator];
    [self.view addSubview:self.bottomLine];
    [self Createnotice];
    [self.view addSubview:self.CurrenClaimsTV];
    [self.view addSubview:self.button];
    
    [self data];
    
    
}

- (void)data {
    
    bidNumberL = [[UILabel alloc] init];
    bidNumberL.frame = CGRectMake(25, 70, 75, 14);
    if (iPhone6plus) {
        bidNumberL.frame = CGRectMake((DMDeviceWidth - 375) + 5, 70, 75, 14);
    } else if (iPhone5){
        bidNumberL.frame = CGRectMake((DMDeviceWidth - 375) + 75, 67, 70, 14);
    }
    bidNumberL.font = SYSTEMFONT(12);
    bidNumberL.textAlignment = NSTextAlignmentCenter;
    bidNumberL.textColor = LightGray; /////////////86a7e8
    [self.view addSubview: bidNumberL];
    
    
    guarantStyleL = [[UILabel alloc] init];
    guarantStyleL.frame = CGRectMake(DMDeviceWidth - 30 - 75, 100, 75, 14);
    if (iPhone6plus) {
        guarantStyleL.frame = CGRectMake(DMDeviceWidth - 30 - 75 - (DMDeviceWidth - 375) + 20, 100, 75, 14);
    }else if (iPhone5){
        guarantStyleL.frame = CGRectMake(DMDeviceWidth - 30 - 63, 93, 70, 14);
    }
    guarantStyleL.font = SYSTEMFONT(12);
    guarantStyleL.textAlignment = NSTextAlignmentCenter;
    guarantStyleL.textColor = UIColorFromRGB(0x51e0a2);
    [self.view addSubview: guarantStyleL];

    
    sourceOfAssetsL = [[UILabel alloc] init];
    sourceOfAssetsL.frame = CGRectMake(10, 250, 80, 14);
    if (iPhone6plus) {
        sourceOfAssetsL.frame = CGRectMake(10 + (DMDeviceWidth - 375) -20, 250, 80, 14);
    }else if (iPhone5){
        sourceOfAssetsL.frame = CGRectMake(10,220, 70, 14);
    }
    sourceOfAssetsL.font = SYSTEMFONT(12);
    sourceOfAssetsL.textAlignment = NSTextAlignmentCenter;
    sourceOfAssetsL.textColor = MainRed; /////////////ffd542
    [self.view addSubview:sourceOfAssetsL];
    
    totalAmountL = [[UILabel alloc] init];
    totalAmountL.frame = CGRectMake(DMDeviceWidth - 15 - 110, 272, 110, 14);
    if (iPhone6plus) {
        totalAmountL.frame = CGRectMake(DMDeviceWidth - 15 - 110 - (DMDeviceWidth - 375) + 20, 272, 110, 14);
    }else if (iPhone5){
        totalAmountL.frame = CGRectMake(DMDeviceWidth - 110,242, 90, 14);
    }
    
    totalAmountL.font = SYSTEMFONT(12);
    totalAmountL.textAlignment = NSTextAlignmentCenter;
    totalAmountL.textColor = LightGray; ////////////86a7e8
    [self.view addSubview:totalAmountL];
 
}


- (void)CreateNavstyle:(NSString *)style {
    _detailsB = [UIButton buttonWithType:UIButtonTypeCustom];
    _detailsB.frame = CGRectMake(0, 0, 158/2, 52/2);
    _detailsB.adjustsImageWhenHighlighted = NO;
    _detailsB.layer.cornerRadius = 52/4;
    _detailsB.titleLabel.font = [UIFont systemFontOfSize:12];
    _detailsB.layer.borderWidth = 0.5;
    _detailsB.layer.borderColor = MainRed.CGColor;
    [_detailsB setTitle:@"持有详情" forState:UIControlStateNormal];
    [_detailsB setTitleColor:MainRed forState:UIControlStateNormal];
//    [_detailsB setImage:[UIImage imageNamed:@"持有详情1"] forState:UIControlStateNormal];
    if ([style isEqualToString:@"1"]) {
        
         [_detailsB addTarget: self action:@selector(detailsClick:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        
         [_detailsB addTarget: self action:@selector(nodetailsClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_detailsB];
}

///跳到列表页面
- (void)detailsClick:(id)sender {
    DMHoldingAssetsViewController *holdingassets = [[DMHoldingAssetsViewController alloc] init];
    holdingassets.push = NO;
    [self.navigationController pushViewController:holdingassets animated:YES];
}

///跳到详情页面
- (void)nodetailsClick:(id)sender {
    
    DMHoldDetailsViewController *holddetails = [[DMHoldDetailsViewController alloc] init];
    holddetails.assetId = self.assetId;
    [self.navigationController pushViewController:holddetails animated:YES];
    
}


- (UILabel *)stageL {
    
    if (!_stageL) {
        _stageL = [[UILabel alloc] init];
        _stageL.frame = CGRectMake(0, 21, DMDeviceWidth, 12);
        _stageL.font = SYSTEMFONT(14);
        _stageL.textAlignment = NSTextAlignmentCenter;
        _stageL.textColor = DarkGray; ////////////86a7e8
    }
    
    return _stageL;
}
- (UIImageView *) CreateCircularImg {
    
    if (!_CircularImg) {
        _CircularImg = [[UIImageView alloc] init];
        _CircularImg.userInteractionEnabled = YES;
        _CircularImg.frame = CGRectMake((DMDeviceWidth - 647/2)/2-4, 90, 647/2, 345/2);
        if (iPhone5) {
            
            CGFloat wight = 375/DMDeviceWidth;
            
            _CircularImg.frame = CGRectMake(0, 52, DMDeviceWidth, 250/wight);
        }
        _CircularImg.image = [UIImage imageNamed:@"_---------@2x(1)"];
    }
    return _CircularImg;
}
- (DMAnimationIndicator *)indicator {
    
    if (!_indicator) {
        
        if (iPhone5) {
            _indicator = [[DMAnimationIndicator alloc]initWithFrame:CGRectMake(6.5+25, 14+25, 240, 240) totalBidpercent:0.70];
        } else if(iPhone6){
             _indicator = [[DMAnimationIndicator alloc]initWithFrame:CGRectMake(23+ 25, 23+25, 260, 260) totalBidpercent:0.70];
        } else {
            _indicator = [[DMAnimationIndicator alloc]initWithFrame:CGRectMake(43+ 25, 23+25, 260, 260)  totalBidpercent:0.70];
        }
        
        [self.view addSubview:_indicator];
    }
    return _indicator;
}


- (UIImageView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.indicator.mj_y+self.indicator.mj_h, SCREENWIDTH, 8)];
        _bottomLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _bottomLine;
}


- (void)Createnotice {

        UIView *notice = [[UIView alloc] init];
        notice.frame = CGRectMake((DMDeviceWidth - 190)/2, self.indicator.mj_y+self.indicator.mj_h+30, 190, 14);
        [self.view addSubview:notice];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 130, 14);
        label.text = @"满标生成合同后计息";
        label.textColor = DarkGray; ///////////////86a7e8
        label.font = SYSTEMFONT(14);
        [notice addSubview:label];
        
        _abutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _abutton.frame = CGRectMake(129.5, 0, 14, 14);
        [_abutton setBackgroundImage:[UIImage imageNamed:@"通知我-勾选"] forState:UIControlStateNormal]; ///////////椭圆-勾选
        [_abutton addTarget:self action:@selector(noticeBAction) forControlEvents:UIControlEventTouchUpInside];
        //_abutton.adjustsImageWhenHighlighted = NO;

        [notice addSubview:_abutton];
        
        UILabel *labela = [[UILabel alloc] init];
        labela.frame = CGRectMake(144, 0, 46, 14);
        labela.text = @"通知我";
        labela.textColor = MainRed; ////////////////ffd542
        labela.font = SYSTEMFONT(14);
        [notice addSubview:labela];
        
       

}

- (void)noticeBAction {
    
    
    if (!_sure) {
        _sure = true;
        [_abutton setBackgroundImage:[UIImage imageNamed:@"通知我-勾选"] forState:UIControlStateNormal]; /////////////椭圆-勾选

    } else {
        _sure = false;
        [_abutton setBackgroundImage:[UIImage imageNamed:@"通知我-未勾选"] forState:UIControlStateNormal]; /////////////椭圆

    }
}

- (UITableView *)CurrenClaimsTV {
    
    if (!_CurrenClaimsTV) {
        
        
        _CurrenClaimsTV = [[UITableView alloc] initWithFrame:CGRectMake(0, _CircularImg.frame.origin.y+_CircularImg.frame.size.height+24 + 60, DMDeviceWidth, DMDeviceHeight - 326) style:UITableViewStyleGrouped];
        _CurrenClaimsTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _CurrenClaimsTV.backgroundColor = [UIColor clearColor];
        _CurrenClaimsTV.delegate = self;
        _CurrenClaimsTV.dataSource = self;
        __weak DMCurrentClaimsViewController *weakSelf = self;
        
        
        _CurrenClaimsTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            currentPage = 1;
            [weakSelf prepareForDataSourceWithPageNo:currentPage andPageSize:10 operation:UITableViewOperationPullDown];
            
        }];
        _CurrenClaimsTV.mj_header.automaticallyChangeAlpha = YES;
        
        
        _CurrenClaimsTV.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            currentPage = currentPage + 1;
            [weakSelf prepareForDataSourceWithPageNo:currentPage andPageSize:10 operation:UITableViewOperationPullUp];
        }];
        
        
//        UIImageView *Line = [[UIImageView alloc] init];
//        Line.frame = CGRectMake(5, _CircularImg.frame.origin.y+_CircularImg.frame.size.height+23 + 14, DMDeviceWidth - 10,1);
//        Line.image = [UIImage imageNamed:@"持有-分割线"];
//        [self.view addSubview:Line];
        
    }
    return _CurrenClaimsTV;
}

- (UIButton *)button {
    
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(DMDeviceWidth - 60, DMDeviceHeight - 60, 24, 24);
        [_button setImage:[UIImage imageNamed:@"回到顶端"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [_button setHidden:YES];
        [self.view addSubview:_button];
    }
    
    return _button;

    
}

#pragma mark --顶端

- (void)Click:(id)sender {
    
    [self.CurrenClaimsTV setContentOffset:CGPointMake(0, 0) animated:YES];

}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    
    
    
    if (_CurrenClaimsTV.contentOffset.y > self.view.frame.size.height) {
        
        [self.button setHidden:NO];
        
    } else {
        
        [self.button setHidden:YES];
    }
    
    
}



#pragma mark - Networking Request
- (void)prepareForDataSourceWithPageNo:(int)pageNo andPageSize:(int)pageSize operation:(UITableViewOperation)operation{
    
    
    //get请求
    [[GZHomePageRequestManager defaultManager]requestForHomePagegetLoanListWithAssetID:self.assetId Page:[NSString stringWithFormat:@"%d",pageNo] Size:[NSString stringWithFormat:@"%d",pageSize]  successBlock:^(BOOL result, NSString *message, NSArray<GZLoanListModel *> *loanList, NSString *assetId)  {
        
        if(operation == UITableViewOperationPullDown) { //下拉刷新
            
            self.dataSource = [NSMutableArray arrayWithArray:loanList];
            [[HUDManager manager ] hide];
            [_CurrenClaimsTV reloadData];
            [_CurrenClaimsTV.mj_header endRefreshing];
            [_CurrenClaimsTV.mj_footer endRefreshing];
            
        }else {//上拉加载
            
            [self.dataSource addObjectsFromArray:loanList];
            
            [_CurrenClaimsTV reloadData];
            [_CurrenClaimsTV.mj_footer endRefreshing];
        }
        
    }
        failureBlock:^(NSError *err) {
            if(operation == UITableViewOperationPullUp) {
                currentPage -= 1;
            }
                                                                             
    }];
}



#pragma mark --- tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, DMDeviceWidth, 35 + 13);
    
    UILabel *SerialNumberL = [[UILabel alloc] init];
    SerialNumberL.frame = CGRectMake(30, 35, 30, 13);
    SerialNumberL.font = SYSTEMFONT(13);
    SerialNumberL.text = @"序号";
    SerialNumberL.textColor = MainRed; ///////////////ffd542
    [view addSubview:SerialNumberL];
    
    UILabel *NameL = [[UILabel alloc] init];
    NameL.frame = CGRectMake(10 + 30 + 86, 35, 60, 13);
    NameL.font = SYSTEMFONT(13);
    NameL.text = @"债权名称";
    NameL.textColor = MainRed; ///////////////ffd542
    [view addSubview:NameL];
    
    UILabel *Money = [[UILabel alloc] init];
    Money.frame = CGRectMake(DMDeviceWidth - 30 - 60, 35, 60, 13);
    Money.font = SYSTEMFONT(13);
    Money.text = @"债权金额";
    Money.textColor = MainRed; ///////////////ffd542
    [view addSubview:Money];
    
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 53;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 48;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"123";
    
    
    DMCurrentClaimsTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(Cell == nil){
        
        Cell = [[DMCurrentClaimsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    Cell.Num.text = [NSString stringWithFormat:@"%lu",(long)indexPath.row+1];
    Cell.model = self.dataSource[indexPath.row];
    Cell.backgroundColor = [UIColor clearColor];
    Cell.textLabel.backgroundColor = [UIColor clearColor];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (USER_ID) {
        
        DMCreditDetailController *holdcredit = [[DMCreditDetailController alloc] init];
        
        self.model = self.dataSource[indexPath.row];
        
        holdcredit.loanId = self.model.loanId;
        holdcredit.guarantyStyle = str;
        holdcredit.navigationItem.title = self.model.loanTitle;
        
        [self.navigationController pushViewController:holdcredit animated:YES];
        
    } else{
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户未登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            

            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"登录" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            DMLoginViewController *login = [[DMLoginViewController alloc] init];
            
            login.current = YES;
            
            [self.navigationController pushViewController:login animated:YES];
            

        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];

    
        
    }
    
}



@end
