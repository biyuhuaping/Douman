//
//  LJQBaseTableViewVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQBaseTableViewVC.h"
#import <UMMobClick/MobClick.h>
@interface LJQBaseTableViewVC ()

@property (nonatomic,strong) UIButton *back;

@end

@implementation LJQBaseTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:UIColorFromRGB(0x4b5159)}];
    _back = [UIButton buttonWithType:UIButtonTypeCustom];
    _back.frame = CGRectMake(0, 0, 22/2, 40/2);
    [_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [_back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected ];
    [_back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _back.titleLabel.font = [UIFont systemFontOfSize:14];
    [_back addTarget: self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_back];
    
    if (self.title.length > 0) {
        [MobClick beginLogPageView:self.title];
    }else {
        [MobClick beginLogPageView:self.navigationItem.title];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.title.length > 0) {
        [MobClick beginLogPageView:self.title];
    }else {
        [MobClick beginLogPageView:self.navigationItem.title];
    }
    
}


- (void)backClick:(id)sender

{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [formatter stringFromNumber:money];
}


- (NSString *)returnDecimalString:(NSString *)string {
    
    NSString *Decimal;
    
    if ([string containsString:@"."]) {
        Decimal = string;
    }else {
        Decimal = [string stringByAppendingString:@".00"];
    }
    
    return Decimal;
}


#pragma mark - Table view data source
/*
 *#warning Incomplete implementation, return the number of sections
 *#warning Incomplete implementation, return the number of rows
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
