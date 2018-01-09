//
//  DMAddBandCardViewController.h
//  豆蔓理财
//
//  Created by edz on 2016/11/16.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMBaseViewController.h"

@interface DMAddBandCardViewController : DMBaseViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, copy)NSString *realName;
@property (nonatomic, copy)NSString *IdcardNum;




@property (nonatomic, strong)NSMutableDictionary *dic;


@end
