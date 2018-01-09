//
//  LLLockViewController.m
//  LockSample
//
//  Created by Lugede on 14/11/11.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLLockViewController.h"
#import "LLLockIndicator.h"
#import "DMCheckPsdViewController.h"
#import "DMLoginRequestManager.h"
#import "DMCodeViewController.h"


#define kTipColorNormal MainGreen
#define kTipColorError MainRed


@interface LLLockViewController ()
{
    int nRetryTimesRemain; // 剩余几次输入机会
}

@property (nonatomic, strong) LLLockIndicator* indecator; // 九点指示图
@property (nonatomic, strong) LLLockView* lockview; // 触摸田字控件
@property (strong, nonatomic) UILabel *tipLable;

@property (nonatomic, strong) NSString* savedPassword; // 本地存储的密码
@property (nonatomic, strong) NSString* passwordOld; // 旧密码
@property (nonatomic, strong) NSString* passwordNew; // 新密码
@property (nonatomic, strong) NSString* passwordconfirm; // 确认密码
@property (nonatomic, strong) NSString* tip1; // 提示语
@property (nonatomic, strong) NSString* tip2;

@property (strong, nonatomic) UIButton *forgetButton;
@property (strong, nonatomic) UILabel *userLabel;
@end


@implementation LLLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(LLLockViewType)type
{
    self = [super init];
    if (self) {
        _nLockViewType = type;
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.indecator];
    [self.view addSubview:self.userLabel];
    [self.view addSubview:self.tipLable];
    [self.view addSubview:self.lockview];
    [self.view addSubview:self.forgetButton];

    self.lockview.delegate = self;
    
    // 尝试机会
    nRetryTimesRemain = LLLockRetryTimes;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _tipLable.textColor = MainRed;
    // 初始化内容
    switch (_nLockViewType) {
        case LLLockViewTypeCheck:
        {
            self.userLabel.text = [self getUserName];
            self.userLabel.textColor = MainGreen;
            _tipLable.text = @"请输入解锁密码";
            self.title = @"请输入手势密码";
            self.forgetButton.alpha = 1;
            [self.forgetButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
            [self.forgetButton setTitleColor:DarkGray forState:UIControlStateNormal];
            self.indecator.alpha = 0;
        }
            break;
        case LLLockViewTypeCreate:
        {
            _tipLable.text = @"创建手势密码";
            self.title = @"设置手势密码";
            [self.forgetButton setTitle:@"重新设置" forState:UIControlStateNormal];
            [self.forgetButton setTitleColor:DarkGray forState:UIControlStateNormal];
            self.forgetButton.alpha = 0;
            self.indecator.alpha = 1;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(skipTouch:)];

            if ([self.leftType isEqualToString:@"login"]) {
                UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
                skipBtn.frame = CGRectMake(0, 0, 40, 20);
                skipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [skipBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
                [skipBtn addTarget:self action:@selector(skipTouch:) forControlEvents:UIControlEventTouchUpInside];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:skipBtn];
            }else{

            }
        }
            break;
        case LLLockViewTypeModify:
        {
            _tipLable.text = @"请输入密码以修改密码";
            self.title = @"修改手势密码";
            [self.forgetButton setTitle:@"重新设置" forState:UIControlStateNormal];
            [self.forgetButton setTitleColor:DarkGray forState:UIControlStateNormal];
            self.forgetButton.alpha = 0;
            self.indecator.alpha = 1;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(skipTouch:)];
            
        }
            break;
        case LLLockViewTypeClean:
            self.forgetButton.alpha = 0;
            self.indecator.alpha = 0;
            self.title = @"验证密码";
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(skipTouch:)];
            _tipLable.text = @"请输入密码以清除密码";
            break;
        default:
            break;
    }
    
    
    self.passwordOld = @"";
    self.passwordNew = @"";
    self.passwordconfirm = @"";
    
    // 本地保存的手势密码
    self.savedPassword = [LLLockPassword loadLockPassword];
    
    [self.indecator setPasswordString:self.passwordNew];
}


