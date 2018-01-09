//
//  DMSettledAssetsViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMSettledAssetsViewController.h"
#import "DMSettledDetailsViewController.h"

#import "DMSettledAssetsTableViewCell.h"
#import "iCarouselView.h"
#import "GZHomePageRequestManager.h"
#import "DMSettledAssetsModel.h"

@interface DMSettledAssetsViewController ()<UITableViewDelegate,UITableViewDataSource,iCarouselScrolling>
{
    
    BOOL sure;
    
    NSString *repaymethod;
    NSString *amountType;
    NSString *months;
    
    
}

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong)iCarouselView *icar;
@property(nonatomic, strong)UILabel *unclearedL;

@property(nonatomic, strong)UIButton *ScreenBtn;
@property(nonatomic, strong)UIView *ScreenView;
@property(nonatomic, strong)UIButton *SortBtn;

@property(nonatomic, strong)UIImageView *line;
@property(nonatomic, strong)UIImageView *siftImg;
@property(nonatomic, strong)UITableView *ListTV;

@property (nonatomic, strong)UIButton * slideBtn;

//数据
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation DMSettledAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"已结清资产";
    [self CreateNav];
    [self.view addSubview:self.icar];
    [self.view addSubview:self.ScreenBtn];
    [self.view addSubview:self.ScreenView];
    [self Createbutton];
    [self.view addSubview:self.unclearedL];
    [self.view addSubview:self.SortBtn];
    [self.view addSubview:self.line];
    [self.view addSubview:self.ListTV];
    
    [self.view addSubview:self.siftImg];
 
    
    
}
 // 已结清、持有中
- (instancetype) init {
    
    self = [super init];
    if (self) {
        sure = false;
        
        repaymethod = @"";
        amountType = @"settledAmount";
        months = @"";
        self.currentPage = 1;
    }
    return self;
}

- (void)CreateNav {
    
    _slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _slideBtn.frame = CGRectMake(0, 0, 74, 54/2);
    [_slideBtn setBackgroundImage:[UIImage imageNamed:@"hold_button"] forState:UIControlStateNormal]; ////////////持有中
    [_slideBtn setBackgroundImage:[UIImage imageNamed:@"hold_button"] forState:UIControlStateHighlighted]; ////////////持有中
    [_slideBtn addTarget: self action:@selector(slideClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_slideBtn];
}

-(void)slideClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [[GZHomePageRequestManager defaultManager] requestForSettledAssetesWithUserId:USER_ID repayMethod:repaymethod amountType:amountType months:months page:@"" size:@"" access_token:AccessToken successBlock:^(NSArray *arr, NSString *str) {
        
        self.dataSource = [NSMutableArray arrayWithArray:arr];
        
        _unclearedL.text = [NSString stringWithFormat:@"筛选范围内未结：%@元",[self getFormattedAmountOfNumberWithString:str]];
        [self.ListTV reloadData];
        [self.ListTV setContentOffset:CGPointMake(0, 0) animated:YES];
        [self setFootView];
        
    } failureBlock:^{
        
    }];
    
    
    
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




- (UIView *)ScreenView {
    
    if (!_ScreenView) {
        _ScreenView = [[UIView alloc] init];
        _ScreenView.frame = CGRectMake(0, 100, DMDeviceWidth, 41);
        _ScreenView.backgroundColor = UIColorFromRGB(0xe7e7e7); ///////////////blackColor
        
    }
    
    
    return _ScreenView;
}

- (void)Createbutton {
    

    NSArray *arr = @[@"全部",@"等额本息",@"按月付息"];
    for (int i = 0; i < arr.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((DMDeviceWidth - 70*3-50*2)/2 + (70+50)*i, (41-23)/2, 70, 23);
        if (iPhone5) {
            button.frame = CGRectMake((DMDeviceWidth - 70*3-30*2)/2 + (70+30)*i, (41-23)/2, 70, 23);
        }
        [button setBackgroundImage:[UIImage imageNamed:@"selected_button"] forState:UIControlStateSelected]; //////////本金利息筛选框
        [button setBackgroundImage:[UIImage imageNamed:@"selected_button"] forState:UIControlStateHighlighted]; //////////本金利息筛选框
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitle:arr[i] forState:UIControlStateSelected];
        [button setTitleColor:DarkGray forState:UIControlStateNormal]; ////////////86a7e8
        [button setTitleColor:MainRed forState:UIControlStateSelected]; /////////////50f1bf
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = SYSTEMFONT(12);
        button.tag = i + 300;
        if (i == 0) {
            button.selected = YES;
        }
        
        [_ScreenView addSubview:button];
    }
 }

