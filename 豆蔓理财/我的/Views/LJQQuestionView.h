//
//  LJQQuestionView.h
//  豆蔓理财
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJQQuestionView : UIView

- (void)show;

@end

typedef void(^closeViewBlock)();
@interface ItemView : UIView

@property (nonatomic, copy)closeViewBlock closeView;

@end
