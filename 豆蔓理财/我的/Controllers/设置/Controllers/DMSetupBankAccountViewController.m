//
//  DMSetupBankAccountViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/11/23.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMSetupBankAccountViewController.h"
#import "DMSetupBankTableViewCell.h"


@interface DMSetupBankAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *imgarr;
    NSArray *namearr;
    NSArray *abbarr;
    NSArray *onearr;
    NSArray *dayarr;
    
}

@property (nonatomic ,strong)UITableView *tableView;

@end

@implementation DMSetupBankAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"限额说明";
    
    
    self.img.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *BandName = [[UILabel alloc] init];
    BandName.frame = CGRectMake(65, 20, (DMDeviceWidth - 65)/4, 14);
    BandName.text = @"银行名称";
    BandName.textAlignment = NSTextAlignmentCenter;
    BandName.textColor = UIColorFromRGB(0x595757);
    BandName.font = SYSTEMFONT(14);
    [self.view addSubview:BandName];
    
    UILabel *abbreviation =[[UILabel alloc] init];
    abbreviation.frame = CGRectMake(65+(DMDeviceWidth - 65)/4, 20, (DMDeviceWidth - 65)/4, 14);
    abbreviation.text = @"简称";
    abbreviation.textAlignment = NSTextAlignmentCenter;
    abbreviation.textColor = UIColorFromRGB(0x595757);
    abbreviation.font = SYSTEMFONT(14);
    [self.view addSubview:abbreviation];

    
    UILabel *onetime =[[UILabel alloc] init];
    onetime.frame = CGRectMake(65+(DMDeviceWidth - 65)/4*2, 20, (DMDeviceWidth - 65)/4, 14);
    onetime.text = @"单次限额";
    onetime.textAlignment = NSTextAlignmentCenter;
    onetime.textColor = UIColorFromRGB(0x595757);
    onetime.font = SYSTEMFONT(14);
    [self.view addSubview:onetime];
    
    
    UILabel *day =[[UILabel alloc] init];
    day.frame = CGRectMake(65+(DMDeviceWidth - 65)/4*3, 20, (DMDeviceWidth - 65)/4, 14);
    day.text = @"日限额";
    day.textAlignment = NSTextAlignmentCenter;
    day.textColor = UIColorFromRGB(0x595757);
    day.font = SYSTEMFONT(14);
    [self.view addSubview:day];
    
    
    [self.view addSubview:self.tableView];
    
    
}


- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
        imgarr = @[@"bank_jian",@"bank_nong",@"bank_china",@"bank_da",@"bank_fa",@"bank_gong",@"bank_hua",@"bank_jiao",@"bank_min",@"bank_ping",@"bank_pu",@"bank_xing",@"bank_you",@"bank_zhao",@"bank_zhong"];
        namearr = @[@"中国建设银行",@"中国农业银行",@"中国银行",@"中国光大银行",@"广发银行",@"中国工商银行",@"华夏银行",@"交通银行",@"民生银行",@"平安银行",@"浦发银行",@"兴业银行",@"邮政邮储银行",@"招商银行",@"中信银行"];
        abbarr = @[@"CCB",@"ABC",@"BOC",@"CEB",@"GDB",@"ICBC",@"HXB",@"BOCOM",@"CMBC",@"PINGAN",@"SPDB",@"CIB",@"PSBC",@"CMB",@"CITIC"];

        onearr = @[@"2万元",@"2万元",@"2万元",@"2万元",@"2万元",@"2万元",@"2万元",@"2万元",@"2万元",@"2万元",@"2万元",@"2万元",@"2万元",@"2万元",@"5000元"];


        dayarr = @[@"5万元",@"5万元",@"5万元",@"5万元",@"5万元",@"5万元",@"5万元",@"5万元",@"5万元",@"5万元",@"5万元",@"5万元",@"5万元",@"5万元",@"5000元"];
    }
    
    return self;
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 34, DMDeviceWidth, DMDeviceHeight - 64 - 34) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        

    }
    
    return _tableView;
}


#pragma tableViewDataSource && tableViewDelegete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"123";
    
    
    DMSetupBankTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(Cell == nil){
        
        Cell = [[DMSetupBankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Cell.image.image = [UIImage imageNamed:imgarr[indexPath.row]];
    
    Cell.name.text = namearr[indexPath.row];
    Cell.simple.text = abbarr[indexPath.row];
    Cell.onetime.text = onearr[indexPath.row];
    Cell.day.text = dayarr[indexPath.row];
    

    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
}





@end
