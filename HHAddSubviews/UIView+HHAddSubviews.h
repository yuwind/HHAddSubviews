//
//  UIView+HHAddSubviews.h
//  HHBaseTableViewControllerDemo
//
//  Created by 豫风 on 2017/7/20.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface UITextField (HHMaxCharacters)
@property (nonatomic, assign) NSInteger maxCharacters;//允许text的最大长度
@end

@interface UITextView (HHMaxCharacters)
@property (nonatomic, assign) NSInteger maxCharacters;//允许text的最大长度
@end

@interface UIView (HHAddSubviews)

@property (nonatomic, strong) NSMutableDictionary *actionDict;


/**
 添加UIView视图及约束
 
 @param view 设置view属性
 &param block 设置view约束
 @return 返回view对象
 */
- (UIView *)hh_addView:(void(^)(UIView *view))view;
- (UIView *)hh_addView:(void(^)(UIView *view))view constraints:(void(^)(MASConstraintMaker *maker))block;

/**
 添加UILabel视图及约束
 
 @param label 设置label属性
 &param block 设置label约束
 @return 返回label对象
 */
- (UILabel *)hh_addLabel:(void(^)(UILabel *label))label;
- (UILabel *)hh_addLabel:(void(^)(UILabel *label))label constraints:(void(^)(MASConstraintMaker *make))block;

/**
 添加UIImageView视图及约束
 
 @param imageView 设置imageView属性
 &param block 设置imageView约束
 @return 返回imageView对象
 */
- (UIImageView *)hh_addImageView:(void(^)(UIImageView *imageView))imageView;
- (UIImageView *)hh_addImageView:(void(^)(UIImageView *imageView))imageView constraints:(void(^)(MASConstraintMaker *make))block;

/**
 添加UIButton视图、点击事件及约束
 
 @param button 设置button属性
 &param action 设置button点击事件
 &param block  设置button约束
 @return 返回button对象
 */
- (UIButton *)hh_addButton:(void(^)(UIButton *button))button;
- (UIButton *)hh_addButton:(void(^)(UIButton *button))button constraints:(void(^)(MASConstraintMaker *make))block;

- (UIButton *)hh_addButton:(void(^)(UIButton *button))button action:(void (^)(UIButton *sender))action;
- (UIButton *)hh_addButton:(void(^)(UIButton *button))button action:(void (^)(UIButton *sender))action constraints:(void(^)(MASConstraintMaker *make))block;

- (UIButton *)hh_addButton:(void(^)(UIButton *button))button events:(UIControlEvents)controlEvents action:(void (^)(UIButton *sender))action;
- (UIButton *)hh_addButton:(void(^)(UIButton *button))button events:(UIControlEvents)controlEvents action:(void (^)(UIButton *sender))action constraints:(void(^)(MASConstraintMaker *make))block;

/**
 添加UISwitch视图、点击事件及约束
 
 @param Switch 设置Switch属性
 &param action 设置Switch点击事件
 &param block  设置Switch约束
 @return 返回Switch对象
 */
- (UISwitch *)hh_addSwitch:(void(^)(UISwitch *Switch))Switch;
- (UISwitch *)hh_addSwitch:(void(^)(UISwitch *Switch))Switch constraints:(void(^)(MASConstraintMaker *make))block;
- (UISwitch *)hh_addSwitch:(void(^)(UISwitch *Switch))Switch action:(void (^)(UISwitch *Switch))action constraints:(void(^)(MASConstraintMaker *make))block;

/**
 添加UITextField视图、字数改变事件及约束
 
 @param textField 设置textField属性
 &param action    设置textField点击事件
 &param block     设置textField约束
 @return 返回textField对象
 */
- (UITextField *)hh_addTextField:(void(^)(UITextField *textField))textField;
- (UITextField *)hh_addTextField:(void(^)(UITextField *textField))textField action:(void (^)(UITextField *textField, BOOL isOverMax))action;
- (UITextField *)hh_addTextField:(void(^)(UITextField *textField))textField action:(void (^)(UITextField *textField, BOOL isOverMax))action constraints:(void(^)(MASConstraintMaker *make))block;

/**
 添加UITextView视图、字数改变事件及约束
 
 @param textView 设置textView属性
 &param action   设置textView点击事件
 &param block    设置textView约束
 @return 返回textView对象
 */
- (UITextView *)hh_addTextView:(void(^)(UITextView *textView))textView;
- (UITextView *)hh_addTextView:(void(^)(UITextView *textView))textView action:(void(^)(UITextView *textView, BOOL isOverMax))action;
- (UITextView *)hh_addTextView:(void(^)(UITextView *textView))textView action:(void(^)(UITextView *textView, BOOL isOverMax))action constraints:(void(^)(MASConstraintMaker *make))block;

/**
 适用于继承自UIContol的对象
 
 @param controlEvents UIControlEvents
 @param block 回调事件
 */
- (void)addBlockEvents:(UIControlEvents)controlEvents action:(void (^)(id sender))block;



@end
