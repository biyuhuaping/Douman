//
//  LJQSystemMessageVC.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQSystemMessageVC.h"
#import "LJQMessageCenterCell.h"
#import "LJQMessageBottomView.h"
#import "LJQMessageTopView.h"
#import "LJQPlatformNoticeVC.h"
#import "LJQSystemMessageModel.h"
#import "LJQPlanformNoticeModel.h"
#import "LJQPlatFormNoticeCell.h"

#import "LJQPlanformNoticeModel.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"

#import "RiskMeasurementVC.h"
static NSString *const cellIdentifier = @"MessageCenterCell";
static NSString *const platFormIdentifier = @"platformCell";
@interface LJQSystemMessageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITableView *myTableView;
@property (nonatomic, strong)UITableView *PlatformTableView;

@property (nonatomic, strong)LJQSystemMessageModel *SystemModel; //系统消息
@property (nonatomic, strong)LJQPlanformNoticeModel *platFormModel;//平台公告
@property (nonatomic, strong)LJQMessageBottomView *bottomView;
@property (nonatomic, strong)LJQMessageTopView *topView;

@property (nonatomic, strong)NSMutableArray *SystemDataSource;
@property (nonatomic, strong)NSMutableArray *platFormDataSource;

@property (nonatomic, strong)NSMutableArray *selectArr; //是否被点击
@property (nonatomic, assign)BOOL isShowArrow;//是否显示箭头
@property (nonatomic, strong)NSMutableArray *messageIDArr; //存放选择的id

@end

static NSInteger listCount = 20;
static NSInteger platFormListCount = 20;
@implementation LJQSystemMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    
    self.isShowArrow = NO;
    
    [self requestPlatformPage:1 size:platFormListCount];
    [self requestSystemMessagePage:1 size:listCount];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self createMessageTopView];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height - 141)];
    self.scrollView.bounces = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREENWIDTH * 2, [UIScreen mainScreen].bounds.size.height - 141);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    //系统消息
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height - 141) style:(UITableViewStylePlain)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.myTableView registerClass:[LJQMessageCenterCell class] forCellReuseIdentifier:cellIdentifier];
    self.myTableView.tableFooterView = [UIView new];
    [self.scrollView addSubview:self.myTableView];
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.myTableView.mj_header = [self setRefreshHeader:^{
        [weakSelf requestSystemMessagePage:1 size:listCount];
    }];

    self.myTableView.mj_header.automaticallyChangeAlpha = YES;
    //上拉加载
    self.myTableView.mj_footer = [self setRefreshFooter:^{
        listCount += 10;
        [weakSelf requestSystemMessagePage:1 size:listCount];
    }];
    
    //平台公告
    self.PlatformTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height - 141) style:(UITableViewStylePlain)];
    self.PlatformTableView.delegate = self;
    self.PlatformTableView.dataSource = self;
    self.PlatformTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.PlatformTableView registerClass:[LJQPlatFormNoticeCell class] forCellReuseIdentifier:platFormIdentifier];
    self.PlatformTableView.tableFooterView = [UIView new];
    [self.scrollView addSubview:self.PlatformTableView];

    //下拉刷新
    self.PlatformTableView.mj_header = [self setRefreshHeader:^{
        [weakSelf requestPlatformPage:1 size:listCount];
    }];

    self.PlatformTableView.mj_header.automaticallyChangeAlpha = YES;
    //上拉加载
    self.PlatformTableView.mj_footer = [self setRefreshFooter:^{
        platFormListCount += 10;
        [weakSelf requestPlatformPage:1 size:platFormListCount];
    }];
}


- (void)createMessageTopView {
     self.topView = [[LJQMessageTopView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40) selectedColor:UIColorFromRGB(0x445c85)];
    __weak LJQSystemMessageVC *weakSelf = self;
    self.topView.block = ^(UIButton *sender ) {
        
        if (sender.tag == 2000) {
            NSLog(@"平台公告");

            CGPoint offect = CGPointMake(0, 0);
            [weakSelf.scrollView setContentOffset:offect animated:YES];
        }
        if (sender.tag == 2001) {
            NSLog(@"系统消息");
            CGPoint offect = CGPointMake(SCREENWIDTH, 0);
            [weakSelf.scrollView setContentOffset:offect animated:YES];
        }
      };
    self.topView.editBlock = ^(UIButton *button ) {
        if (button.selected) {
            NSLog(@"开始编辑");
            [weakSelf createBottomView];
            weakSelf.isShowArrow = YES;
           // [weakSelf.myTableView setEditing:YES animated:YES];
            
        }else {
            NSLog(@"编辑完成");
            [weakSelf.bottomView removeFromSuperview];
            weakSelf.isShowArrow = NO;
            [weakSelf.SystemDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.selectArr replaceObjectAtIndex:idx withObject:@"0"];
            }];
        }
        [weakSelf.myTableView reloadData];
    };
    [self.view addSubview:self.topView];
}

