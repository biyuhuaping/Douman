//
//  DMMyServerViewController.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMMyServerViewController.h"
#import "DMMyServerHeaderView.h"
#import "DMMyServerCell.h"
#import "DMScafferCreditManager.h"
#import "DMRobotHoldCreditViewController.h"
#import "DMMyServerHoldListModel.h"
#import "AZT_PDFReader.h"

@interface DMMyServerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSURLSessionDownloadTask *downLoadTask;
}


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DMMyServerHeaderView *headView;
@property (nonatomic, strong) NSArray *listArray;

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger totleCount;
@property (nonatomic, assign) NSInteger beforeCount;

@property (nonatomic, copy) NSString *type;

@end

@implementation DMMyServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.size = 10;
    self.type = @"0";
    
    self.img.hidden = YES;
    self.navigationItem.title = @"我的服务";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);

    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    
    [self requestData];
    [self requestListDataStatus:self.type Size:self.size];
}

- (void)requestData{
    [[DMScafferCreditManager scafferDefault] getMyServerRobotInfoSuccess:^(DMMyServerModel *serverModel) {
        self.headView.serverModel = serverModel;
    } faild:^{
        
    }];
}

- (void)requestListDataStatus:(NSString *)status Size:(int)size{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[DMScafferCreditManager scafferDefault] getMyServerHoldListWithStatus:status Size:[@(size) stringValue] success:^(NSArray *holdList) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.listArray = [NSArray arrayWithArray:holdList];
        self.totleCount = self.listArray.count;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            if (self.totleCount == self.beforeCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        if (self.listArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.listArray.count > 0) {
            self.tableView.tableFooterView = [UIView new];
        }else{
            UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 200)];
            footLabel.text = @"暂无数据";
            footLabel.textColor = UIColorFromRGB(0x878787);
            footLabel.textAlignment = NSTextAlignmentCenter;
            self.tableView.tableFooterView = footLabel;
        }
    } faild:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}


- (DMMyServerHeaderView *)headView{
    if (!_headView) {
        self.headView = [[DMMyServerHeaderView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 247)];
        __weak __typeof(self) weakSelf = self;
        _headView.SelectButton = ^(NSInteger index) {
            if (index==0) {
                weakSelf.type = @"0";
            }else{
                weakSelf.type = @"1";
            }
            weakSelf.size = 10;
            [weakSelf requestListDataStatus:weakSelf.type Size:weakSelf.size];
        };
    }
    return _headView;
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromRGB(0xf6f5fa);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DMMyServerCell class] forCellReuseIdentifier:@"DMMyServerCell"];
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [self setRefreshHeader:^{
            weakSelf.size = 10;
            [weakSelf requestData];
            [weakSelf requestListDataStatus:weakSelf.type Size:weakSelf.size];
        }];
        _tableView.mj_footer = [self setRefreshFooter:^{
            weakSelf.size += 10;
            [weakSelf requestListDataStatus:weakSelf.type Size:weakSelf.size];
        }];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.beforeCount = self.listArray.count;
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMMyServerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DMMyServerCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    cell.type = self.type;
    cell.holdModel = self.listArray[indexPath.row];
    cell.GetAgreement = ^(NSInteger index) {
        DMMyServerHoldListModel *holdModel = (DMMyServerHoldListModel *)self.listArray[indexPath.row];
        NSString *path = [holdModel.contracts firstObject][@"path"];
        if (path.length > 1) {
            [self downLoadPDF:[holdModel.contracts firstObject][@"path"]];
            [downLoadTask resume];
        }else{
            ShowMessage(@"合同未生成");
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"0"]) {
        DMMyServerHoldListModel *holdModel = (DMMyServerHoldListModel *)self.listArray[indexPath.row];
        DMRobotHoldCreditViewController *creditVC = [[DMRobotHoldCreditViewController alloc] init];
        creditVC.robotId = holdModel.listId;
        [self.navigationController pushViewController:creditVC animated:YES];
    }
}

- (NSArray *)listArray{
    if (!_listArray) {
        self.listArray = [@[] copy];
    }
    return _listArray;
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

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}

- (void)viewWillAppear:(BOOL)animated {
    //电子签章PDF返回时隐藏Tabbar
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)dealloc{
    NSLog(@"调用了dealloc");
}

@end
