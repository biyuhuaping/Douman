//
//  GZDiscoveryViewController.m
//  豆蔓理财
//
//  Created by armada on 2017/5/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZDiscoveryViewController.h"

#import "GZActivityTableCell.h"
#import "GZDashboardTableCell.h"

@interface GZDiscoveryViewController ()<UITableViewDelegate, UITableViewDataSource>

/** 背景内容视图 */
@property(nonatomic, strong) UIView *contentView;
/** 列表表头视图 */
@property(nonatomic, strong) UIView *listHeaderView;
/** "活动"按钮 */
@property(nonatomic, strong) UIButton *activityBtn;
/** "公告"按钮 */
@property(nonatomic, strong) UIButton *dashboardBtn;
/** 选中下划线 */
@property(nonatomic, strong) UIImageView *selectedUnderlineImgView;
/** 内容列表 */
@property(nonatomic, strong) UITableView *contentList;

/** 数据源 */
@property(nonatomic, strong) NSMutableArray *dataSource;

/** 记录状态 */
@property(nonatomic, assign) GZDiscoveryItems item;
/** 记录当前按钮 */
@property(nonatomic, strong) UIButton *currentBtn;

@end

@implementation GZDiscoveryViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.item = GZDiscoveryItemsActivity;
    self.currentBtn = self.activityBtn;
    
    [self install];
    
    [self.contentList reloadData];
}

#pragma mark - Global Initilization

- (void)install {
    
    UIView *graySeparatorLine = [[UIView alloc] init];
    [self.listHeaderView addSubview:graySeparatorLine];
    [graySeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectedUnderlineImgView.mas_bottom);
        make.left.equalTo(self.listHeaderView).offset(12);
        make.right.equalTo(self.listHeaderView).offset(-12);
        make.height.mas_equalTo(@1);
    }];
    graySeparatorLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
}

#pragma mark - Lazy Loading

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray arrayWithCapacity:20];
    }
    return _dataSource;
}

- (UIView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64-49)];
        [self.view addSubview:_contentView];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIView *)listHeaderView {
    
    if (!_listHeaderView) {
        
        _listHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 44)];
    }
    return _listHeaderView;
}

- (UIButton *)activityBtn {
    
    if (!_activityBtn) {
        
        _activityBtn = [[UIButton alloc] init];
        [self.listHeaderView addSubview:_activityBtn];
        [_activityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.listHeaderView).offset(14);
            make.centerX.equalTo(self.listHeaderView).offset(-DMDeviceWidth/6);
            make.height.mas_equalTo(@16);
            make.width.mas_equalTo(@50);
        }];
        [_activityBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_activityBtn setTitle:@"活动" forState:UIControlStateNormal];
        [_activityBtn setTitle:@"活动" forState:UIControlStateHighlighted];
        [_activityBtn setTitleColor:UIColorFromRGB(0x445c85) forState:UIControlStateNormal];
        [_activityBtn setTitleColor:UIColorFromRGB(0x445c85) forState:UIControlStateHighlighted];
        
        [_activityBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activityBtn;
}

- (UIButton *)dashboardBtn {
    
    if (!_dashboardBtn) {
        
        _dashboardBtn = [[UIButton alloc] init];
        [self.listHeaderView addSubview:_dashboardBtn];
        [_dashboardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.activityBtn);
            make.centerX.equalTo(self.listHeaderView).offset(DMDeviceWidth/6);
            make.height.mas_equalTo(@16);
            make.width.mas_equalTo(@50);
        }];
        [_dashboardBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_dashboardBtn setTitle:@"公告" forState:UIControlStateNormal];
        [_dashboardBtn setTitle:@"公告" forState:UIControlStateHighlighted];
        [_dashboardBtn setTitleColor:UIColorFromRGB(0x445c85) forState:UIControlStateNormal];
        [_dashboardBtn setTitleColor:UIColorFromRGB(0x445c85) forState:UIControlStateHighlighted];
        [_dashboardBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dashboardBtn;
}

- (UIImageView *)selectedUnderlineImgView {
    
    if (!_selectedUnderlineImgView) {
        
        _selectedUnderlineImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中线"]];
        [self.listHeaderView addSubview:_selectedUnderlineImgView];
        [_selectedUnderlineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dashboardBtn.mas_bottom).offset(14);
            make.centerX.equalTo(self.listHeaderView).offset(-DMDeviceWidth/6);
            make.width.mas_equalTo(@80);
            make.height.mas_equalTo(@2);
        }];
    }
    return _selectedUnderlineImgView;
}

- (UITableView *)contentList {
    
    if (!_contentList) {
        
        _contentList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.contentView addSubview:_contentList];
        [_contentList mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        [_contentList setShowsVerticalScrollIndicator:NO];
        [_contentList setShowsHorizontalScrollIndicator:NO];
        [_contentList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_contentList setDataSource:self];
        [_contentList setDelegate:self];
        [_contentList setDelaysContentTouches:NO];
        
        _contentList.tableHeaderView = self.listHeaderView;
        
        [_contentList registerClass:[GZActivityTableCell class] forCellReuseIdentifier:@"activityCell"];
        [_contentList registerClass:[GZDashboardTableCell class] forCellReuseIdentifier:@"dashboardCell"];
    }
    return _contentList;
}

#pragma mark - Target Action

- (void)btnClick:(UIButton *)sender {
    
    if (self.currentBtn != sender) { //如果点击的标签按钮不是当前的按钮
        
        self.currentBtn = sender; //重置当前选中的标签按钮
        
        __weak __typeof__(self) weakself = self;
        
        if (sender == self.activityBtn) {
            
            //修改布局
            [weakself.selectedUnderlineImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView).offset(-DMDeviceWidth/6);
            }];
            //动画变换
            [UIView animateWithDuration:0.5 animations:^{
                [self.contentView layoutIfNeeded];
            }];
            
            self.item = GZDiscoveryItemsActivity;
            [self.contentList reloadData];
            
        }else if (sender == self.dashboardBtn) {
            
            //修改布局
            [weakself.selectedUnderlineImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.contentView).offset(DMDeviceWidth/6);
            }];
            //动画变换
            [UIView animateWithDuration:0.5 animations:^{
                [self.contentView layoutIfNeeded];
            }];
            
            self.item = GZDiscoveryItemsNotification;
            [self.contentList reloadData];
        }
        
    }
}

#pragma mark - UITableView Delegate 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.dataSource.count;
    if (self.item == GZDiscoveryItemsActivity) {
        return 4;
    }else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.item == GZDiscoveryItemsActivity) {
        
        static NSString *reusedActivityId = @"activityCell";
        GZActivityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedActivityId forIndexPath:indexPath];
        
        cell.activityTitleLabel.text = @"踏金季合规前行----赢大奖";
        cell.activityTimeStampLabel.text = @"2017-04-21";
        cell.activityLogoImageView.image = [UIImage imageNamed:@"图片"];
        
        return cell;
    
    }else {
        
        static NSString *reusedDashboardId = @"dashboardCell";
        
        GZDashboardTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedDashboardId forIndexPath:indexPath];
        
        cell.notificationTitleLabel.text = @"关于平台品牌升级及相关业务安排的通知";
        cell.notificationTimeStampLabel.text = @"2017-04-05";
        cell.notificationSummaryLabel.text = @"为了更好迎合监督规范及业务需要,平台将于4月5日进行全新品牌升级.";
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.item == GZDiscoveryItemsActivity) {
        return 180.0f;
    }else {
        return 100.0f;
    }
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