- (void)createBottomView {
    self.bottomView = [[LJQMessageBottomView alloc] initWithFrame:CGRectMake(0, DMDeviceHeight - 49, SCREENWIDTH, 49)];
    __weak LJQSystemMessageVC *weakSelf = self;
    self.bottomView.block = ^(NSInteger index,BOOL selected) {
        if (index == 0) {
            NSLog(@"全选");
            if (selected) {
                [weakSelf.SystemDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [weakSelf.selectArr replaceObjectAtIndex:idx withObject:@"1"];
                }];
            }else {
                [weakSelf.SystemDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [weakSelf.selectArr replaceObjectAtIndex:idx withObject:@"0"];
                }];
            }
            [weakSelf.myTableView reloadData];
        }
        if (index == 1) {
            NSLog(@"选择标记");
            NSMutableArray<NSString *> *array = [NSMutableArray array];
            [weakSelf.selectArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:@"0"]) {
                    //未标记
                   
                }else {
                    //标记
                    [weakSelf.selectArr replaceObjectAtIndex:idx withObject:@"0"];
                    [array addObject:[weakSelf.messageIDArr objectAtIndex:idx]];
                }
            }];
            NSArray *IDArr = [NSArray arrayWithArray:array];
            if (IDArr.count > 0) {
                [weakSelf isReadSystem:IDArr];
            }
        }
        if (index == 2) {
            NSLog(@"删除");
            
            NSMutableArray<NSString *> *array = [NSMutableArray array];
            NSMutableArray *indexArr = [NSMutableArray array];
            [weakSelf.selectArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:@"0"]) {
                    //未标记
                    
                }else {
                    //标记
                    [weakSelf.selectArr replaceObjectAtIndex:idx withObject:@"0"];
                    [array addObject:[weakSelf.messageIDArr objectAtIndex:idx]];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
                    [indexArr addObject:indexPath];
                   
                }
            }];
            
            if (indexArr.count != 0) {
                for (NSInteger j = indexArr.count - 1; j >= 0; j--) {
                    NSIndexPath *index = indexArr[j];
                    
                    for (NSInteger i = weakSelf.SystemDataSource.count - 1; i >= 0; i--) {
                        if (i == index.row) {
                            [weakSelf.selectArr removeObjectAtIndex:index.row];
                            [weakSelf.SystemDataSource removeObjectAtIndex:index.row];
                            [weakSelf.messageIDArr removeObjectAtIndex:index.row];
                        }
                    }
                }
                
                [weakSelf.myTableView deleteRowsAtIndexPaths:indexArr withRowAnimation:(UITableViewRowAnimationAutomatic)];

            }
            
            NSArray *IDArr = [NSArray arrayWithArray:array];
            if (IDArr.count > 0) {
                [weakSelf deletedSystem:IDArr];
            }
            
            
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.bottomView];
}

