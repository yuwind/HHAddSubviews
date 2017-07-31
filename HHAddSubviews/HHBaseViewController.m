//
//  HHBaseViewController.m
//  BaseTabBar
//
//  Created by 豫风 on 2017/6/23.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "HHBaseViewController.h"


@implementation HHBaseViewController


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSLog(@"销毁了对象:%@,retaintCount%@",self,[self valueForKeyPath:@"retainCount"]);
    if (!self.navigationController.topViewController) {//过滤非销毁的视图，如push进来的上层界面
        if (((NSString *)[self valueForKeyPath:@"retainCount"]).integerValue>5) {
            
            [self enumAllSubViewsTree:self.view];
        }
    }
}
- (void)enumAllSubViewsTree:(UIView *)containerView
{
    if (containerView.actionDict) {
        
        containerView.actionDict = nil;
    }
    for (UIView *subV in containerView.subviews) {
        [self enumAllSubViewsTree:subV];
    }
}



@end
