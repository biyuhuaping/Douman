//
//  DMCalculateViewController.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/2/16.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMCalculateViewController.h"
#import "DMCalaulateView.h"
#import "DMCalculateCell.h"

@interface DMCalculateViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) DMCalaulateView *backView;
@property (nonatomic, strong) UIButton *pageButton;
@property (nonatomic, strong) UIImageView *pageImage;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DMCalculateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"具体详情";


    [self setConstraints];
}

- (void)setConstraints{
    
    [self.view addSubview:self.backView];
    [self.view addSubview:self.tableView];
    [self.view addConstrainsWithVisualFormat:@"H:|[v0]|" Views:@[self.backView]];
    [self.view addConstrainsWithVisualFormat:@"V:|[v0]|" Views:@[self.backView]];
    [self.view addConstrainsWithVisualFormat:@"H:|[v0]|" Views:@[self.tableView]];
    [self.view addConstrainsWithVisualFormat:@"V:|-220-[v0]-40-|" Views:@[self.tableView]];
    if (self.month > 6) {
        [self.view addSubview:self.pageButton];
        [self.view addSubview:self.pageImage];
        [self.view addConstrainsWithVisualFormat:@"H:|[v0]|" Views:@[self.pageButton]];
        [self.view addConstrainsWithVisualFormat:@"V:[v0(==40)]|" Views:@[self.pageButton]];
        [self.view addConstrainsWithVisualFormat:@"H:[v0(==13)]" Views:@[self.pageImage]];
        [self.view addConstrainsWithVisualFormat:@"V:[v0(==15)]-10-|" Views:@[self.pageImage]];
        [self.view addConstraintWithSetView:self.pageImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    }
    
}


- (DMCalaulateView *)backView{
    if (!_backView) {
        self.backView = [[DMCalaulateView alloc] initWithInvestAmount:self.investAmount Type:self.type Rate:self.rate Month:self.month];
    }
    return _backView;
}

- (UIButton *)pageButton{
    if (!_pageButton) {
        self.pageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pageButton addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageButton;
}

- (UIImageView *)pageImage{
    if (!_pageImage) {
        self.pageImage = [[UIImageView alloc] init];
        _pageImage.image = [UIImage imageNamed:@"next_page"];
        _pageImage.highlightedImage = [UIImage imageNamed:@"front_page"];
    }
    return _pageImage;
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pagingEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
//        [_tableView registerClass:[DMCalculateCell class] forCellReuseIdentifier:@"DMCalculateCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.month>6?12:self.month;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.height/6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMCalculateCell *cell = [[DMCalculateCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DMCalculateCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.monthLabel.text = [NSString stringWithFormat:@"第%zd月",indexPath.row + 1];
    
    double amount = [self.investAmount doubleValue];
    CGFloat duration = self.month;
    CGFloat rates = [self.rate doubleValue];
    CGFloat yuejiebenxi = 0.0;
    if ([self.type isEqualToString:@"等额本息"]) {
        CGFloat monthRate = rates / 100 / 12;
        yuejiebenxi = (amount * (monthRate * pow(1 + monthRate, duration))/(pow((1 + monthRate), duration) - 1));
    }
    if ([self.type isEqualToString:@"按月付息"]){
        yuejiebenxi = (amount * rates / 100 / 12);
    }
    CGFloat yuehuanlixi = (amount * (rates / 100 / 12) - yuejiebenxi) * pow(((rates / 100 / 12) + 1), indexPath.row) + yuejiebenxi;
    CGFloat yuejiebenjin = yuejiebenxi - yuehuanlixi;
    CGFloat yujishouyi = (duration * yuejiebenxi - amount);
    CGFloat daishoubenxi = fabs(amount + yujishouyi - (indexPath.row + 1)*yuejiebenxi);
    if ([self.type isEqualToString:@"按月付息"] && indexPath.row == self.month-1) {
        cell.baseMoney.text = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",yuejiebenjin + amount]];
    }else{
        cell.baseMoney.text = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",yuejiebenjin]];
    }
    cell.profitLabel.text = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",yuehuanlixi]];
    if ([self.type isEqualToString:@"按月付息"] && indexPath.row != self.month-1) {
        cell.waitMoney.text = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",daishoubenxi+amount]];
    }else{
        cell.waitMoney.text = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",daishoubenxi]];
    }
    if (indexPath.row >= self.month) {
        cell.monthLabel.text = @"";
        cell.baseMoney.text = @"";
        cell.profitLabel.text = @"";
        cell.waitMoney.text = @"";
        cell.spectorLine.hidden = YES;
    }
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = self.tableView.contentOffset.y;
    if (offset == 0) {
        self.pageImage.highlighted = false;
    }else{
        self.pageImage.highlighted = true;
    }
}


- (void)nextPage:(UIButton *)btn{
    CGFloat offset = self.tableView.contentOffset.y;
    CGFloat height = self.tableView.bounds.size.height;
    if (offset == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentOffset = CGPointMake(0, height);
        }];
        self.pageImage.highlighted = true;
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentOffset = CGPointMake(0, 0);
        }];
        self.pageImage.highlighted = false;
    }
    
}




@end
