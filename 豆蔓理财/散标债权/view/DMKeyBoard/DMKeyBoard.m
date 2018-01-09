//
//  DMKeyBoard.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/9/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMKeyBoard.h"
#import "DMKeyBoardCell.h"


@interface DMKeyBoard ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DMKeyBoard

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[DMKeyBoardCell class] forCellWithReuseIdentifier:@"DMKeyBoardCell"];
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DMKeyBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DMKeyBoardCell" forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.LongPressBlock = ^{
        weakSelf.textField.text = @"";
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.bounds.size.width/3, self.bounds.size.height/4);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DMKeyBoardCell *cell = (DMKeyBoardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColorFromRGB(0xcacaca);
    [UIView animateWithDuration:0.06 animations:^{
        cell.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    }];
    
    if (self.textField.tag == 101 && [self.textField.text containsString:@"%"]) {
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length-1];
    }
    
    
    if (indexPath.row == self.dataArray.count - 1) {
        //删除
        if (self.textField.text.length > 0) {
            self.textField.text = [self.textField.text substringWithRange:NSMakeRange(0, self.textField.text.length - 1)];
        }else{
            self.textField.text = @"";
        }
    }else{
        if (indexPath.row == self.dataArray.count - 2) {
            if (![self.textField.text containsString:@"."]) {
                self.textField.text = [self.textField.text stringByAppendingString:@"."];
            }
        }else{
            self.textField.text = [self.textField.text stringByAppendingString:self.dataArray[indexPath.row]];
        }
    }
    
    if (self.textfieldchange) {
        self.textfieldchange();
    }
    
    
    
    if (self.textField.tag == 101 && self.textField.text.length > 0) {
        self.textField.text = [self.textField.text stringByAppendingString:@"%"];
    }
    
}



- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    DMKeyBoardCell *cell = (DMKeyBoardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColorFromRGB(0xcacaca);
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    DMKeyBoardCell *cell = (DMKeyBoardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.06 animations:^{
        cell.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    }];
}


- (NSArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"•",@"delete"];
    }
    return _dataArray;
}

- (void)drawRect:(CGRect)rect{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    for (int i = 1; i < 4; i++) {
        [path moveToPoint:CGPointMake(0, i * self.bounds.size.height/4)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, i * self.bounds.size.height/4)];
    }
    for (int i = 1; i < 3; i ++) {
        [path moveToPoint:CGPointMake(i*self.bounds.size.width/3, 0)];
        [path addLineToPoint:CGPointMake(i*self.bounds.size.width/3, self.bounds.size.height)];
    }
    
    [path moveToPoint:CGPointMake(0,-self.bounds.size.height/4)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, -self.bounds.size.height/4)];

    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = UIColorFromRGB(0xcacaca).CGColor;
    layer.lineWidth = 0.5;
    [self.layer addSublayer:layer];
}

@end
