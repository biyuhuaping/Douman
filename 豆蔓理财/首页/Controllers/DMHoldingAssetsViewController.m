//
//  DMHoldingAssetsViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMHoldingAssetsViewController.h"
#import "DMHoldingAssetsTableViewCell.h"
#import "DMHoldDetailsViewController.h"
#import "DMSettledAssetsViewController.h"
#import "iCarouselView.h"
#import "GZHomePageRequestManager.h"
#import "DMCurrentClaimsViewController.h"

@interface DMHoldingAssetsViewController ()<UITableViewDelegate, UITableViewDataSource,iCarouselScrolling>
{
    
    BOOL isOpan;
    NSString *repaymethod;
    NSString *orderType;
    NSString *months;
}

@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong)iCarouselView *icar;

@property (nonatomic, strong)UIButton * slideBtn;

@property(nonatomic, strong)UILabel *unclearedL;
@property(nonatomic, strong)UIButton *ScreenBtn;
@property(nonatomic, strong)UIView *ScreenView;

@property(nonatomic, strong)UITableView *ListTv;



//数据
@property (nonatomic, strong)NSMutableArray *dataSource;


@end

@implementation DMHoldingAssetsViewController


- (instancetype) init {
    
    self = [super init];
    if (self) {
        isOpan = false;
        repaymethod = @"";
        orderType = @"periods";
        months = @"";
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self CreateNav];
    
    self.title = @"持有资产";
    
    [self.view addSubview:self.icar];
    [self.view addSubview:self.unclearedL];
    [self.view addSubview:self.ScreenBtn];
    [self.view addSubview:self.ScreenView];
    [self Createbutton];
    [self.view addSubview:self.ListTv];
    
    [self prepareForDataSourceWithPageNo:1 andPageSize:10 operation:UITableViewOperationPullDown];

}



- (iCarouselView *)icar {
    
    if (!_icar) {
        _icar = [[iCarouselView alloc] init];
        _icar.frame = CGRectMake(0, 15, DMDeviceWidth, 70);
        _icar.scroll = self;
        _icar.layer.masksToBounds= YES;
    }
    return _icar;
}
- (void)ScrollingAnimation:(NSInteger)tag{
    
    for (int i  = 0; i < 14; i ++) {
        if (i == tag) {
            months = [NSString stringWithFormat:@"%d",i];

            if (tag == 0) {
                months = @"";
            }
            continue;
 
        }
    }
    
    
    [[GZHomePageRequestManager defaultManager] requestForHomePageuserAccountWithUserId:USER_ID repaymethod:repaymethod orderType:orderType months:months page:@"" size:@"" isSevenBack:self.isSevenBack access_token:AccessToken successBlock:^(NSArray *arr,NSString *str) {
        
        self.dataSource = [NSMutableArray arrayWithArray:arr];
        _unclearedL.text = [NSString stringWithFormat:@"筛选范围内未结：%@元",[self getFormattedAmountOfNumberWithString:str]];
        [self.ListTv reloadData];
        [self.ListTv setContentOffset:CGPointMake(0, 0) animated:YES];
        [self setFootView];
        
    } failureBlock:^{
        
    }];
    self.isSevenBack = NO;
    
}

