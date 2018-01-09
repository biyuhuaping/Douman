//
//  DMSlideMenuView.m
//  豆蔓理财
//
//  Created by edz on 2016/11/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMSlideMenuView.h"
#import "DMLoginViewController.h"

@interface DMSlideMenuView()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong)UIImageView *LogoImg;
@property (nonatomic, strong)UITableView *listTV;

@property (nonatomic, strong)NSArray *titleArray;

@property (nonatomic, strong)UIButton *topUpBtn;
@property (nonatomic, strong)UIButton *leaveBtn;

@property (nonatomic, strong)UIButton *assignmentBtn;



@end

@implementation DMSlideMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.titleArray = @[@"关于我们",@"银行存管",@"优质资产",@"帮助中心1",@"联系客服1"];
        [self initView];
    }
    return  self;
}


- (UIViewController *)viewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}


-(void)initView{
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slideback"]];
    [self addSubview:self.CreateLogoImg];
    [self addSubview:self.CreateListTV];
    [self addSubview:self.CreateTopUpBth];
    [self addSubview:self.landedBtn];
    //[self addSubview:self.assignmentBtn];
    
    UIImageView *imageViewSepE = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 49*DMDeviceWidth/375, self.frame.size.width, 1)];
    imageViewSepE.backgroundColor = UIColorFromRGB(0x2e2e39);
    [self addSubview:imageViewSepE];
}


- (UIImageView *)CreateLogoImg {
    if (!_LogoImg) {
        _LogoImg = [[UIImageView alloc] init];
        _LogoImg.frame = CGRectMake((DMDeviceWidth*0.75 - 146)/2, 20 + 32, 146, 75);
        _LogoImg.image = [UIImage imageNamed:@"logo_picture"];
    }
    return _LogoImg;
    
}

- (UITableView *)CreateListTV {
    if (!_listTV) {
        _listTV = [[UITableView alloc] initWithFrame:CGRectMake(0, _LogoImg.frame.origin.y + _LogoImg.frame.size.height+46, self.frame.size.width, 60 * 5 * DMDeviceHeight/667) style:UITableViewStylePlain];
        _listTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _listTV.separatorColor = UIColorFromRGB(0x2e2e39);
        _listTV.backgroundColor = [UIColor clearColor];
        _listTV.delegate = self;
        _listTV.dataSource = self;
        _listTV.scrollEnabled = NO;
        _listTV.tableFooterView = [UIView new];
    }
    return _listTV;
}
#pragma mark -- tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 * DMDeviceHeight/667;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"123";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(Cell == nil){
        
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    Cell.backgroundColor = [UIColor clearColor];
    Cell.textLabel.backgroundColor = [UIColor clearColor];
    Cell.imageView.image = [UIImage imageNamed:self.titleArray[indexPath.row]];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}

- (UIButton *)CreateTopUpBth {
    if (!_topUpBtn) {
        _topUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topUpBtn.frame =  CGRectMake(0, self.frame.size.height - 100*DMDeviceWidth/375, 100*DMDeviceWidth/375, 50*DMDeviceWidth/375);
        [_topUpBtn setImage:[UIImage imageNamed:@"topUp"] forState:UIControlStateNormal];
        _topUpBtn.tag = 100 + 5;
        _topUpBtn.adjustsImageWhenHighlighted = NO;
        [_topUpBtn addTarget:self action:@selector(TopUpAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topUpBtn;
}


- (UIButton *)assignmentBtn {
    
    if (!_assignmentBtn) {
        _assignmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _assignmentBtn.frame = CGRectMake(DMDeviceWidth*0.75 - 30 - 184/2, self.frame.size.height - 90*DMDeviceWidth/375, 92*DMDeviceWidth/375, 27*DMDeviceWidth/375);
        _assignmentBtn.titleEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
        [_assignmentBtn setImage:[UIImage imageNamed:@"债权转让（新）"] forState:UIControlStateNormal];

        [_assignmentBtn addTarget:self action:@selector(assignment:) forControlEvents:UIControlEventTouchUpInside];
        _assignmentBtn.tag = 107;
    }
    
    return _assignmentBtn;
    
}

- (void)assignment:(UIButton *)btn {
    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]){
        [self.customDelegate LeftMenuViewClick:(btn.tag-100)];
    }
}


- (UIButton *)landedBtn {
    if (!_landedBtn) {
        _landedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _landedBtn.tag = 106;
        _landedBtn.frame =  CGRectMake(0, self.frame.size.height - 50*DMDeviceWidth/375, 100*DMDeviceWidth/375, 50*DMDeviceWidth/375);
        _landedBtn.contentMode=UIViewContentModeCenter;
        
        if (!AccessToken) {
            [_landedBtn setImage:[UIImage imageNamed:@"登录"] forState:UIControlStateNormal];
        } else {
            [_landedBtn setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
        }
        [_landedBtn addTarget:self action:@selector(TopUpAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _landedBtn;
}

- (void)TopUpAction:(UIButton *)btn {
    if (!AccessToken) {
        [_landedBtn setImage:[UIImage imageNamed:@"登录"] forState:UIControlStateNormal];
    } else {
        [_landedBtn setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
    }

    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]){
        [self.customDelegate LeftMenuViewClick:(btn.tag-100)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]){
        [self.customDelegate LeftMenuViewClick:indexPath.row];
    }
    
}




@end
