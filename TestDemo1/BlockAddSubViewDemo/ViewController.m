//
//  ViewController.m
//  BlockAddSubViewDemo
//
//  Created by 豫风 on 2017/7/22.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view hh_addLabel:^(UILabel *label) {
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"点击推出视图，for test 循环引用";
    } constraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[TestViewController new] animated:YES];
}
@end
