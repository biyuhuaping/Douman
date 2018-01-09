//
//  GZAutomaticalInvestSignViewController.m
//  豆蔓理财
//
//  Created by armada on 2017/5/5.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZAutomaticalInvestSignViewController.h"

#import "GZFAQTableCell.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "UIButton+EnlargeTouchArea.h"
#import "MBProgressHUD.h"
#import "DMWebViewController.h"
#import "GZHomePageRequestManager.h"
#import "DMCreditRequestManager.h"
#import "DMWebUrlManager.h"
#import "NSURLRequest+SSL.h"
#import "HMTabBarViewController.h"

@interface GZAutomaticalInvestSignViewController ()<UITableViewDelegate, UITableViewDataSource>

/** FAQ列表 */
@property(nonatomic, strong) UITableView *FAQList;
/** 单选按钮 */
@property(nonatomic, strong) UIButton *radioBtn;
/** 协议标签 */
@property(nonatomic, strong) UILabel *protocolLabel;
/** "确认开启"按钮 */
@property(nonatomic, strong) UIButton *confirmBtn;

/** FAQ图标 */
@property(nonatomic, strong) NSArray *icons;
/** FAQ questions */
@property(nonatomic, strong) NSArray *questions;
/** FAQ answers */
@property(nonatomic, strong) NSArray *answers;

/** 是否签约 */
@property(nonatomic, assign) BOOL isSigned;

@property(nonatomic, strong) NSMutableDictionary *infoDict;

@end

@implementation GZAutomaticalInvestSignViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"自动投标签约";
    
    [self.img removeFromSuperview]; //移除背景图
    self.view.backgroundColor = [UIColor whiteColor]; //更改背景为白色
    
    //默认选择框为非选择状态
    self.confirmBtn.enabled = NO;
    self.radioBtn.selected = NO;
    
    [self initializeFAQs];
    
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"https"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //根据自动签约状况加载UI
    [self loadUserInterfaceWithStatusOfAutoSign];
}

#pragma mark - Network Request 

- (void)loadUserInterfaceWithStatusOfAutoSign {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[GZHomePageRequestManager defaultManager] requestStatusOfAutoSignWithUserId:USER_ID successBlock:^(NSString *status, NSString *msg) {
        
        //展示FAQ
        [self.FAQList reloadData];
        
        if([status isEqualToString:@"0"]) {
            //已签约
            self.isSigned = YES;
            
        }else if([status isEqualToString:@"1"]) {
            //托管开关未打开
            self.isSigned = NO;
            
        }else if([status isEqualToString:@"2"]) {
            //未签约
            self.isSigned = NO;
            
        }
        
        //隐藏hud
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failureBlock:^(NSError *err,NSString *msg) {
        
        if (err) {
            ShowMessage(@"网络请求失败, 请检查您的网络");
        }
        
        if (msg) {
            ShowMessage(msg);
        }
        //隐藏hud
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)getFormInfo {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[GZHomePageRequestManager defaultManager] requestForFormInfoWithUserId:USER_ID successBlock:^(NSMutableDictionary *infoDict) {
         
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.infoDict = infoDict;
        
        DMWebViewController *webVC = [[DMWebViewController alloc] init];
        
        webVC.webUrl = @"https://fbtest.sumapay.com/hsbp2pUser/merchant.do";
        
        NSMutableString *params = [NSMutableString string];
        
        for(int i = 0; i<self.infoDict.allKeys.count;i++) {
            
            if (i != self.infoDict.count-1) {
                
                NSString *key = self.infoDict.allKeys[i];
                [params appendFormat:@"%@=%@&",key,self.infoDict[key]];
                
            }else {
                
                NSString *key = self.infoDict.allKeys[i];
                
                if ([(NSString *)self.infoDict[key] containsString:@"&&"]) {
                    
                    NSString *originUrl = self.infoDict[key];
                    
                    NSString *encodeUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)originUrl, NULL, (CFStringRef)@"&", kCFStringEncodingUTF8));
                    
                    [params appendFormat:@"%@=%@",key,encodeUrl];
                    
                    continue;
                }
                
                [params appendFormat:@"%@=%@",key,self.infoDict[key]];
                
            }
        }
        
        webVC.parameter = params;
        
        [self.navigationController pushViewController:webVC animated:YES];

    } failureBlock:^(NSError *err,NSString *msg) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!err) {
            
            if ([msg isEqualToString:@"尚未设置交易密码"]) {
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"尚未设置交易密码" preferredStyle:UIAlertControllerStyleAlert];
                
                __weak __typeof__(self) weakSelf = self;
                
                UIAlertAction *setTradePasswodAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    __strong __typeof__(weakSelf) strongSelf = weakSelf;
                   
                    [strongSelf jumpToTradePassWord];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertVC addAction:setTradePasswodAction];
                [alertVC addAction:cancelAction];
                
                [weakSelf presentViewController:alertVC animated:YES completion:nil];
            }
        }
    }];
}

#pragma mark - Getter and Setter