#pragma tableViewDataSource && tableViewDelegete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.myTableView) {
        return self.SystemDataSource.count;
    }else {
        return self.platFormDataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string;
    if (tableView == self.myTableView) {
        LJQSystemMessageModel *model = self.SystemDataSource[indexPath.row];
        string = model.content;
    }else {
        LJQPlanformNoticeModel *model = self.platFormDataSource[indexPath.row];
        string = model.briff;
    }
    CGFloat height = [self returnBackLabelHeight:string];
    return 50 + height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myTableView) {
        LJQMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.isShow = self.isShowArrow;
        if (self.isShowArrow == YES) {
            if ([[self.selectArr objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
                cell.selectedPitcure.image = [UIImage imageNamed:@"未选中"];
            }else {
                cell.selectedPitcure.image = [UIImage imageNamed:@"选中"];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Messagemodel = self.SystemDataSource[indexPath.row];
        return cell;

    }else {
        LJQPlatFormNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:platFormIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isRead = YES;
        cell.model = self.platFormDataSource[indexPath.row];
        return cell;

    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.PlatformTableView) {
        RiskMeasurementVC *webVC = [[RiskMeasurementVC alloc] init];
        LJQPlanformNoticeModel *model = self.platFormDataSource[indexPath.row];
        //webVC.webUrl = [[DMWebUrlManager manager] platformDetail];
        webVC.title = @"平台公告";
        webVC.parameter = [NSString stringWithFormat:@"%@",model.content];
        [self.navigationController pushViewController:webVC animated:YES];
    }else {
        if (self.isShowArrow == YES) {
            //0代表未被选中，1代表被选中
            if ([[self.selectArr objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
                [self.selectArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
                [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            }else {
                [self.selectArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
                [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            }
        }else {
            [self isReadSystem:@[self.messageIDArr[indexPath.row]]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)returnBackLabelHeight:(NSString *)string {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH - 100, 100) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil];
    return rect.size.height;
}

- (NSMutableArray *)SystemDataSource {
    if (!_SystemDataSource) {
        _SystemDataSource = [@[] mutableCopy];
    }
    return _SystemDataSource;
}

- (NSMutableArray *)platFormDataSource {
    if (!_platFormDataSource) {
        _platFormDataSource = [@[] mutableCopy];
    }
    return _platFormDataSource;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) {
        _selectArr = [@[] mutableCopy];
    }
    return _selectArr;
}

- (NSMutableArray *)messageIDArr {
    if (!_messageIDArr) {
        _messageIDArr = [@[] mutableCopy];
    }
    return _messageIDArr;
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.bottomView) {
        [self.bottomView removeFromSuperview];
    }
}

//系统消息
- (void)requestSystemMessagePage:(NSInteger)page size:(NSInteger)size {
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //先删除所有，在重新添加
    [self.selectArr removeAllObjects];
    [self.messageIDArr removeAllObjects];
    [[LJQMineRequestManager RequestManager] LJQSystemMessageDataPage:page size:size SuccessBlock:^(NSArray *array, NSInteger index) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.SystemDataSource = [NSMutableArray arrayWithArray:array];
        [array enumerateObjectsUsingBlock:^(LJQSystemMessageModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.selectArr addObject:@"0"];
            [self.messageIDArr addObject:obj.messageId];
        }];
        [self.myTableView reloadData];
        [self setSystemFootView];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
}

- (void)setSystemFootView{
    if (self.SystemDataSource.count == 0) {
        UILabel *label = [UILabel createLabelFrame:self.myTableView.bounds labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
        
        self.myTableView.tableFooterView = label;
    }else{
        self.myTableView.tableFooterView = [UIView new];
    }
}

- (void)setPlatFormFootView{
    if (self.platFormDataSource.count == 0) {
        UILabel *label = [UILabel createLabelFrame:self.PlatformTableView.bounds labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
        
        self.PlatformTableView.tableFooterView = label;
    }else{
        self.PlatformTableView.tableFooterView = [UIView new];
    }
}



//平台公告
- (void)requestPlatformPage:(NSInteger)page size:(NSInteger)size {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] LJQPlatformNoticeDataPage:page size:size SuccessBlock:^(NSArray *array, NSInteger index) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.platFormDataSource = [NSMutableArray arrayWithArray:array];
        [self.PlatformTableView reloadData];
        [self setPlatFormFootView];
        [self.PlatformTableView.mj_header endRefreshing];
        [self.PlatformTableView.mj_footer endRefreshing];
    } faild:^{
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.PlatformTableView.mj_header endRefreshing];
        [self.PlatformTableView.mj_footer endRefreshing];
    }];
}

//设置标记已读
- (void)isReadSystem:(NSArray *)messageIDs {
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager LJQsetSystemMessageReadMessageID:messageIDs SuccessBlock:^(NSString *string, NSInteger index) {
        if (index == 0) {
            [self requestSystemMessagePage:1 size:listCount];
        }else
            if (index == 1) {
                //未登录
            }else {
                //接口异常
            }
    } faild:^{
        
    }];
}

//删除系统消息
- (void)deletedSystem:(NSArray *)MessageIDs {
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager LJQDeleteSystemMessageMsgID:MessageIDs SuccessBlock:^(NSString *string, NSInteger index) {
        if (index == 0) {
           // [self requestSystemMessagePage:1 size:10];
        }else
            if (index == 1) {
                //未登录
            }else {
                //接口异常
            }
    } faild:^{
        
    }];
}

@end
