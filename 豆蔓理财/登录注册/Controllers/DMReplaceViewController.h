//
//  DMReplaceViewController.h
//  豆蔓理财
//
//  Created by edz on 2016/11/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMBaseViewController.h"

@interface DMReplaceViewController : DMBaseViewController

@property (nonatomic ,strong)NSString *PhoneNum;

@property (nonatomic, strong)NSString *captcha;

@property (nonatomic, assign)BOOL mine;

@end