- (void)buttonClick:(UIButton *)button {
    
    for (int i = 0; i < 3; i ++) {
        if (button.tag == 300+i) {
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
            
            
            [[GZHomePageRequestManager defaultManager] requestForSettledAssetesWithUserId:USER_ID repayMethod:repaymethod amountType:amountType months:months page:@"" size:@"" access_token:AccessToken successBlock:^(NSArray *arr, NSString *str) {
                
                self.dataSource = [NSMutableArray arrayWithArray:arr];
                _unclearedL.text = [NSString stringWithFormat:@"筛选范围内未结：%@元",[self getFormattedAmountOfNumberWithString:str]];
                [self.ListTV reloadData];
                [self.ListTV setContentOffset:CGPointMake(0, 0) animated:YES];
                [self setFootView];
                
            } failureBlock:^{
                
            }];


            
            continue;
        }
        UIButton *otherBtn = (UIButton *)[self.view viewWithTag:300+i];
        otherBtn.selected = NO;
    }
    
}

- (UILabel *)unclearedL {
    //154  184
    if (!_unclearedL) {
        _unclearedL = [[UILabel alloc] init];
        _unclearedL.frame = CGRectMake((DMDeviceWidth - 200 - 154/2)/2, 154, 200, 12);
        _unclearedL.text = @"筛选范围内未结：0.00元";
        _unclearedL.font = SYSTEMFONT(12);
        _unclearedL.textColor = LightGray; /////////////4b6ca7
    }
    return _unclearedL;
    
}

- (UIButton *)SortBtn {
    
    if (!_SortBtn) {
        _SortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _SortBtn.frame = CGRectMake(_unclearedL.frame.origin.x+_unclearedL.frame.size.width, 148, 154/2, 23);
        [_SortBtn setTitle:@"本金" forState:UIControlStateNormal];
        [_SortBtn setBackgroundImage:[UIImage imageNamed:@"selected_button"] forState:UIControlStateNormal]; //////////////本金利息筛选框
        [_SortBtn setBackgroundImage:[UIImage imageNamed:@"selected_button"] forState:UIControlStateHighlighted]; //////////////本金利息筛选框
        _SortBtn.titleLabel.font = SYSTEMFONT(12);
        [_SortBtn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_SortBtn setTitleColor:MainRed forState:UIControlStateNormal]; /////////////0x50f1bf
        
    }
    
    return _SortBtn;
}


- (void)sortBtnClick:(id)sender {
    
    if (!sure) {
        sure = true;
        [_siftImg setHidden:NO];
        _ListTV.userInteractionEnabled = NO;
        for (int i = 0; i < 3; i++) {
            UIButton *button = [self.view viewWithTag:400+i];
            button.userInteractionEnabled = YES;

        }
        
    } else {
        sure = false;
        [_siftImg setHidden:YES];
        _ListTV.userInteractionEnabled = YES;
        for (int i = 0; i < 3; i++) {
            UIButton *button = [self.view viewWithTag:400+i];
            button.userInteractionEnabled = NO;
        }
    }
}


- (UIImageView *)line {
    
    if (!_line) {
        _line = [[UIImageView alloc] init];
        _line.frame = CGRectMake(0, _unclearedL.frame.origin.y+_unclearedL.frame.size.height+12, DMDeviceWidth, 8);
//        _line.image = [UIImage imageNamed:@"持有-分割线"];
        _line.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    
    return _line;
    
}

- (UITableView *)ListTV {
    
    if (!_ListTV) {
        
        _ListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, _line.frame.origin.y+_line.frame.size.height, DMDeviceWidth, DMDeviceHeight - _line.frame.origin.y+_line.frame.size.height - 64) style:UITableViewStylePlain];
        _ListTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ListTV.backgroundColor = [UIColor clearColor];
        _ListTV.delegate = self;
        _ListTV.dataSource = self;
        
        __weak DMSettledAssetsViewController *weakSelf = self;
        _ListTV.mj_header = [self setRefreshHeader:^{
            weakSelf.currentPage = 1;
            [weakSelf prepareForDataSourceWithPageNo:weakSelf.currentPage andPageSize:10 operation:UITableViewOperationPullDown];
        }];
        _ListTV.mj_header.automaticallyChangeAlpha = YES;
        _ListTV.mj_footer = [self setRefreshFooter:^{
            weakSelf.currentPage = weakSelf.currentPage + 1;
            [weakSelf prepareForDataSourceWithPageNo:weakSelf.currentPage andPageSize:10 operation:UITableViewOperationPullUp];
        }];
    }
    
    return _ListTV;
    
}

