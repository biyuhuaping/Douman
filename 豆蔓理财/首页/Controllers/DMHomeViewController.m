//
//  DMHomeViewController.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/26.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMHomeViewController.h"
#import "DMHomeHeadView.h"
#import "DMHomeListCell.h"
#import "DMHomeFootView.h"
#import "DMHomeRequestManager.h"
#import "DMScafferCreditManager.h"
#import "DMWebUrlManager.h"
#import "DMWebViewController.h"
#import "DMNewHandView.h"
#import "DMRegisterViewController.h"
#import "DMLoginViewController.h"
#import "RiskMeasurementVC.h"
#import "DMHomeBannerModel.h"
#import "DMAdzukibeanRobtVC.h"
#import "DMSelectProDetailVC.h"
#import "DMHomeListModel.h"
#import "DMSettingManager.h"
#import "DMOpenPopUpView.h"
#import "DMCodeViewController.h"
#import "DMRobtOpeningModel.h"


@interface DMHomeViewController ()<UITableViewDelegate,UITableViewDataSource,DMHomeHeadViewDelegate,DMHomeListCellDelegate,OpenPopUpDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DMHomeHeadView *headView;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation DMHomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self requestData];
    [self requetBankInfo];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addConstrainsWithVisualFormat:@"H:|-0-[v0]-0-|" Views:@[self.tableView]];
    [self.view addConstrainsWithVisualFormat:@"V:|-0-[v0]-0-|" Views:@[self.tableView]];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInset = UIEdgeInsetsMake(-20, 0,0,0);
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)requetBankInfo{
    if (AccessToken) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"showview"]) {
            [self showBandCardView];
        }
    }
}

//轮播图
- (void)requestData{
    [[DMHomeRequestManager manager] getHomeBannerSuccess:^(NSArray *bannerArray) {
        self.headView.bannerArray = [NSArray arrayWithArray:bannerArray];
    } faild:^{
        
    }];
    [[DMHomeRequestManager manager] getHomeNoticeSuccess:^(NSArray *noticeArray) {
        self.headView.noticeArray = [NSArray arrayWithArray:noticeArray];
    } faild:^{
        
    }];
    [self requestList];
}


- (void)requestList{
    [self.listArray removeAllObjects];
    if (AccessToken) {
        [[DMHomeRequestManager manager] getIsNewUserSuccess:^(BOOL isNewUser) {
            if (isNewUser) {
                [self requestNew];
            }else{
                [self requestRobot];
            }
        } faild:^{
            [self requestRobot];
        }];
    }else{
        [self requestNew];
    }
}

// 新手专享
- (void)requestNew{
    [[DMHomeRequestManager manager] getNewHandSuccess:^(NSArray *newArray) {
        [self.listArray addObject:[newArray firstObject]];
        [self requestRobot];
    } faild:^{
        [self requestRobot];
    }];
}

//小豆机器人
- (void)requestRobot{
    [[DMScafferCreditManager scafferDefault] DMRobtToGetOpeningWithRobtCycle:nil showView:self.view success:^(NSArray<DMRobtOpeningModel *> *robtOpenArr, NSArray<DMRobtOpenInfoModel *> *robtInfoArr) {
        if (robtOpenArr.count>0) {
            [self.listArray addObject:[robtOpenArr firstObject]];
        }
        [self requestRecommend];
    } faild:^{
        [self requestRecommend];
    }];
}

//推荐产品
- (void)requestRecommend{
    NSInteger size = 3-self.listArray.count;
    [[DMHomeRequestManager manager] getRecommendPage:1 Size:size Success:^(NSArray *recommendArray) {
        [self.listArray addObjectsFromArray:recommendArray];
        [self requestEnd];
    } faild:^{
        [self requestFailed];
    }];
}

//请求结束
- (void)requestEnd{
    [self.tableView.mj_header endRefreshing];
    self.tableView.tableHeaderView = self.headView;
    _tableView.tableFooterView = [[DMHomeFootView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 50)];
    [self.tableView reloadData];
}

