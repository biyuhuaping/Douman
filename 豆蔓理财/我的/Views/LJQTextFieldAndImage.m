//
//  LJQTextFieldAndImage.m
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQTextFieldAndImage.h"

@interface LJQTextFieldAndImage ()

@property (nonatomic, strong)UIImageView *PpitcureView;
@property (nonatomic, strong)UIImage *showImage;
@property (nonatomic) CGFloat Space;
@property (nonatomic, assign)CGFloat ViewHeight;

@end

@implementation LJQTextFieldAndImage

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName space:(CGFloat)spaceX Height:(CGFloat)height string:(NSString *)string {
    self = [super initWithFrame:frame];
    self.showImage = [UIImage imageNamed:imageName];
    self.Space = spaceX;
    self.ViewHeight = height;
    if (self) {
        
         [self addSubview:self.PpitcureView];
        
        self.textField = [[CustomTextField alloc] initWithFrame:CGRectMake(35, 0, SCREENWIDTH - 75, height) PlaceHoldFont:12 PlaceHoldColor:LightGray]; /////////////4b6ca7
        self.textField.textAlignment = NSTextAlignmentLeft;
        self.textField.textColor = DarkGray; ////////////////6d727a
        self.textField.font = [UIFont systemFontOfSize:14.f];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        NSMutableAttributedString *attribure = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:UIColorFromRGB(0xababb1)}];
        self.textField.attributedPlaceholder = attribure;
        
//        self.textField.placeholder = string;
//        [self.textField setValue:UIColorFromRGB(0x4b6ca7) forKeyPath:@"_placeholderLabel.textColor"];
//        [self.textField setValue:[UIFont systemFontOfSize:12.f] forKeyPath :@"_placeholderLabel.font"];
        
        //自定义清除按钮
        UIButton *clearButton = [self.textField valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"remove_icon"] forState:UIControlStateNormal]; //////////////清除icon
        [clearButton setImage:[UIImage imageNamed:@"remove_icon"] forState:UIControlStateHighlighted];
        
        [self.textField addTarget:self action:@selector(compareStr:) forControlEvents:(UIControlEventEditingChanged)];
        
        [self addSubview:self.textField];
        
       
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(35, height - 0.8, SCREENWIDTH - 70, 0.8)];
        line.backgroundColor = UIColorFromRGB(0xececec); /////////////f0f0f0
        [self addSubview:line];
    }
    return self;
}

- (void)setKeyMode:(TextFieldMode)keyMode {
    _keyMode = keyMode;
    if (_keyMode == TextFieldModeNone) {
        
    }else
        if (_keyMode == TextFieldModeLogin) {
            self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }else
            if (_keyMode == TextFieldModeTrade) {
                self.textField.keyboardType = UIKeyboardTypePhonePad;
            }
}

- (UIImageView *)PpitcureView {
    if (!_PpitcureView) {
        self.PpitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(self.Space, (self.ViewHeight - self.showImage.size.height) / 2, self.showImage.size.width, self.showImage.size.height)];
        self.PpitcureView.image = self.showImage;
    }
    return _PpitcureView;
}

- (void)compareStr:(UITextField *)textField {
    self.comStrBK(textField);
}

@end
