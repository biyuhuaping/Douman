//
//  LJQTopUpVC.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQTopUpVC.h"
#import "LJQTopUpCell.h"
static NSString *const topUpIdentifier = @"topupcell";
@interface LJQTopUpVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *MyTableView;
@property (nonatomic, strong)UIView *footView;
@property (nonatomic, strong)UIView *promptView;

@end

@implementation LJQTopUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"充值";
    
    //self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    self.MyTableView = [[UITableView alloc] initWithFrame: [UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    self.MyTableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.MyTableView registerClass:[LJQTopUpCell class] forCellReuseIdentifier:topUpIdentifier];
    self.MyTableView.rowHeight = 251 + 158;
    self.MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    self.MyTableView.tableFooterView = [self creteBten];
    [self.view addSubview:self.MyTableView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"限额说明" style:(UIBarButtonItemStylePlain) target:self action:@selector(limitThat)];
}



- (UIView *)creteBten {
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 400)];
    
    UIButton *button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage *image = [UIImage imageNamed:@"温馨提示"];
    button1.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    button1.center = CGPointMake(SCREENWIDTH / 2, 14 + image.size.height / 2);
    [button1 setBackgroundImage:image forState:(UIControlStateNormal)];
    [button1 setBackgroundImage:image forState:(UIControlStateHighlighted)];
    [button1 addTarget: self action:@selector(promptEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.footView addSubview:button1];
    
    return self.footView;
}


- (UIView *)CreateBottomView:(CGFloat)rect {
    self.promptView = [[UIView alloc] initWithFrame:CGRectMake(0, rect, SCREENWIDTH, 400)];
    self.promptView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    UILabel *label = [UILabel createLabelFrame:CGRectMake(30, 27, 100, 13) labelColor:UIColorFromRGB(0x71757e) textAlignment:(NSTextAlignmentLeft) textFont:13.f];
    label.text = @"充值说明";
    [self.promptView addSubview:label];
    CGFloat maxy = CGRectGetMaxY(label.frame) +10;
    NSArray *array = @[@"1.为了您的账户安全，请在充值前进行身份认证，手机绑定；",@"2.您的账户资金将由第三方平台托管",@"3.支付限额请参照限额说明",@"4.禁止洗钱，信用卡套现，虚假交易等行为，一经发现并确认，将终止该账户的使用",@"5.如果充值过程中出现问题，请联系客服400-003-3939"];
    for (int i = 0; i < 5; i++) {
        NSString *string = [NSString stringWithFormat:@"%@",array[i]];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH - 60, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} context:nil];
        
        UILabel *label1 = [UILabel createLabelFrame:CGRectMake(30, maxy, SCREENWIDTH - 60, rect.size.height) labelColor:UIColorFromRGB(0xb4b4b4) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        label1.numberOfLines = 0;
        label1.text = array[i];
        [self.promptView addSubview:label1];
        
        maxy = rect.size.height + maxy;
    }
    
    return self.promptView;
}

//充值
- (void)topUpEvent:(UIButton *)sender {
   
}

//限额说明
- (void)limitThat {
    
}

#pragma 提示
- (void)promptEvent:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = !sender.selected;
        [self.promptView removeFromSuperview];
    }else {
        sender.selected = !sender.selected;
        [sender.superview addSubview:[self CreateBottomView:CGRectGetMaxY(sender.frame)]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJQTopUpCell *cell = [tableView dequeueReusableCellWithIdentifier:topUpIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
