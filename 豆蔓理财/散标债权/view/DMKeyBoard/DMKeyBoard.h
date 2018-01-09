//
//  DMKeyBoard.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/9/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMKeyBoard : UIView

@property (nonatomic, strong) UITextField *textField;


@property (nonatomic, copy) void(^textfieldchange)();



@end
