//
//  DMPastServiceHeadView.h
//  豆蔓理财
//
//  Created by edz on 2017/7/20.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedBtnEvent)(NSInteger index);

@class DMRobtEndDetailModel;
@interface DMPastServiceHeadView : UIView

@property (nonatomic, copy)selectedBtnEvent touchBtnEvent;

@property (nonatomic, strong)DMRobtEndDetailModel *model;
@end
