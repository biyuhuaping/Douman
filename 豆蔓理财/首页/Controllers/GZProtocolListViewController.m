//
//  GZProtocolListViewController.m
//  豆蔓理财
//
//  Created by armada on 2017/3/30.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZProtocolListViewController.h"

#import "DMWebViewController.h"

#import "GZProtocolListTableViewCell.h"

#import "DMWebUrlManager.h"

#import "AZT_PDFReader.h"

@interface GZProtocolListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *protocolListView;

@property(nonatomic, strong) UILabel *reminderFooterLabel;

@property(nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end

@implementation GZProtocolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"产品相关协议";
    self.view.backgroundColor = [UIColor whiteColor];
    self.reminderFooterLabel.text = @"*点击上述协议查看详情";
    [self.protocolListView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //电子签章PDF返回时隐藏Tabbar
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

#pragma mark - Lazy Loading

- (UITableView *)protocolListView {
    
    if (!_protocolListView) {
        
        _protocolListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_protocolListView];
        [_protocolListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.and.right.equalTo(self.view);
            make.height.mas_equalTo(DMDeviceHeight-64-20);
        }];
        _protocolListView.backgroundColor = [UIColor whiteColor];
        _protocolListView.showsVerticalScrollIndicator = NO;
        _protocolListView.showsHorizontalScrollIndicator = NO;
        _protocolListView.separatorStyle = UITableViewCellSelectionStyleNone;
        _protocolListView.dataSource = self;
        _protocolListView.delegate = self;
        [_protocolListView registerClass:[GZProtocolListTableViewCell class] forCellReuseIdentifier:@"protocolCell"];
    }
    return _protocolListView;
}

- (UILabel *)reminderFooterLabel {
    
    if (!_reminderFooterLabel) {
        
        _reminderFooterLabel = [[UILabel alloc] init];
        [self.view addSubview:_reminderFooterLabel];
        [_reminderFooterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.view);
            make.top.equalTo(self.protocolListView.mas_bottom);
        }];
        
        _reminderFooterLabel.backgroundColor = [UIColor whiteColor];
        _reminderFooterLabel.textAlignment = NSTextAlignmentCenter;
        _reminderFooterLabel.font = [UIFont systemFontOfSize:12];
        _reminderFooterLabel.textColor = [UIColor lightGrayColor];
    }
    return _reminderFooterLabel;
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reusedId = @"protocolCell";
    
    GZProtocolListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId forIndexPath:indexPath];
    
    GZContractModel *model = [self.dataSource objectAtIndex:indexPath.row];

    cell.protocolNameLabel.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    GZContractModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    [self downLoadPDF:model.path andTitle:model.name];
    
    [self.downloadTask resume];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 30)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        [contentView addSubview:headerLabel];
        headerLabel.text = @"相关协议列表：";
        headerLabel.font = [UIFont systemFontOfSize:13];
        headerLabel.textColor = UIColorFromRGB(0x585c62);
    
        return contentView;
    }
    
    return nil;
}

//下载PDF文件
- (void)downLoadPDF:(NSString *)urlString andTitle:(NSString *)title{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //File Url
    NSString* fileUrl = urlString;
    //创建 Request
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    
    //下载进行中的事件
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
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
        [[AZT_PDFReader getInstance] openPDFWithViewCtr:self PDFPath:imgFilePath ViewCtrTitle:title];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
