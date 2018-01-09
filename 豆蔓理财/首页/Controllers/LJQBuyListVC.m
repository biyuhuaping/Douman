//
//  LJQBuyListVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQBuyListVC.h"
#import "LJQBuyListCell.h"

static NSString *const LJQBuyListIdentifier = @"ljqbuylistcell";
@interface LJQBuyListVC ()

{
    int currentPage;
}

/** 数据源 */
@property(nonatomic,strong) NSMutableArray<GZBuyListModel *> *dataSource;

@end

@implementation LJQBuyListVC

- (NSMutableArray *)dataSource {
    
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    self.title = @"认购列表";
    [super viewDidLoad];
    self.tableView.rowHeight = 44;
    [self.tableView registerClass:[LJQBuyListCell class] forCellReuseIdentifier:LJQBuyListIdentifier];
    self.tableView.tableFooterView = [UIView new];
    
    currentPage = 1;
    
    __weak LJQBuyListVC *weakSelf = self;
    
    //下拉刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        currentPage = 1;
        [weakSelf prepareForDataSourceWithPageNo:currentPage andPageSize:20 operation:UITableViewOperationPullDown];
    }];
    
    //上拉加载控件
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        currentPage = currentPage + 1;
        [weakSelf prepareForDataSourceWithPageNo:currentPage andPageSize:20 operation:UITableViewOperationPullUp];
    }];
    
    [self prepareForDataSourceWithPageNo:1 andPageSize:20 operation:UITableViewOperationPullDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking Request
- (void)prepareForDataSourceWithPageNo:(int)pageNo andPageSize:(int)pageSize operation:(UITableViewOperation)operation{
    
    [[GZHomePageRequestManager defaultManager] requestForHomePageBuyListWithAssetID:self.assetId pageNo:pageNo pageSize:pageSize successBlock:^(BOOL result, NSString *message, NSString *periods, NSArray<GZBuyListModel *> *buyList, NSString *totalSize) {
        
        if(result) {
            
            if(operation == UITableViewOperationPullDown) { //下拉刷新
                
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:buyList];
    
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                
            }else {//上拉加载
                
                [self.dataSource addObjectsFromArray:buyList];
                
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        
        }else {
            
            ShowMessage(message);
        }
        
    } failureBlock:^(NSError *err) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createHeaderView:CGRectMake(0, 0, SCREENWIDTH, 43)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJQBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:LJQBuyListIdentifier forIndexPath:indexPath];
    
    GZBuyListModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.acountLabel.text = model.buyTime;
    cell.userLabel.text = [self encryptMobileNumberWithStr:model.mobile];
    CGFloat number = [model.investAmount floatValue];
    cell.timeLabel.text = [self stringFormatterDecimalStyle:@(number)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)createHeaderView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    NSArray *array = @[@"认购时间",@"认购用户",@"认购金额(元)"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH / 3 * i, 0, SCREENWIDTH / 3, 43) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:13.f];
            label.text = array[i];
        [view addSubview:label];
    }
    return view;
}

#pragma mark - Helper Function

- (NSString *)encryptMobileNumberWithStr:(NSString *)mobile {
    if (mobile.length > 10) {
        NSString *title = [mobile substringToIndex:3];
        NSString *detail = [mobile substringFromIndex:7];
        return [NSString stringWithFormat:@"%@****%@",title,detail];
    }else{
        NSString *title = [mobile substringToIndex:3];
        return [NSString stringWithFormat:@"%@********",title];
    }

}

- (NSString *)judgeIsOrEmpty:(NSString *)string {
    NSString *empty;
    if ([string isKindOfClass:[NSNull class]]) {
        empty = @"--";
    }
    if (string == nil || string == NULL) {
        empty = @"--";
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        empty = @"--";
    }
    return empty;
}

@end
