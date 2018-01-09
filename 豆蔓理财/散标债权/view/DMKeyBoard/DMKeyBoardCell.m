//
//  DMKeyBoardCell.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/9/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMKeyBoardCell.h"

@interface DMKeyBoardCell ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIImageView *deleteImage;

@end


@implementation DMKeyBoardCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.deleteImage];
    }
    return self;
}


- (UILabel *)numberLabel{
    if (!_numberLabel) {
        self.numberLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _numberLabel.font = FONT_Regular(16);
        _numberLabel.textColor = UIColorFromRGB(0x878787);
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (UIImageView *)deleteImage{
    if (!_deleteImage) {
        self.deleteImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _deleteImage.image = [UIImage imageNamed:@"key_delete"];
        _deleteImage.contentMode = UIViewContentModeCenter;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        _deleteImage.userInteractionEnabled = YES;
        longPress.minimumPressDuration = 0.6;
        [_deleteImage addGestureRecognizer:longPress];
    }
    return _deleteImage;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.numberLabel.text = title;
    
    if ([title isEqualToString:@"delete"]) {
        self.deleteImage.hidden = NO;
        self.numberLabel.hidden = YES;
    }else{
        self.deleteImage.hidden = YES;
        self.numberLabel.hidden = NO;
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    if (self.LongPressBlock) {
        self.LongPressBlock();
    }
}


@end