- (void)CreateNav {
    
    _slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _slideBtn.frame = CGRectMake(0, 0, 74, 54/2);
    [_slideBtn setBackgroundImage:[UIImage imageNamed:@"Cleared_button"] forState:UIControlStateNormal]; //////////////已结清
    [_slideBtn setBackgroundImage:[UIImage imageNamed:@"Cleared_button"] forState:UIControlStateHighlighted]; //////////////已结清
    [_slideBtn addTarget: self action:@selector(slideClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_slideBtn];
}

- (void)slideClick:(id)sender {
    
    
    DMSettledAssetsViewController *settled = [[DMSettledAssetsViewController alloc] init];
    [self.navigationController pushViewController:settled animated:YES];
    
}


- (UILabel *)unclearedL {
    
    if (!_unclearedL) {
        _unclearedL = [[UILabel alloc] init];
        _unclearedL.frame = CGRectMake((DMDeviceWidth - 200 - 170/2)/2, 100, 200, 12);
        _unclearedL.text = @"筛选范围内未结：0.00元";
        _unclearedL.font = SYSTEMFONT(12);
        _unclearedL.textColor = LightGray; ////////////
        
    }
    
    return _unclearedL;
    
}
- (UIButton *)ScreenBtn {
    
    if (!_ScreenBtn) {
        _ScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ScreenBtn.frame = CGRectMake(_unclearedL.frame.origin.x+_unclearedL.frame.size.width, 95, 170/2, 46/2);
        [_ScreenBtn setImage:[UIImage imageNamed:@"screening_button"] forState:UIControlStateNormal];//////////筛选排序
         [_ScreenBtn setImage:[UIImage imageNamed:@"screening_button"] forState:UIControlStateHighlighted];//////////筛选排序
        [_ScreenBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _ScreenBtn;
    
}

- (void)Click:(id)sender {
    
    if (isOpan == false) {
        isOpan = true;
        
        [_ScreenBtn setImage:[UIImage imageNamed:@"screening_button_up"] forState:UIControlStateNormal]; ///////////筛选向上
        [_ScreenBtn setImage:[UIImage imageNamed:@"screening_button_up"] forState:UIControlStateHighlighted];///////////筛选向上
        [_ScreenView setHidden:FALSE];
        _ScreenView.frame = CGRectMake(0, 125, DMDeviceWidth, 91);
        _ListTv.frame = CGRectMake(0, 125 + 91, DMDeviceWidth, DMDeviceHeight - 125 - 91 - 64);


        
    } else {
         [_ScreenBtn setImage:[UIImage imageNamed:@"screening_button"] forState:UIControlStateNormal]; //////////筛选排序
        [_ScreenBtn setImage:[UIImage imageNamed:@"screening_button"] forState:UIControlStateHighlighted]; //////////筛选排序
        isOpan = false;
        _ListTv.frame = CGRectMake(0, 125, DMDeviceWidth, DMDeviceHeight - 125-64);
        [_ScreenView setHidden:YES];
        
    }
}


- (UIView *)ScreenView {
    
    if (!_ScreenView) {
        _ScreenView = [[UIView alloc] init];
        _ScreenView.frame = CGRectMake(0, 125, DMDeviceWidth, 91);
        _ScreenView.backgroundColor = UIColorFromRGB(0xe7e7e7); ////////////////blackColor
        [_ScreenView setHidden:YES];
    }
    

    return _ScreenView;
}

- (void)Createbutton {
    
    UILabel *screen = [[UILabel alloc] init];
    screen.frame = CGRectMake(21, 19, 40, 12);
    screen.text = @"排序：";
    screen.textColor = LightGray; /////////4b6ca7
    screen.font = SYSTEMFONT(12);
    [_ScreenView addSubview:screen];
    
    
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    scrollview.frame = CGRectMake(60, 0, DMDeviceWidth - 60, 40);
    scrollview.contentSize = CGSizeMake(320, 0);
    [_ScreenView addSubview:scrollview];
    
    NSArray *arr = @[@"默认",@"最近结算日",@"已结期数",@"结清日期"];
    for (int i = 0; i < arr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(60 +80*i, 14, 70, 23);
        [button setBackgroundImage:[UIImage imageNamed:@"selected_button"] forState:UIControlStateSelected];/////// 本金利息筛选框
        [button setBackgroundImage:[UIImage imageNamed:@"selected_button"] forState:UIControlStateHighlighted];/////// 本金利息筛选框
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitle:arr[i] forState:UIControlStateSelected];
        [button setTitleColor:DarkGray forState:UIControlStateNormal]; /////////86a7e8
        [button setTitleColor:MainRed forState:UIControlStateSelected]; ///////////////50f1bf
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = SYSTEMFONT(12);
        button.tag = i + 300;
        if (i == 0) {
            button.selected = YES;
        }

        if (iPhone5) {
            
            button.frame = CGRectMake(0 + 80*i, 14, 70, 23);
            [scrollview addSubview:button];
            
        } else {
        [_ScreenView addSubview:button];
        }
    }
    
    UILabel *styleL = [[UILabel alloc] init];
    styleL.frame = CGRectMake(21, 19 + 41, 40, 12);
    styleL.text = @"类型：";
    styleL.textColor = LightGray; ////////////4b6ca7
    styleL.font = SYSTEMFONT(12);
    [_ScreenView addSubview:styleL];
    
    NSArray *style = @[@"全部",@"等额本息",@"按月付息"];
    
    for (int i = 0; i < style.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(60 +100*i, 55, 70, 23);
        
        if (iPhone5) {
            button.frame = CGRectMake(60 + 80*i, 55, 70, 23);
        }
        
        [button setBackgroundImage:[UIImage imageNamed:@"selected_button"] forState:UIControlStateSelected];/////// 本金利息筛选框
        [button setBackgroundImage:[UIImage imageNamed:@"selected_button"] forState:UIControlStateHighlighted];/////// 本金利息筛选框
        [button setTitle:style[i] forState:UIControlStateNormal];
        [button setTitle:style[i] forState:UIControlStateSelected];
        [button setTitleColor:DarkGray forState:UIControlStateNormal]; //////////86a7e8
        [button setTitleColor:MainRed forState:UIControlStateSelected]; //////////////50f1bf
        [button addTarget:self action:@selector(StylebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = SYSTEMFONT(12);

        button.tag = i + 400;
        if (i == 0) {
            button.selected = YES;
        }
        [_ScreenView addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)button {
    
    for (int i = 0; i < 4; i ++) {
        if (button.tag == 300+i) {
            button.selected = YES;
            
            
            switch (i) {
                case 0:
                    orderType = @"periods";
                    break;
                case 1:
                    orderType = @"nextSettleTime";
                    break;
                case 2:
                    orderType = @"lastSettleTime";
                    break;
                case 3:
                    orderType = @"settlePeriod";
                    break;
                default:
                    break;
            }
            
            
            [[GZHomePageRequestManager defaultManager] requestForHomePageuserAccountWithUserId:USER_ID repaymethod:repaymethod orderType:orderType months:months page:@"" size:@"" isSevenBack:NO access_token:AccessToken successBlock:^(NSArray *arr,NSString *str) {
                
                self.dataSource = [NSMutableArray arrayWithArray:arr];

                _unclearedL.text = [NSString stringWithFormat:@"筛选范围内未结：%@元",[self getFormattedAmountOfNumberWithString:str]];
                [self.ListTv reloadData];
                [self.ListTv setContentOffset:CGPointMake(0, 0) animated:YES];
                [self setFootView];
                
            } failureBlock:^{
                
            }];
            
            


            continue;
            
            
            
            
            
        }
        UIButton *otherBtn = (UIButton *)[self.view viewWithTag:300+i];
        otherBtn.selected = NO;
    }
    
    
    [_ScreenBtn setImage:[UIImage imageNamed:@"screening_button"] forState:UIControlStateNormal]; ////////////筛选排序
    [_ScreenBtn setImage:[UIImage imageNamed:@"screening_button"] forState:
     UIControlStateHighlighted]; ////////////筛选排序
    isOpan = false;
    _ListTv.frame = CGRectMake(0, 125, DMDeviceWidth, DMDeviceHeight - 125-64);
    [_ScreenView setHidden:YES];
    
    
}



- (void)StylebuttonClick:(UIButton *)button {
    
    for (int i = 0; i < 3; i ++) {
        if (button.tag == 400+i) {
            button.selected = YES;
            
            switch (i) {
                case 0:
                    repaymethod = @"";
                    break;
                case 1:
                    repaymethod = @"EqualInstallment";
                    break;
                case 2:
                    repaymethod = @"MonthlyInterest";
                    break;

                default:
                    break;
            }
            
            
            [[GZHomePageRequestManager defaultManager]requestForHomePageuserAccountWithUserId:USER_ID repaymethod:repaymethod orderType:orderType months:months page:@"" size:@"" isSevenBack:NO access_token:AccessToken successBlock:^(NSArray *arr,NSString *str) {
                
                self.dataSource = [NSMutableArray arrayWithArray:arr];
               _unclearedL.text = [NSString stringWithFormat:@"筛选范围内未结：%@元",[self getFormattedAmountOfNumberWithString:str]];
                [self.ListTv reloadData];
                [self.ListTv setContentOffset:CGPointMake(0, 0) animated:YES];
                [self setFootView];
                
                
            } failureBlock:^{

            }];
            continue;
        }
        UIButton *otherBtn = (UIButton *)[self.view viewWithTag:400+i];
        otherBtn.selected = NO;
    }
    
    
    [_ScreenBtn setImage:[UIImage imageNamed:@"screening_button"] forState:UIControlStateNormal]; /////////////筛选排序
     [_ScreenBtn setImage:[UIImage imageNamed:@"screening_button"] forState:UIControlStateHighlighted]; //////////筛选排序
    isOpan = false;
    _ListTv.frame = CGRectMake(0, 125, DMDeviceWidth, DMDeviceHeight - 125 - 64);
    [_ScreenView setHidden:YES];
    
}




- (UITableView *)ListTv {
    
    if (!_ListTv) {
        
        _ListTv = [[UITableView alloc] initWithFrame:CGRectMake(0, 125, DMDeviceWidth, DMDeviceHeight - 125 - 64) style:UITableViewStylePlain];
        _ListTv.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTv.backgroundColor = [UIColor clearColor];
        _ListTv.delegate = self;
        _ListTv.dataSource = self;
        
        
        __weak DMHoldingAssetsViewController *weakSelf = self;

        
        _ListTv.mj_header = [self setRefreshHeader:^{
            weakSelf.currentPage = 1;
            [weakSelf prepareForDataSourceWithPageNo:weakSelf.currentPage andPageSize:10 operation:UITableViewOperationPullDown];
        }];
        _ListTv.mj_header.automaticallyChangeAlpha = YES;
        _ListTv.mj_footer = [self setRefreshFooter:^{
            weakSelf.currentPage = weakSelf.currentPage + 1;
            [weakSelf prepareForDataSourceWithPageNo:weakSelf.currentPage andPageSize:10 operation:UITableViewOperationPullUp];
        }];
    }
    
    return _ListTv;
    
}



#pragma mark - Networking Request
- (void)prepareForDataSourceWithPageNo:(int)pageNo andPageSize:(int)pageSize operation:(UITableViewOperation)operation{
    
    [[GZHomePageRequestManager defaultManager]requestForHomePageuserAccountWithUserId:USER_ID repaymethod:repaymethod orderType:orderType months:months page:[NSString stringWithFormat:@"%d",pageNo] size:[NSString stringWithFormat:@"%d",pageSize] isSevenBack:self.isSevenBack access_token:AccessToken successBlock:^(NSArray *arr,NSString *str) {
        
        if(operation == UITableViewOperationPullDown) { //下拉刷新
            self.dataSource = nil;
            self.dataSource = [NSMutableArray arrayWithArray:arr];
            [_ListTv reloadData];
            [self setFootView];
            [_ListTv.mj_header endRefreshing];
        }else {//上拉加载
            [self.dataSource addObjectsFromArray:arr];
            [_ListTv reloadData];
            [self setFootView];
            [_ListTv.mj_footer endRefreshing];
        }
    }failureBlock:^(NSError *err) {
        [_ListTv.mj_header endRefreshing];
        [_ListTv.mj_footer endRefreshing];
        if(operation == UITableViewOperationPullUp) {
            self.currentPage -= 1;
        }
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(self.dataSource.count != 0){ //当前月份存在数据
        return nil;
    }else { //当前月份不存在数据
        
        static NSString *headerSectionID = @"cityHeaderSectionID";
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
        if (headerView == nil)
        {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerSectionID];
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.frame = CGRectMake(5, 0, 200, 30);
            titleLabel.textColor = [UIColor purpleColor];
            titleLabel.tag = 100;
            [headerView addSubview:titleLabel];
        }
        
        return headerView;
    }
    
}

#pragma mark --- tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"123";
    DMHoldingAssetsTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(Cell == nil){
        Cell = [[DMHoldingAssetsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Cell.model = self.dataSource[indexPath.row];
    if (!Cell.model.isLoanEnd) {
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Cell.backgroundColor = [UIColor clearColor];
    Cell.textLabel.backgroundColor = [UIColor clearColor];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DMHoldDetailsViewController *holdDetails = [[DMHoldDetailsViewController alloc] init];
    
    DMHoldingAssetsModel *model = [[DMHoldingAssetsModel alloc] init];
    model = self.dataSource[indexPath.row];
    

    holdDetails.assetId = model.assetId;
    holdDetails.storeId = model.storeId;
    
    if ([model.isLoanEnd isEqualToString:@"0"]) {
        
        if (self.push) {
            DMCurrentClaimsViewController *current = [[DMCurrentClaimsViewController alloc] init];
            current.assetId = model.storeId;
            [self.navigationController pushViewController:current animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController pushViewController:holdDetails animated:YES];
    }
}



- (void)setFootView{
    if (self.dataSource.count == 0) {
        UILabel *label = [UILabel initWithFrame:CGRectMake(0, 100, DMDeviceWidth, 400)
                                           Font:17
                                           Text:@"当前期限暂无记录"
                                      Alignment:NSTextAlignmentCenter
                                      TextColor:LightGray]; /////////////////ffffff
        self.ListTv.tableFooterView = label;
    }else{
        self.ListTv.tableFooterView = [UIView new];
    }
}


//格式化金额数目
- (NSString *)getFormattedAmountOfNumberWithString:(NSString *)str {
    
    NSString *strWithTwoDecimals = [NSString stringWithFormat:@"%.2f",str.doubleValue];
    
    NSArray *separatedStrs = [strWithTwoDecimals componentsSeparatedByString:@"."];
    
    NSMutableString *mutableStr = [NSMutableString stringWithCapacity:20];
    
    for(int i=1;i<=[separatedStrs[0] length];i++) {
        
        [mutableStr insertString:[separatedStrs[0] substringWithRange:NSMakeRange([separatedStrs[0] length]-i, 1)] atIndex:0];
        
        if(i%3==0 && i != [separatedStrs[0] length]) {
            [mutableStr insertString:@"," atIndex:0];
        }
    }
    
    [mutableStr appendString:@"."];
    [mutableStr appendString:separatedStrs[1]];
    
    return mutableStr;
}



@end