#pragma mark - 检查/更新密码
- (void)checkPassword:(NSString*)string
{
    // 验证密码正确
    if ([string isEqualToString:self.savedPassword]) {
        
        if (_nLockViewType == LLLockViewTypeModify) { // 验证旧密码
            
            self.passwordOld = string; // 设置旧密码，说明是在修改
            
            [self setTip:@"请输入新的密码"]; // 这里和下面的delegate不一致，有空重构
            
        } else if (_nLockViewType == LLLockViewTypeClean) { // 清除密码
            [LLLockPassword removeLockPassWord];
            [self hide];
        } else { // 验证成功
            [self hide];
        }
        
    }
    // 验证密码错误
    else if (string.length > 0) {
        if (self.nLockViewType == LLLockViewTypeCheck) {
            nRetryTimesRemain--;
            if (nRetryTimesRemain > 0) {
                
                [self setErrorTip:[NSString stringWithFormat:@"密码错误，您还可以再输入%d次", nRetryTimesRemain]
                        errorPswd:string];
                
            } else {
                
                //[[CLTLoginRequestManager manager] exit];
                // 强制注销该账户，并清除手势密码，以便重设
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    ShowMessage(@"请重新登录");
                    [[DMLoginRequestManager manager] exit];
                    [LLLockPassword removeLockPassWord];
                }]; // 由于是强制登录，这里必须以NO ani的方式才可
            }
        }else{
            nRetryTimesRemain--;
            if (nRetryTimesRemain > 0) {
                [self setErrorTip:[NSString stringWithFormat:@"密码错误"]
                        errorPswd:string];
            } else {
                ShowMessage(@"密码验证失败");
                [self.navigationController popViewControllerAnimated:YES];
            }

        }
    } else {
        NSAssert(YES, @"意外情况");
    }
}

