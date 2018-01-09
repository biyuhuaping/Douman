//
//  GZCouponsViewController.m
//  豆蔓理财
//
//  Created by armada on 2016/12/20.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZCouponsViewController.h"
#import "LJQCouponsCell.h"

@interface GZCouponsViewController ()<UITableViewDelegate,UITableViewDataSource,LJQCouponCellPopDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray<LJQCouponsModel *> *dataSource;

@end

@implementation GZCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareForNavigationItem];
    
    [self prepareForCouponList];
}

#pragma mark - prepare for global layout
- (void)prepareForNavigationItem {
    
    UIButton *cancelCouponSelectionBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [cancelCouponSelectionBtn setTitle:@"不使用优惠券" forState:UIControlStateNormal];
    [cancelCouponSelectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelCouponSelectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelCouponSelectionBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelCouponSelectionBtn addTarget:self action:@selector(cancelCouponSelectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancelCouponSelectionBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Network Request
- (void)prepareForCouponList {
    //加载环形指示器
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GZHomePageRequestManager defaultManager] requestForHomePageCouponListWithUserId:USER_ID accessToken:AccessToken assetId:self.assetId successBlock:^(BOOL result, NSString *message, NSArray<LJQCouponsModel *> *couponList) {
        
        if(result){
            
            [self.dataSource addObjectsFromArray:couponList];
            [self.tableView reloadData];
        }else {
            ShowMessage(message);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failureBlock:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - lazy loading
- (UITableView *)tableView {
    
    if(!_tableView) {
        
        _tableView = [[UITableView alloc]init];

        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
        }];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[LJQCouponsCell class] forCellReuseIdentifier:@"LJQCouponCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - LJQCouponCellPopDelegate

- (void)popViewControllerWithAnimated:(BOOL)animiaton {
    
    [self.navigationController popViewControllerAnimated:animiaton];
}

#pragma mark - LJQCouponCellDelegate

- (void)cancelCouponSelectionBtnClick {
    
    [self.delegate cancelCouponSelection];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewCell Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *LJQCouponCellIdentifier = @"LJQCouponCell";
    
    LJQCouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:LJQCouponCellIdentifier forIndexPath:indexPath];
    
    LJQCouponsModel * model = [self.dataSource objectAtIndex:indexPath.row];
    
    [cell addGesture];
    cell.model = model;
    cell.couponCategory = YHCouponCategoryReturnCard;
    cell.isArrow = NO;
    cell.isExpired = NO;
    cell.popDelegate = self;
    cell.updateDelegate = self.delegate;
    
    if ([model.minimumDuration isEqualToString:model.maximumDuration]) {
        cell.durationLabel.text = [NSString stringWithFormat:@"可用于%@个月的产品",model.minimumDuration];
    }else {
        cell.durationLabel.text = [NSString stringWithFormat:@"可用于%@～%@个月的产品",model.minimumDuration,model.maximumDuration];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *image = [UIImage imageNamed:@"返现卡底色背景"];
    return image.size.height + 24;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
