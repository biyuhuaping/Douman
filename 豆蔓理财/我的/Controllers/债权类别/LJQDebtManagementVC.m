//
//  LJQDebtManagementVC.m
//  豆蔓理财
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQDebtManagementVC.h"
#import "LJQDebtManageView.h"
#import "LJQDebtManageCell.h"
#import "AZT_PDFReader.h"
@interface LJQDebtManagementVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSURLSessionDownloadTask *downLoadTask;
    
}

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, assign)NSInteger number;

@end


static NSString *const debtManagerInentifer = @"debtManagerInentifer";
@implementation LJQDebtManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.number = 1;
    self.title = @"债权管理";
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self createManagerView];
    [self.view addSubview:self.tableView];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
    }];
    
    //上拉加载
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREENWIDTH, self.view.frame.size.height) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [_tableView registerClass:[LJQDebtManageCell class] forCellReuseIdentifier:debtManagerInentifer];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 130;
        _tableView.tableFooterView = [self createFootView];
    }
    return _tableView;
}


- (UIView *)createFootView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
    view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    return view;
}

- (void)createManagerView {
    LJQDebtManageView *managerView = [[LJQDebtManageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40) selectedColor:UIColorFromRGB(0x445c85)];
    managerView.backgroundColor = [UIColor whiteColor];
    __weak LJQDebtManagementVC *weakSelf = self;
    managerView.block = ^(UIButton *btn) {
        if (btn.tag == 2000) {
            weakSelf.number = 1;
            [self.tableView reloadData];
        }
        if (btn.tag == 2001) {
            weakSelf.number = 2;
            [self.tableView reloadData];
        }
        if (btn.tag == 2002) {
            weakSelf.number = 3;
            [self.tableView reloadData];
        }
    };
    [self.view addSubview:managerView];

}

#pragma tableViewDelegete && tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJQDebtManageCell *cell = [tableView dequeueReusableCellWithIdentifier:debtManagerInentifer forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.debtTransferType = self.number;
    
    cell.contractJump = ^(UIButton *sender) {
        ShowMessage(@"加载合同页");
    };
    
    
    
    return cell;
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
    NSLog(@"合同页加载完成");
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"合同页显示完成");
    
    //电子签章PDF返回时隐藏Tabbar
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end