- (void)createPassword:(NSString*)string
{
    // 输入密码
    if ([self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {
        self.forgetButton.alpha = 1;
        self.passwordNew = string;
        [self setTip:self.tip2];
    }
    // 确认输入密码
    else if (![self.passwordNew isEqualToString:@""] && [self.passwordconfirm isEqualToString:@""]) {

        self.passwordconfirm = string;
        
        if ([self.passwordNew isEqualToString:self.passwordconfirm]) {
            // 成功            
            [LLLockPassword saveLockPassword:self.passwordconfirm];
            
            [self hide];
            
        } else {
            nRetryTimesRemain--;
            
            if (nRetryTimesRemain > 0) {
                self.passwordconfirm = @"";
                [self setTip:self.tip2];
                [self setErrorTip:@"两次输入密码不同，请确认" errorPswd:string];
                
            } else {
                [self setTip:@"请重新设置密码"];
                
                self.passwordconfirm = @"";
                self.passwordNew = @"";
                [self.indecator setPasswordString:self.passwordNew];
                nRetryTimesRemain = LLLockRetryTimes;
            }
            
        }
    } else {
        NSAssert(1, @"设置密码意外");
    }
}

#pragma mark - 显示提示
- (void)setTip:(NSString*)tip
{
    [_tipLable setText:tip];
    [_tipLable setTextColor:kTipColorNormal];
}

// 错误
- (void)setErrorTip:(NSString*)tip errorPswd:(NSString*)string
{
    // 显示错误点点
    [self.lockview showErrorCircles:string];
    
    // 直接_变量的坏处是
    [_tipLable setText:tip];
    [_tipLable setTextColor:kTipColorError];
    
    [self shakeAnimationForView:_tipLable];
}

#pragma mark - 成功后返回
- (void)hide
{
    switch (_nLockViewType) {
            
        case LLLockViewTypeCheck:
        {
        }
            break;
        case LLLockViewTypeCreate:
            ShowMessage(@"设置成功");
            [LLLockPassword saveLockPassword:self.passwordconfirm];
            break;
        case LLLockViewTypeModify:
        {
            ShowMessage(@"修改成功");
            [LLLockPassword saveLockPassword:self.passwordconfirm];
        }
            break;
        case LLLockViewTypeClean:
            [LLLockPassword removeLockPassWord];
            ShowMessage(@"清除成功");
            break;
        default:
            break;
    }
    
    // 在这里可能需要回调上个页面做一些刷新什么的动作
    if ([self.leftType isEqualToString:@"login"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if ([self.leftType isEqualToString:@"return"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - delegate 每次划完手势后
- (void)lockString:(NSString *)string
{
    if (string.length <4) {
        [self setErrorTip:@"至少连接4个点，请重试" errorPswd:string];

    }else{
        switch (_nLockViewType) {
                
            case LLLockViewTypeCheck:
            {
                self.tip1 = @"请输入解锁密码";
                [self checkPassword:string];
            }
                break;
            case LLLockViewTypeCreate:
            {
                self.tip1 = @"创建解锁密码";
                self.tip2 = @"请重复上一次输入";
                [self createPassword:string];
            }
                break;
            case LLLockViewTypeModify:
            {
                if ([self.passwordOld isEqualToString:@""]) {
                    self.tip1 = @"请输入原来的密码";
                    [self checkPassword:string];
                } else {
                    self.tip1 = @"请输入新的密码";
                    self.tip2 = @"请再次输入密码";
                    [self createPassword:string];
                }
            }
                break;
            case LLLockViewTypeClean:
            default:
            {
                self.tip1 = @"请输入密码以清除密码";
                self.tip2 = @"清除密码成功";
                [self checkPassword:string];
            }
        }
    }
    [self.indecator setPasswordString:self.passwordNew];
}

#pragma mark  跳过


- (void)backTofrontVC:(UIBarButtonItem *)item{
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)skipTouch:(UIBarButtonItem *)item{
    
    if ([self.leftType isEqualToString:@"login"]) {
        [LLLockPassword removeLockPassWord];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if ([self.leftType isEqualToString:@"return"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        

    }

}


// 忘记手势密码

- (IBAction)forgetBtnAction:(UIButton *)sender {
    if (self.nLockViewType == LLLockViewTypeCreate || self.nLockViewType == LLLockViewTypeModify) {
        sender.alpha = 0;
        [self setTip:@"请输入手势密码"];
        self.passwordconfirm = @"";
        self.passwordNew = @"";
        [self.indecator setPasswordString:self.passwordNew];
        nRetryTimesRemain = LLLockRetryTimes;
    }else{
        DMCheckPsdViewController *checkPSDVC = [[DMCheckPsdViewController alloc] init];
        checkPSDVC.title = @"修改手势密码";
        [self.navigationController pushViewController:checkPSDVC animated:YES];
    }
}


#pragma mark 抖动动画
- (void)shakeAnimationForView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}

- (NSString *)getUserName{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    if (userName) {
        if (userName.length > 10) {
            NSRange range = NSMakeRange(3, 4);
            NSString *str = [userName stringByReplacingCharactersInRange:range withString:@"****"];
            return [@"欢迎您，" stringByAppendingString:str];
        }else{
            return [@"欢迎您，" stringByAppendingString:userName];;
        }
    }else{
        return @"欢迎您";
    }
}



#pragma  ----- create views ------

- (LLLockIndicator *)indecator{
    if (!_indecator) {
        CGFloat wide = DMDeviceWidth * 60.0/375.0;
        self.indecator = [[LLLockIndicator alloc] initWithFrame:CGRectMake((DMDeviceWidth-wide)/2, 25, wide, wide)];
    }
    return _indecator;
}

- (UILabel *)userLabel{
    if (!_userLabel) {
        self.userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.indecator.frame), DMDeviceWidth, 25)];
        _userLabel.textColor = UIColorFromRGB(0x37C89B);
        _userLabel.font = FONT_Regular(19);
        _userLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _userLabel;
}

- (UILabel *)tipLable{
    if (!_tipLable) {
        self.tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.indecator.frame)+40, DMDeviceWidth, 28)];
        _tipLable.text = @"请输入解锁密码";
        _tipLable.textColor = MainRed;
        _tipLable.font = FONT_Regular(14);
        _tipLable.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLable;
}

- (LLLockView *)lockview{
    if (!_lockview) {
        CGFloat wide = DMDeviceWidth * 320.0/375.0;
        self.lockview = [[LLLockView alloc] initWithFrame:CGRectMake((DMDeviceWidth-wide)/2, CGRectGetMaxY(self.tipLable.frame), wide, wide)];
    }
    return _lockview;
}

- (UIButton *)forgetButton{
    if (!_forgetButton) {
        self.forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = FONT_Regular(14);
        _forgetButton.frame = CGRectMake(0, DMDeviceHeight-50-64, DMDeviceWidth, 50);
        [_forgetButton addTarget:self action:@selector(forgetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

@end
