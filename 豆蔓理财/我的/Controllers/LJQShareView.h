//
//  LJQShareView.h
//  豆蔓理财
//
//  Created by mac on 2017/1/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^closeViewBlock)();
typedef void(^shareGoodFriend)(NSInteger index);
@interface LJQShareView : UIView

@property (nonatomic, copy)closeViewBlock closeView;
@property (nonatomic, copy)shareGoodFriend shareGood;

@end
