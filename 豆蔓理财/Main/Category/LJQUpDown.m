//
//  LJQUpDown.m
//  LJQUpDownDemo
//
//  Created by mac on 2016/11/11.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQUpDown.h"

@interface LJQUpDown ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)UIButton *privateBtn;
@property (nonatomic, retain)NSArray *nameArr;
@property (nonatomic, retain)NSArray *imageArr;

@end

NSString *const AnimationFlagUp = @"up";
NSString *const AnimationFlagDown = @"down";
@implementation LJQUpDown
@synthesize animationFlag;
@synthesize tableview;
@synthesize privateBtn;


- (instancetype)showDropDown:(UIButton *)button Height:(CGFloat)height rowHeight:(NSInteger)rowHeight NameArr:(NSArray *)nameArr ImageArr:(NSArray *)imageArr AnimatonFlag:(NSString *)flag {
    privateBtn = button;
    animationFlag = flag;
    tableview = (UITableView *)[super init];
    if (self) {
        CGRect BtnFrame = button.frame;
        self.nameArr = [NSArray arrayWithArray:nameArr];
        self.imageArr = [NSArray arrayWithArray:imageArr];
        if ([flag isEqualToString:AnimationFlagUp]) {
            self.frame = CGRectMake(BtnFrame.origin.x, BtnFrame.origin.y, BtnFrame.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-2, 2);
        }else
        if ([flag isEqualToString:AnimationFlagDown]) {
            self.frame = CGRectMake(BtnFrame.origin.x, BtnFrame.origin.y + BtnFrame.size.width, BtnFrame.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-2, 2);
        }
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, BtnFrame.size.width, 0)];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.showsHorizontalScrollIndicator = NO;
        tableview.showsVerticalScrollIndicator = NO;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.bounces = NO;
        tableview.rowHeight = rowHeight;
        tableview.layer.cornerRadius = 4;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([flag isEqualToString:AnimationFlagUp]) {
            self.frame = CGRectMake(BtnFrame.origin.x, BtnFrame.origin.y - height, BtnFrame.size.width, height);
        }else
        if ([flag isEqualToString:AnimationFlagDown]) {
            self.frame = CGRectMake(BtnFrame.origin.x, BtnFrame.origin.y + BtnFrame.size.height, BtnFrame.size.width, height);
        }
        tableview.frame = CGRectMake(0, 0, BtnFrame.size.width, height);
        [UIView commitAnimations];
        [button.superview addSubview:self];
        [self addSubview:tableview];
    }
    return self;
}

- (void)hiddenActionBtn:(UIButton *)sender {
    CGRect frame = sender.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([animationFlag isEqualToString:AnimationFlagUp]) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
    }else if ([animationFlag isEqualToString:AnimationFlagDown]) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, 0);
    }
    tableview.frame = CGRectMake(0, 0, frame.size.width, 0);
    [UIView commitAnimations];
}

#pragma tableViewDelegate && tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.text = self.nameArr[indexPath.row];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hiddenActionBtn:privateBtn];
    //设置button显示文字
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [privateBtn setTitle:cell.textLabel.text forState:(UIControlStateNormal)];
    self.ClickOnblock(indexPath.row,cell.textLabel.text);
}



@end
