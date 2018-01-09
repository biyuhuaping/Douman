//
//  DMTransferContractViewController.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/6/15.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMTransferContractViewController.h"
#import "DMCreditRequestManager.h"
#import "AZT_PDFReader.h"

@interface DMTransferContractViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSURLSessionDownloadTask *downLoadTask;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *footlabel;

@end

@implementation DMTransferContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"合同";
    self.img.hidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f9);

    [self.view addSubview:self.tableView];
    
    [self requestData];
}

- (void)requestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DMCreditRequestManager manager] getTransferContactWithLoadId:self.assignId Success:^(NSArray *contractArray) {
        self.dataArray = [NSMutableArray arrayWithArray:contractArray];
        [self.tableView reloadData];
        [self setFootView];

        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failed:^{
        [self setFootView];

        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}
- (void)setFootView{
    if (self.dataArray.count==0) {
        self.tableView.tableFooterView = self.footlabel;
    }else{
        self.tableView.tableFooterView = [UIView new];
    }
}

- (UILabel *)footlabel{
    if (_footlabel == nil) {
        self.footlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 200)];
        _footlabel.text = @"没有合同信息";
        _footlabel.textColor = UIColorFromRGB(0x787878);
        _footlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _footlabel;
}


- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:DMDeviceFrame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestData];
        }];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transfercell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transfercell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"债权转让及授权协议%zd",indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self downLoadPDF:self.dataArray[indexPath.row]];
    [downLoadTask resume];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [@[] mutableCopy];
    }
    return _dataArray;
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
