//
//  DMSearchViewController.m
//  豆蔓理财
//
//  Created by mac on 2017/5/23.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMSearchViewController.h"
#import "DMGetBranchNameModel.h"
@interface DMSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

/** 搜索栏 */
@property(nonatomic, strong) UITextField *searchTextField;
/** 取消键 */
@property(nonatomic, strong) UIButton *cancelBtn;
/** 历史记录列表 */
@property(nonatomic, strong) UITableView *searchHistoryList;
/** 搜索记录列表 */
@property(nonatomic, strong) NSMutableArray *searchHistoryInList;
@property (nonatomic, assign)NSInteger listCount;

@property (nonatomic, copy)NSString *keyString;
@end

static NSString *const reusableId = @"historyRecordCell";
@implementation DMSearchViewController
@synthesize listCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyString = @"";
    listCount = 10;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:self.searchHistoryList];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
    
    //下拉刷新
    self.searchHistoryList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestBranchNameList:self.keyString];
    }];
    
    //上拉加载
    self.searchHistoryList.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        listCount += 10;
        [self requestBranchNameList:self.keyString];
    
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:self.searchTextField];
    
    [self.navigationController.navigationBar addSubview:self.cancelBtn];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.searchTextField removeFromSuperview];
    
    [self.cancelBtn removeFromSuperview];
}


- (UITextField *)searchTextField {
    
    if(!_searchTextField) {
        
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(8.5, 7, DMDeviceWidth-8.75*3-28, 30)];
        _searchTextField.backgroundColor = UIColorFromRGB(0xF0F0F0);
        _searchTextField.textAlignment = NSTextAlignmentLeft;
        _searchTextField.delegate = self;
        _searchTextField.placeholder = @"  请输入支行关键词";
        _searchTextField.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:12];
        _searchTextField.layer.cornerRadius = 15.0f;
        _searchTextField.clipsToBounds = YES;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.clearButtonMode = UITextFieldViewModeAlways;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 18)];
        UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 0, 18, 18)];
        leftImgView.image = [UIImage imageNamed:@"icon-搜索-2"];
        [leftView addSubview:leftImgView];
        [_searchTextField setLeftViewMode:UITextFieldViewModeAlways];
        _searchTextField.leftView = leftView;
    }
    return _searchTextField;
}


- (UIButton *)cancelBtn {
    if(!_cancelBtn) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.frame = CGRectMake(DMDeviceWidth-8.75-28, 12, 28, 17);
        [_cancelBtn.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:14]];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
        [_cancelBtn setTitleColor:UIColorFromRGB(0x5D9AFC) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromRGB(0x5D9AFC) forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UITableView *)searchHistoryList {
    
    if (!_searchHistoryList) {
        
        _searchHistoryList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight)];
        _searchHistoryList.showsHorizontalScrollIndicator = NO;
        _searchHistoryList.showsVerticalScrollIndicator = NO;
        _searchHistoryList.delegate = self;
        _searchHistoryList.dataSource = self;
        _searchHistoryList.separatorColor = UIColorFromRGB(0xf3f3f3);
        [_searchHistoryList registerClass:[UITableViewCell class] forCellReuseIdentifier:reusableId];
        _searchHistoryList.tableFooterView = [UIView new];
    }
    return _searchHistoryList;
}

- (NSMutableArray *)searchHistoryInList {
    
    if(!_searchHistoryInList) {
        
        _searchHistoryInList = [@[] mutableCopy];
    }
    return _searchHistoryInList;
}

- (void)cancelBtnClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    [self.searchHistoryInList removeAllObjects];
    
    [self.searchHistoryList reloadData];
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    self.keyString = textField.text;
    [self requestBranchNameList:textField.text];
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.placeholder = @"  请输入支行关键词";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchHistoryInList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableId forIndexPath:indexPath];
    DMGetBranchNameModel *model = self.searchHistoryInList[indexPath.row];
    cell.textLabel.text = model.BANKBRANCHNAME;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DMGetBranchNameModel *model = [self.searchHistoryInList objectAtIndex:indexPath.row];
    NSString *itemName = model.BANKBRANCHNAME;
    !self.backAccountName ? : self.backAccountName(itemName);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

- (void)requestBranchNameList:(NSString *)keyString {
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager getBranchNameByKeyString:keyString limitCount:[@(listCount) stringValue] successBlock:^(NSArray *listArr, NSString *status) {
        self.searchHistoryInList = [NSMutableArray arrayWithArray:listArr];
        [self.searchHistoryList reloadData];
        [self.searchHistoryList.mj_header endRefreshing];
        [self.searchHistoryList.mj_footer endRefreshing];
    } faildBlock:^(NSString *message) {
        ShowMessage(message);
        [self.searchHistoryList.mj_header endRefreshing];
        [self.searchHistoryList.mj_footer endRefreshing];
    }];
}

@end
