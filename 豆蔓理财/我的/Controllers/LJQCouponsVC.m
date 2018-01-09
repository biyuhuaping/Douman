//
//  LJQCouponsVC.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQCouponsVC.h"
#import "YHSegmentCell.h"
#import "LJQCouponsCell.h"
#import "LJQHomeManager.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define CELLWIDTH 100.f
#define sliderWidth 50.f
#define CELLHEIGHT 213 * SCREENWIDTH / 534

NSString *const LJQSegmentCellIdentifier = @"LJQSegmentCell";
NSString *const LJQCouponCellIdentifier = @"LJQCouponCell";

static NSInteger listCount = 20;
@interface LJQCouponsVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic) UICollectionView *collectionView;
@property(nonatomic) NSArray *strArray;
@property(nonatomic) UIView  *sliderView;
@property(nonatomic) UITableView *tableView;

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, assign) CGFloat  selectedCellOriginX;
@property(nonatomic, assign) BOOL  isExpired;
@property (nonatomic, assign)BOOL isArrow;
@property (nonatomic, strong)NSMutableArray *DataSource;

@property (nonatomic, copy) NSString *statue;

@end

@implementation LJQCouponsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"优惠券";
    _isArrow = YES;
    [self requestCouponsData:@"PLACED" page:1 size:listCount];
    self.statue = @"PLACED";
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"使用卡券" forState:(UIControlStateNormal)];
    button.frame = CGRectMake(0, 0, 70, 16);
    [button setTitleColor:UIColorFromRGB(0x595757) forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button addTarget:self action:@selector(JumpToHome) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.strArray = @[@"未使用", @"已使用", @"已过期"];
    [self __initSegmentView];
    [self __initAnimationView];
    [self __initTableView];
    [self.tableView reloadData];

}

- (void)JumpToHome {
    
    LJQHomeManager *manager = [LJQHomeManager shareHomeManager];
    manager.isOpen = 1;
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - private
- (void)__initSegmentView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(CELLWIDTH, 40.f);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 40)
                                         collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[YHSegmentCell class] forCellWithReuseIdentifier:LJQSegmentCellIdentifier];
    [self.view addSubview:_collectionView];
    
}

- (void)__initAnimationView{
    
    UIView * animationView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), SCREENWIDTH, 10)];
    animationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:animationView];
    
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(25.f, 0, sliderWidth, 2.f)];
    _sliderView.backgroundColor = UIColorFromRGB(0x435b83);
    [animationView addSubview:_sliderView];
    
}

- (void)__initTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame) + 10, SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(_collectionView.frame) - 100.f)];
    _tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = CELLHEIGHT;
    [_tableView registerClass:[LJQCouponsCell class] forCellReuseIdentifier:LJQCouponCellIdentifier];
    [self.view addSubview:_tableView];
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    _tableView.mj_header = [self setRefreshHeader:^{
        [weakSelf requestCouponsData:weakSelf.statue page:1 size:listCount];
    }];
    
    //上拉加载
    _tableView.mj_footer = [self setRefreshFooter:^{
        listCount += 10;
        [weakSelf requestCouponsData:weakSelf.statue page:1 size:listCount];
    }];
}

- (void)setFootView{
    if (self.DataSource.count == 0) {
        UILabel *label = [UILabel initWithFrame:self.tableView.bounds
                                           Font:17
                                           Text:@"暂无数据"
                                      Alignment:NSTextAlignmentCenter
                                      TextColor:UIColorFromRGB(0x595757)];
        self.tableView.tableFooterView = label;
    }else{
        self.tableView.tableFooterView = [UIView new];
    }
}


#pragma mark - event

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    
    _selectedIndex = selectedIndex;

    if (selectedIndex == 0 || selectedIndex == 1) {
        _isExpired = NO;
    }else {
        _isExpired = YES;
    }
    if (selectedIndex == 0) {
        _isArrow = YES;
    }else {
        _isArrow = NO;
    }

    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frames = _sliderView.frame;
        frames.origin.x = _selectedCellOriginX + (CELLWIDTH *0.5 - sliderWidth* 0.5);
        _sliderView.frame = frames;
        
    }];
    
    [_collectionView reloadData];
    [_tableView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _strArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHSegmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LJQSegmentCellIdentifier forIndexPath:indexPath];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:_strArray[indexPath.row] attributes:@{NSBaselineOffsetAttributeName:@(-5)}];
    cell.textLabel.attributedText = attribute;
    if(_selectedIndex == indexPath.row){
        cell.isSelected  =  YES;
    }else{
        cell.isSelected  =  NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHSegmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LJQSegmentCellIdentifier forIndexPath:indexPath];
    self.selectedCellOriginX = cell.frame.origin.x;
    self.selectedIndex = indexPath.row;
    
    if (indexPath.row == 0) {
        //未使用
        self.statue = @"PLACED";
         [self requestCouponsData:@"PLACED" page:1 size:listCount];
           }else if (indexPath.row == 1) {
        //已使用
        self.statue = @"USED";
         [self requestCouponsData:@"USED" page:1 size:listCount];
           }else {
        //已过期
        self.statue = @"EXPIRED";
         [self requestCouponsData:@"EXPIRED" page:1 size:listCount];
    }
}

#pragma mark - tableViewDelegate, tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.DataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = [UIImage imageNamed:@"返现卡底色背景"];
    return image.size.height + 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LJQCouponsCell   *cell    = [tableView dequeueReusableCellWithIdentifier:LJQCouponCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.DataSource[indexPath.row];
    cell.isExpired       = _isExpired;
    cell.isArrow = _isArrow;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.statue isEqualToString:@"PLACED"]) {
        LJQHomeManager *manager = [LJQHomeManager shareHomeManager];
        manager.isOpen = 1;
        [self.tabBarController setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

- (void)backClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestCouponsData:(NSString *)status page:(NSInteger)page size:(NSInteger)size{
    
    [[LJQMineRequestManager RequestManager] LJQCouponsDataStatus:status page:page size:size successBlock:^(NSInteger index, NSArray *array, NSString *message) {
        //成功
        self.DataSource = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
        [self setFootView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } faild:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self setFootView];
    }];
}


- (NSMutableArray *)DataSource {
    if (!_DataSource) {
        self.DataSource = [@[] mutableCopy];
    }
    return _DataSource;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