#pragma mark - Networking Request
- (void)prepareForDataSourceWithPageNo:(int)pageNo andPageSize:(int)pageSize operation:(UITableViewOperation)operation{
    
     [[GZHomePageRequestManager defaultManager] requestForSettledAssetesWithUserId:USER_ID repayMethod:repaymethod amountType:amountType months:months page:@"" size:@"" access_token:AccessToken successBlock:^(NSArray *arr, NSString *str) {
        
        
        
        if(operation == UITableViewOperationPullDown) { //下拉刷新
            
            self.dataSource = [NSMutableArray arrayWithArray:arr];
            [[HUDManager manager ] hide];
            [_ListTV reloadData];
            [self setFootView];
            [_ListTV.mj_header endRefreshing];
            [_ListTV.mj_footer endRefreshing];
            
        }else {//上拉加载
            
            [self.dataSource addObjectsFromArray:arr];
            
            [_ListTV reloadData];
            [_ListTV.mj_footer endRefreshing];
        }
        
    }
        failureBlock:^(NSError *err) {
            
            if(operation == UITableViewOperationPullUp) {
                self.currentPage -= 1;
            }
    }];
}



#pragma mark --- tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 95;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"123";
    
    
    DMSettledAssetsTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(Cell == nil){
        
        Cell = [[DMSettledAssetsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    Cell.model = self.dataSource[indexPath.row];
    
    
    
    Cell.backgroundColor = [UIColor clearColor];
    Cell.textLabel.backgroundColor = [UIColor clearColor];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DMSettledDetailsViewController *settled = [[DMSettledDetailsViewController alloc] init];
    
    DMSettledAssetsModel *model = [[DMSettledAssetsModel alloc] init];
    model = self.dataSource[indexPath.row];
    
    settled.model = model;
    settled.recordId = model.assetId;
    
    
    [self.navigationController pushViewController:settled animated:YES];
    
    
}

- (UIImageView *)siftImg {
    
    if (!_siftImg) {
        _siftImg = [[UIImageView alloc] init];
        _siftImg.frame = CGRectMake(_unclearedL.frame.origin.x+_unclearedL.frame.size.width, 146+23 , 154/2, 184/2);
        _siftImg.image = [UIImage imageNamed:@"Down-box"]; ///////////////筛选框
        [_siftImg setHidden:YES];
    }
   
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(_unclearedL.frame.origin.x+_unclearedL.frame.size.width, 146+23+(184/2/3*i), 154/2, 184/2/3);
        button.tag = 400+i;
        [button addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = NO;
        [self.view addSubview:button];

    }
    
     return _siftImg;
    
}

-(void)Action:(UIButton *)button {
    
  
    
    switch (button.tag) {
        case 400:
        {
            [_SortBtn setTitle:@"全部" forState:UIControlStateNormal];
            sure = false;
            amountType = @"settledAmount";
            [_siftImg setHidden:YES];
            _ListTV.userInteractionEnabled = YES;
            for (int i = 0; i < 3; i++) {
                UIButton *button = [self.view viewWithTag:400+i];
                button.userInteractionEnabled = NO;
            }

            
        }
            break;
        case 401:
        {
             [_SortBtn setTitle:@"利息" forState:UIControlStateNormal];
            sure = false;
             amountType = @"settledInterest";
            [_siftImg setHidden:YES];
            _ListTV.userInteractionEnabled = YES;
            for (int i = 0; i < 3; i++) {
                UIButton *button = [self.view viewWithTag:400+i];
                button.userInteractionEnabled = NO;
            }

        }
            break;
        case 402:
        {
             [_SortBtn setTitle:@"本金" forState:UIControlStateNormal];
            sure = false;
            [_siftImg setHidden:YES];
            amountType = @"settledPrincipal";
            _ListTV.userInteractionEnabled = YES;
            for (int i = 0; i < 3; i++) {
                UIButton *button = [self.view viewWithTag:400+i];
                button.userInteractionEnabled = NO;
            }

        }
            break;
            
        default:
            break;
    }
    
    [[GZHomePageRequestManager defaultManager] requestForSettledAssetesWithUserId:USER_ID repayMethod:repaymethod amountType:amountType months:months page:@"" size:@"" access_token:AccessToken successBlock:^(NSArray *arr, NSString *str) {
        
        self.dataSource = [NSMutableArray arrayWithArray:arr];
        _unclearedL.text = [NSString stringWithFormat:@"筛选范围内未结：%@元",[self getFormattedAmountOfNumberWithString:str]];
        [self.ListTV reloadData];
        [self.ListTV setContentOffset:CGPointMake(0, 0) animated:YES];
        [self setFootView];
        
    } failureBlock:^{
        
    }];

    
    
}

- (void)setFootView{
    if (self.dataSource.count == 0) {
        UILabel *label = [UILabel initWithFrame:self.ListTV.bounds
                                           Font:17
                                           Text:@"当前期限暂无记录"
                                      Alignment:NSTextAlignmentCenter
                                      TextColor:UIColorFromRGB(0x7b7b7b)];
        self.ListTV.tableFooterView = label;
    }else{
        self.ListTV.tableFooterView = [UIView new];
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
