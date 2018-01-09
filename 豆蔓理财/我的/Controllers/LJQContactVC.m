//
//  LJQContactVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQContactVC.h"

@interface LJQContactVC ()

@end

@implementation LJQContactVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"联系客服";
    
    UIImage *image = [UIImage imageNamed:@"contactCustomer"];
    
    UIImageView *pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH * image.size.height / image.size.width)];
    pitcureView.image = image;
    [self.view addSubview:pitcureView];
    // Do any additional setup after loading the view.
    
//    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(snapShot:)];
//    press.minimumPressDuration = 2;
//    pitcureView.userInteractionEnabled = YES;
//    [pitcureView addGestureRecognizer:press];
}

- (void)snapShot:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
     
        UIView *snapShotView = [self.view snapshotViewAfterScreenUpdates:NO];
        snapShotView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [self.view addSubview:snapShotView];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
