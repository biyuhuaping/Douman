//
//  YHSegmentCell.m
//  MinePage
//
//  Created by yanghengzhan on 2016/10/9.
//  Copyright © 2016年 yanghengzhan. All rights reserved.
//

#import "YHSegmentCell.h"


@implementation YHSegmentCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {

        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.f];
        [self.contentView addSubview:_textLabel];

    }

    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if(isSelected){
     _textLabel.textColor = UIColorFromRGB(0x435b83);
    }else{
      _textLabel.textColor = UIColorFromRGB(0x595757);
    }
    
}

@end
