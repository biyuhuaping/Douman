//
//  LJQMessageBottomView.h
//  豆蔓分解页面
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedEvent)(NSInteger index,BOOL selected);
@interface LJQMessageBottomView : UIView

@property (nonatomic, copy)selectedEvent block;

@end
