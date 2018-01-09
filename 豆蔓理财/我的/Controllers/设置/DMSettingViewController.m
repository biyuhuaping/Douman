//
//  DMSettingViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/16.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMSettingViewController.h"

#import "DMRealNameCertifyViewController.h"
#import "DMWithDrawCashViewController.h"
#import "ZJDrawerController.h"

@interface DMSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *SettingTableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation DMSettingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleArray = @[@"实名认证",@"修改登录密码",@"修改交易密码",@"手势密码",@"修改手势密码",@"充值",@"提现"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置";
    
    [self.view addSubview:self.SettingtableView];
    
}

- (UITableView *)SettingtableView{
    
    if (!_SettingTableView) {
        _SettingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) style:UITableViewStylePlain];
        _SettingTableView.delegate = self;
        _SettingTableView.dataSource = self;
        _SettingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _SettingTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.titleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    NSString *title = self.titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:title];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
        
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(0, 48, DMDeviceWidth, 1)];
    botLine.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [cell addSubview:botLine];
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 49;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        switch (indexPath.row) {
            case 0:
                [self realnamecertify];
                break;
            case 1:
               
                break;
            case 2:
               
                
                break;
            case 3:
                
                
                break;
            case 4:
               
                
                break;
            case 5:
              
               
                break;
            case 6:
               // [self withdrawcash];
            {
                DMWithDrawCashViewController *withdrawcash = [[DMWithDrawCashViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:withdrawcash];

                [self presentViewController:nav animated:YES completion:^{
                   
                    [self.zj_drawerController closeRightDrawerAnimated:YES finishHandler:nil];
                }];
                
            }
                break;
                      default:
                break;
        }
        

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
 
    [super touchesEnded:touches withEvent:event];
    NSLog(@"1234567");
}

- (void)realnamecertify {
    
    DMRealNameCertifyViewController *realName = [[DMRealNameCertifyViewController alloc] init];
    [self.navigationController pushViewController:realName animated:YES];
    
    
}

-(void)withdrawcash {
    
    DMWithDrawCashViewController *withdrawcash = [[DMWithDrawCashViewController alloc] init];
    [self.navigationController pushViewController:withdrawcash animated:YES];
    
}





@end