// 请求失败
- (void)requestFailed{
    if (self.listArray.count > 0) {
        [self requestEnd];
    }else{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"点击重新加载" forState:UIControlStateNormal];
        [button setTitleColor:LightGray forState:UIControlStateNormal];
        button.titleLabel.font = FONT_Light(14);
        button.frame = self.tableView.bounds;
        self.tableView.tableFooterView = button;
        [button addTarget:self action:@selector(requestData) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (DMHomeHeadView *)headView{
    if (!_headView) {
        self.headView = [[DMHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 110+BANNER_HEIGHT)];
        _headView.delegate = self;
    }
    return _headView;
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WITHEBACK_LINE;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DMHomeListCell class] forCellReuseIdentifier:@"DMHomeListCell"];
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [self setRefreshHeader:^{
            [weakSelf requestData];
        }];
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DMHomeListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.delegate=self;
    if (self.listArray.count > indexPath.row) {
        id model = self.listArray[indexPath.row];
        if ([model isKindOfClass:[DMHomeListModel class]]) {
            cell.listModel = (DMHomeListModel *)model;
        }else{
            cell.robotModel = (DMRobtOpeningModel *)model;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 195;
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        self.listArray = [@[] mutableCopy];
    }
    return _listArray;
}


#pragma mark  touch  action

- (void)didSelectButtonWithIndex:(NSInteger)index{
    switch (index) {
        case 0://新手专享
            [self getWebViewWithUrl:[[DMWebUrlManager manager] newHang] Title:@"新手专享" Type:@"new"];
            break;
        case 1://安全保障
            [self getWebViewWithUrl:[[DMWebUrlManager manager] safeguard] Title:@"安全保障" Type:@"model"];
            break;
        case 2://银行存管
//            [self getWebViewWithUrl:[[DMWebUrlManager manager] getHuiShangPingTai] Title:@"资金存管" Type:@"model"];
            break;
        case 3: //优质资产
            [self getWebViewWithUrl:[[DMWebUrlManager manager] creditModel] Title:@"优质资产" Type:@"model"];
            break;
        default:
            break;
    }
}

- (void)getWebViewWithUrl:(NSString *) url Title:(NSString *)title Type:(NSString *)type{
    DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
    chargeVC.title = title;
    chargeVC.type = type;
    chargeVC.webUrl = url;
    [self.navigationController pushViewController:chargeVC animated:YES];
}

// 登录
- (void)loginAction{
    DMLoginViewController *loginVC = [[DMLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

//更多
- (void)didSelectMoreWithIndex:(NSInteger)index{
    id model = self.listArray[index];
    if ([model isKindOfClass:[DMHomeListModel class]]) {
        if (((DMHomeListModel *)model).noviceTask) {
            self.tabBarController.selectedIndex = 1;
        }else{
            [self getWebViewWithUrl:[[DMWebUrlManager manager] newHang] Title:@"新手专享" Type:@"new"];
        }
    }else{
        [self getRobtoVC];
    }
}
//点击购买
- (void)didSelectBuyNowWithIndex:(NSInteger)index{
    id model = self.listArray[index];
    if ([model isKindOfClass:[DMHomeListModel class]]) {
        if (((DMHomeListModel *)model).noviceTask) {
            [self getRecommendDetailWithIndex:index];
        }else{
            [self getWebViewWithUrl:[[DMWebUrlManager manager] newHang] Title:@"新手专享" Type:@"new"];
        }
    }else{
        [self getRobtoVC];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.listArray[indexPath.row];
    if ([model isKindOfClass:[DMHomeListModel class]]) {
        if (((DMHomeListModel *)model).noviceTask) {
            [self getRecommendDetailWithIndex:indexPath.row];
        }else{
            [self getWebViewWithUrl:[[DMWebUrlManager manager] newHang] Title:@"新手专享" Type:@"new"];
        }
    }else{
        [self getRobtoVC];
    }
}

- (void)getRecommendDetailWithIndex:(NSInteger)index{
    DMHomeListModel *listModel = self.listArray[index];
    DMSelectProDetailVC *detailVC = [[DMSelectProDetailVC alloc] init];
    detailVC.assetID = listModel.assetId;
    detailVC.productModel = listModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)getRobtoVC{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"exchange" object:nil userInfo:@{@"index":@(2)}];
    [self.tabBarController setSelectedIndex:1];
}

//公告
- (void)didSelectNoticeWithIndex:(NSInteger)index{
    DMHomeBannerModel *model = self.headView.noticeArray[index];
    RiskMeasurementVC *webVC = [[RiskMeasurementVC alloc] init];
    webVC.title = model.TITLE;
    webVC.parameter = [NSString stringWithFormat:@"%@",model.CONTENT];
    [self.navigationController pushViewController:webVC animated:YES];
}

//banner
- (void)didSelectBannerWithIndex:(NSInteger)index{
    DMHomeBannerModel *model = self.headView.bannerArray[index];
    NSString *url;
    if (model.URL.length > 0) {
        if (AccessToken) {
           url = [model.URL stringByAppendingString:[NSString stringWithFormat:@"?fromapp=1&token=%@",AccessToken]];
        }else{
           url = [model.URL stringByAppendingString:@"?fromapp=1"];
        }
        [self getWebViewWithUrl:url Title:model.TITLE Type:@"model"];
    }
}

#pragma mark - 新手专享

- (void)loadPrivateEnjoymentForFreshScene {
    DMNewHandView *newHandView = [[DMNewHandView alloc] initWithFrame:DMDeviceFrame];
    [[UIApplication sharedApplication].keyWindow addSubview:newHandView];
    newHandView.registerBlock = ^{
        DMRegisterViewController *rvc = [[DMRegisterViewController alloc]init];
        [self.navigationController pushViewController:rvc animated:YES];
    };
}

#pragma mark  是否绑卡弹窗
- (void)showBandCardView {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cardNbr"]) {
        [[DMSettingManager RequestManager] requestForTieOnCardSuccess:^(BOOL sure) {
            if (!sure) {
                DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:YES];
                open.delegate = self;
                [[UIApplication sharedApplication].keyWindow addSubview:open];
            }
        } Faild:^() {

        }];
    }else{
        DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:NO];
        open.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:open];
    }
}

- (void)openpopupClick {
    DMCodeViewController *code = [[DMCodeViewController alloc] init];
    [self.navigationController pushViewController:code animated:YES];
}

@end
