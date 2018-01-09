//
//  DMRightSlideMenuView.m
//  豆蔓理财
//
//  Created by edz on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMRightSlideMenuView.h"
#import "DMLoginRequestManager.h"
#import "LJQSettingUpCell.h"

static NSString *const LJQSettingUpIdentifier = @"LJQSettingUpCell";

@interface DMRightSlideMenuView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UIImageView *LogoImg;
@property (nonatomic, strong)UITableView *listTV;

@property (nonatomic, strong)NSArray *nameArr;
@property (nonatomic, strong)NSArray *imageArr;

@property (nonatomic, strong)UIButton *leaveBtn;

@end



@implementation DMRightSlideMenuView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){

        self.nameArr = @[@"密码设置",@"分享好友",@"赏赐好评",@"联系客服",@"帮助中心",@"关于我们"];
        self.imageArr = @[@"密码设置N",@"分享好友iconN",@"赏赐好评N",@"联系客服iconN",@"帮助中心N",@"关于我们N"];
        
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
    
    self.backgroundColor = MainF5;
    [self addSubview:self.LogoImg];
    [self addSubview:self.listTV];

    [self addSubview:self.leaveBtn];
}


- (UIImageView *)LogoImg {
    
    if (!_LogoImg) {
        
        _LogoImg = [[UIImageView alloc] init];
        _LogoImg.frame = CGRectMake((DMDeviceWidth*0.75 - 292 / 2)/2, 20 + 32, 292 / 2, 151 / 2);
        _LogoImg.contentMode = UIViewContentModeScaleAspectFill;
        _LogoImg.image = [UIImage imageNamed:@"logo_picture"];
        
    }
    return _LogoImg;
}

- (UITableView *)listTV {
    
    if (!_listTV) {
        
        _listTV = [[UITableView alloc] initWithFrame:CGRectMake(0, _LogoImg.frame.origin.y + _LogoImg.frame.size.height+26, self.frame.size.width, 50*DMDeviceWidth/375 *9) style:UITableViewStylePlain];
        //_listTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTV.separatorColor = MainLine;
        _listTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _listTV.backgroundColor = [UIColor clearColor];
        [_listTV registerClass:[LJQSettingUpCell class] forCellReuseIdentifier:LJQSettingUpIdentifier];
        _listTV.delegate = self;
        _listTV.dataSource = self;
        _listTV.scrollEnabled = NO;
        _listTV.tableFooterView = [UIView new];
    }
    return _listTV;
    
}


#pragma mark -- tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 50*DMDeviceWidth/375;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LJQSettingUpCell *cell = [tableView dequeueReusableCellWithIdentifier:LJQSettingUpIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.pitcureView.image = [[UIImage imageNamed:self.imageArr[indexPath.row]] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    cell.nameLabel.text = self.nameArr[indexPath.row];
    return cell;
    
}

- (UIButton *)leaveBtn {
    
    if (!_leaveBtn) {
        _leaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leaveBtn.frame =  CGRectMake(0, self.frame.size.height - 40, self.bounds.size.width, 40);
        [_leaveBtn setImage:[UIImage imageNamed:@"退出登录"] forState:UIControlStateNormal];
        [_leaveBtn setImage:[UIImage imageNamed:@"退出登录"] forState:UIControlStateHighlighted];
        [_leaveBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
        _leaveBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_leaveBtn setTitleColor:LightGray forState:(UIControlStateNormal)];
        [_leaveBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        _leaveBtn.tag = 100 + 6;
        [_leaveBtn addTarget:self action:@selector(TopUpAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leaveBtn;
    
}

- (void)TopUpAction:(UIButton *)btn {
    
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
