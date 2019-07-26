//
//  ViewController.m
//  BlockAddSubViewDemo
//
//  Created by 豫风 on 2017/7/22.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "ViewController.h"
#import "UIView+HHAddSubviews.h"
#import "UIView+HHLayout.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor lightGrayColor];
    view.heightTop_(CGRectMake(0, 120, 0, 100));
    
    for (int i = 0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
        [view addSubview:button];
    }
    [view hh_arrangeSubviews:view.subviews inset:UIEdgeInsetsMake(10, 10, 10, 10) space:20 style:HHArrangeHorizonal];
    //    [view hh_arrangeSubviews:HHArrangeVertical];
    
    UIView *view2 = [UIView new];
    [self.view addSubview:view2];
    view2.backgroundColor = [UIColor lightGrayColor];
    view2.top_.left_.righ_.equalTo(view.bott_).offset_(50).on_();

    
    for (int i = 0; i<9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
        [view2 addSubview:button];
    }
    [view2 hh_arrangeSubViews:view2.subviews totalWidth:[UIScreen mainScreen].bounds.size.width itemHeight:30 inset:UIEdgeInsetsMake(10, 10, 10, 10) lineCount:3 lineSpace:10 margin:10];
}


@end