- (void)setIsSigned:(BOOL)isSigned {
    
    _isSigned = isSigned;
    
    if (_isSigned) { //如果是签约状态
        
        //单选按钮不可点击
        self.radioBtn.enabled = NO;
        
        //立即开启按钮显示为"已开启"并且不可点击
        [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"已开启"] forState:UIControlStateDisabled];
        self.confirmBtn.enabled = NO;
        
    }else { //如果是非签约状态
        
        //单选按钮可点击,且为选择状态
        self.radioBtn.enabled = YES;
        self.radioBtn.selected = YES;
        
        //充值disabled状态图片,立即开启按钮可点击
        [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"立即开启-不可点击"] forState:UIControlStateDisabled];
        self.confirmBtn.enabled = YES;
    }
}

#pragma mark - Lazy Loading

- (void)initializeFAQs {
    
    _icons = @[@"1-投标icon",@"2-便捷icon",@"3-安全icon"];
    
    _questions = @[@"什么是自动投标",@"投资更便捷",@"安全有保障"];
    
    _answers = @[@"自动投标授权开启后即可使用批量投资功能",
                 @"开启自动投标后,系统会自动为您匹配投标,提高资金利用率",
                 @"资金由徽商银行进行存管,资金更安全可靠"];
}

- (UITableView *)FAQList {
    
    if (!_FAQList) {
        
        _FAQList = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_FAQList];
        [_FAQList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.and.right.equalTo(self.view);
            make.height.mas_offset(@240);
        }];
        _FAQList.showsVerticalScrollIndicator = NO;
        _FAQList.showsHorizontalScrollIndicator = NO;
        _FAQList.bounces = NO;
        _FAQList.separatorStyle = UITableViewCellSelectionStyleNone;
        _FAQList.delegate = self;
        _FAQList.dataSource = self;
        
        [_FAQList registerClass:[GZFAQTableCell class] forCellReuseIdentifier:@"FAQCell"];
    }
    return _FAQList;
}

- (UIButton *)radioBtn {
    
    if (!_radioBtn) {
        
        _radioBtn = [[UIButton alloc] init];
        [self.view addSubview:_radioBtn];
        [_radioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.protocolLabel.mas_left).offset(-12);
            make.centerY.equalTo(self.protocolLabel);
            make.width.mas_equalTo(@12);
            make.height.mas_equalTo(@12);
        }];
        [_radioBtn setBackgroundImage:[UIImage imageNamed:@"勾选框-默认"] forState:UIControlStateNormal];
        [_radioBtn setBackgroundImage:[UIImage imageNamed:@"勾选框-选中"]  forState:UIControlStateDisabled];
        [_radioBtn setBackgroundImage:[UIImage imageNamed:@"勾选框-选中"] forState:UIControlStateSelected];
        [_radioBtn addTarget:self action:@selector(radioBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_radioBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
        
    }
    return _radioBtn;
}

- (UILabel *)protocolLabel {
    
    if (!_protocolLabel) {
     
        _protocolLabel = [[UILabel alloc] init];
        [self.view addSubview:_protocolLabel];
        [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.FAQList.mas_bottom).offset(29);
            make.centerX.equalTo(self.view);
        }];
        
        NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:@"同意签署" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x8C8C8C)}];
        
        [mutableAttributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"<自动投标授权协议>" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x1bb182)}]];
        
        _protocolLabel.attributedText = mutableAttributedStr;
        _protocolLabel.enabledTapEffect = NO;
        __weak __typeof(self) weakSelf = self;
        [_protocolLabel DM_addAttributeTapActionWithStrings:@[@"<自动投标授权协议>"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            
            DMWebViewController *webVC = [[DMWebViewController alloc] init];
            webVC.webUrl = [[DMWebUrlManager manager] getAutoSignAuthProtocolUrl];
            webVC.navigationItem.title = @"自动投标授权";
            
            [weakSelf.navigationController pushViewController:webVC animated:YES];
            
        }];
    }
    
    return _protocolLabel;
}

- (UIButton *)confirmBtn {
    
    if (!_confirmBtn) {
        
        _confirmBtn = [[UIButton alloc] init];
        [self.view addSubview:_confirmBtn];
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.protocolLabel.mas_bottom).offset(78);
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(@160); //196
            make.height.mas_equalTo(@36);
        }];
        
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"立即开启-可点击"] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"立即开启-可点击"] forState:UIControlStateHighlighted];
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"立即开启-不可点击"] forState:UIControlStateDisabled];
        
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

#pragma mark - Function

//设置交易密码
- (void)jumpToTradePassWord {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[DMCreditRequestManager manager] replacePassWordSuccess:^(NSString *argument) {
        
        DMWebViewController *drawCash = [[DMWebViewController alloc] init];
        drawCash.parameter = argument;
        drawCash.webUrl = [[DMWebUrlManager manager] getsumapayUrl];
        
        [self.navigationController pushViewController:drawCash animated:YES];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failed:^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Button Actions

- (void)radioBtnClicked:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    //立即开启按钮状态关联单选框选择与否
    self.confirmBtn.enabled = sender.selected;
}

- (void)confirmBtnClicked:(UIButton *)sender {
    
    [self getFormInfo];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reusedIdentifier = @"FAQCell";
    
    GZFAQTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier forIndexPath:indexPath];
    
    cell.iconImageView.image = [UIImage imageNamed:self.icons[indexPath.row]];
    cell.questionLabel.text = self.questions[indexPath.row];
    cell.answerLabel.text = self.answers[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dealloc

- (void)dealloc {
    
    NSLog(@"automaticInvest Dealloc");
}

@end
