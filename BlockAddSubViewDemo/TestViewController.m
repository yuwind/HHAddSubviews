//
//  TestViewController.m
//  BlockAddSubViewDemo
//
//  Created by 豫风 on 2017/7/22.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "TestViewController.h"
#import "UIView+HHAddSubviews.h"

@interface TestViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view hh_addLabel:^(UILabel *label) {
        self.label = label;
        label.text = @"路漫漫其修远兮，吾将上下而求索。";
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
    } constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view hh_addButton:^(UIButton *button) {
        self.button = button;
        [button setImage:[UIImage imageNamed:@"action_picture"] forState:UIControlStateNormal];
    } action:^(UIButton *sender) {
        self.label.hidden = !self.label.hidden;
    } constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label).offset(50);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view hh_addTextField:^(UITextField *textField) {
        self.textField = textField;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"请输入文字，不超过十个字";
        [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        textField.maxCharacters = 10;//最大字数限制
    } action:^(UITextField *textField, BOOL isOverMax) {
        [self isShowOverMaxLabel:isOverMax];
    } constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
    }];
}

- (void)isShowOverMaxLabel:(BOOL)isShow
{
    self.label.text = (isShow?@"你超过了最大字数限制":@"路漫漫其修远兮，吾将上下而求索。");
}

- (void)dealloc
{
    NSLog(@"销毁了对象:%@",self);
}

@end
