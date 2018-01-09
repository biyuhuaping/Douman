//
//  GZReviewedListViewController.m
//  豆蔓理财
//
//  Created by armada on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZReviewedListViewController.h"

#import "GZReviewedListTableViewCell.h"

#import "GZReviewedListNoRecordTableViewCell.h"

#import "GZReviewedDetailViewController.h"

#import "iCarouselView.h"

@interface GZReviewedListViewController ()<UITableViewDelegate,UITableViewDataSource,iCarouselScrolling>

{
    int currentMonth;
    
    int currentPage;
}

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray<GZProductListModel *> *dataSource;
// 标尺
@property(nonatomic, strong) iCarouselView *icarousel;

@end

@implementation GZReviewedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareForDatasourceWithMonth:0 pageNo:1 pageSize:sizeOfpage operation:UITableViewOperationPullDown];
    
    currentMonth = 0; //默认加载全部月份数据
    
    currentPage = 1; //默认请求页为第一页
}

#pragma mark - Network Request

- (void)prepareForDatasourceWithMonth:(int)month pageNo:(int)pageNo pageSize:(int)pageSize operation:(UITableViewOperation)operation{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GZHomePageRequestManager defaultManager] requestForHomePageLoanListWithMonth:[NSString stringWithFormat:@"%d",month] clientType:@"2" type:@"doumandingqi" pageNo:[NSString stringWithFormat:@"%d",pageNo] pageSize:[NSString stringWithFormat:@"%d",pageSize] successBlock:^(BOOL result, NSString *message, NSArray<GZProductListModel *> *productList, NSString *totalSize) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(result) {
        
            if(operation == UITableViewOperationPullDown) {//下拉刷新
                
                //还原footer状态
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:productList];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                
            }else {//上拉加载
                
                if (productList.count != 0) {
                    
                    [self.dataSource addObjectsFromArray:productList];
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }else {
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                }

            }
        }else {
            
            ShowMessage(message);
        }
        
    } failureBlock:^(NSError *err) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ShowMessage(@"数据加载失败");        
        if(operation == UITableViewOperationPullUp) {
            currentPage -= 1;
        }
    }];
}

#pragma mark - Lazy Loading

-(iCarouselView *)icarousel {
    
    if (!_icarousel) {
        
        _icarousel = [[iCarouselView alloc]initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 100)];
        _icarousel.scroll = self;
    }
    return _icarousel;
}

- (NSMutableArray *)dataSource {
    
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    
    if(!_tableView) {
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[GZReviewedListTableViewCell class] forCellReuseIdentifier:@"reviewdCell"];
        
        [_tableView registerClass:[GZReviewedListNoRecordTableViewCell class] forCellReuseIdentifier:@"noRecordCell"];
        
        __weak GZReviewedListViewController *weakSelf = self;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            currentPage = 1;
            [weakSelf prepareForDatasourceWithMonth:currentMonth pageNo:currentPage pageSize:sizeOfpage operation:UITableViewOperationPullDown];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
           
            currentPage = currentPage + 1;
            [weakSelf prepareForDatasourceWithMonth:currentMonth pageNo:currentPage pageSize:sizeOfpage operation:UITableViewOperationPullUp];
        }];
        
        _tableView.tableHeaderView = self.icarousel;
    }
    return _tableView;
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataSource.count != 0){ //当前月份存在数据
        return self.dataSource.count;
    }else { //当前月份不存在数据
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.dataSource.count != 0) {
        
        GZReviewedListTableViewCell *cell = [GZReviewedListTableViewCell cellWithTableView:tableView];
        GZProductListModel *model = [self.dataSource objectAtIndex:indexPath.row];
        [cell setCellWithReviewedListModel:model];
        [cell setMarkNewImgViewHidden:!model.noviceTask];
        
        return cell;
        
    }else {
        
        GZReviewedListNoRecordTableViewCell *cell = [GZReviewedListNoRecordTableViewCell cellWithTableView:tableView];

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(self.dataSource != 0) {
        
        GZProductListModel *model = [self.dataSource objectAtIndex:indexPath.row];
        GZReviewedDetailViewController *rdvc = [[GZReviewedDetailViewController alloc]init];
        rdvc.assetId = model.assetId;
        rdvc.productCycle = model.assetDuration;
        rdvc.navigationItem.title = @"往期产品";
        rdvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rdvc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

#pragma mark - iCarouselView delegate

- (void)ScrollingAnimation:(NSInteger)tag {
    
    currentPage = 1;
    currentMonth = [NSNumber numberWithInteger:tag].intValue;
    
    [self prepareForDatasourceWithMonth:currentMonth pageNo:currentPage pageSize:sizeOfpage operation:UITableViewOperationPullDown];
}

#pragma mark - memoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
