//
//  RiskMeasurementVC.m
//  豆蔓理财
//
//  Created by mac on 2017/3/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "RiskMeasurementVC.h"

@interface RiskMeasurementVC ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation RiskMeasurementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64)];
    self.webView.backgroundColor = UIColorFromRGB(0xffffff);
    self.webView.delegate=self;
    
    if (self.parameter) {
        [self.webView loadHTMLString:self.parameter baseURL:nil];
    }else {
        NSString *string = [NSString stringWithFormat:@"%@mzc/newAccount/home/riskEstimate?fromapp=1&token=%@",weburl,AccessToken];
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    [self.webView setScalesPageToFit:YES];
    [self.view addSubview: self.webView];
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //加载完成
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    
    __weak __typeof(self) weakSelf = self;
    /**
     *  点击JS充值完成，回到账户中心
     */
    self.jsContext[@"callNativeHome"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            //weakSelf.tabBarController.selectedIndex = 2;
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    };
}

@end
