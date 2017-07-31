//
//  UIView+HHAddSubviews.m
//  HHBaseTableViewControllerDemo
//
//  Created by 豫风 on 2017/7/20.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "UIView+HHAddSubviews.h"
#import <objc/runtime.h>


#ifndef KViewAddress
#define KViewAddress(view) [NSString stringWithFormat:@"%p",view]
#endif


static char * const buttonDictionaryKey     = "buttonDictionaryKey";
static char * const textFieldMaxCharKey     = "textFieldMaxCharKey";
static char * const textViewMaxCharKey      = "textViewMaxCharKey";

@implementation UITextField (HHMaxCharacters)

- (void)setMaxCharacters:(NSInteger)maxCharacters
{
    objc_setAssociatedObject(self, textFieldMaxCharKey, @(maxCharacters), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)maxCharacters
{
    return ((NSNumber *)objc_getAssociatedObject(self, textFieldMaxCharKey)).integerValue;
}

@end

@implementation UITextView (HHMaxCharacters)

- (void)setMaxCharacters:(NSInteger)maxCharacters
{
    objc_setAssociatedObject(self, textViewMaxCharKey, @(maxCharacters), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)maxCharacters
{
    return ((NSNumber *)objc_getAssociatedObject(self, textViewMaxCharKey)).integerValue;
}

@end

@interface UIView () < UITextViewDelegate >


@end

@implementation UIView (HHAddSubviews)

#pragma mark -- 快速添加视图

- (UIView *)hh_addView:(void(^)(UIView *))view
{
    return [self hh_addView:view constraints:nil];
}
- (UIView *)hh_addView:(void(^)(UIView *))view constraints:(void(^)(MASConstraintMaker *make))block
{
    UIView *view_ = [UIView new];
    [self addSubview:view_];
    if(view)view(view_);
    if (block)[view_ mas_makeConstraints:block];
    return view_;
}
- (UILabel *)hh_addLabel:(void (^)(UILabel *))label
{
    return [self hh_addLabel:label constraints:nil];
}
- (UILabel *)hh_addLabel:(void (^)(UILabel *))label constraints:(void (^)(MASConstraintMaker *))block
{
    UILabel *label_ = [UILabel new];
    [self addSubview:label_];
    if(label)label(label_);
    if (block)[label_ mas_makeConstraints:block];
    return label_;
}

- (UIImageView *)hh_addImageView:(void(^)(UIImageView *))imageView
{
    return [self hh_addImageView:imageView constraints:nil];
}
- (UIImageView *)hh_addImageView:(void(^)(UIImageView *))imageView constraints:(void(^)(MASConstraintMaker *))block
{
    UIImageView *imageView_ = [UIImageView new];
    [self addSubview:imageView_];
    if(imageView)imageView(imageView_);
    if(block)[imageView_ mas_makeConstraints:block];
    return imageView_;
}

- (UIButton *)hh_addButton:(void (^)(UIButton *))button
{
    return [self hh_addButton:button action:nil];
}
- (UIButton *)hh_addButton:(void (^)(UIButton *))button constraints:(void (^)(MASConstraintMaker *))block
{
    return [self hh_addButton:button action:nil constraints:block];
}
- (UIButton *)hh_addButton:(void(^)(UIButton *))button action:(void (^)(UIButton *))action
{
    return [self hh_addButton:button events:UIControlEventTouchUpInside action:action];
}
- (UIButton *)hh_addButton:(void(^)(UIButton *))button action:(void (^)(UIButton *))action constraints:(void(^)(MASConstraintMaker *))block
{
    return [self hh_addButton:button events:UIControlEventTouchUpInside action:action constraints:block];
}
- (UIButton *)hh_addButton:(void (^)(UIButton *))button events:(UIControlEvents)controlEvents action:(void (^)(UIButton *))action
{
    return [self hh_addButton:button events:controlEvents action:action constraints:nil];
}
- (UIButton *)hh_addButton:(void(^)(UIButton *))button events:(UIControlEvents)controlEvents action:(void (^)(UIButton *))action constraints:(void(^)(MASConstraintMaker *))block
{
    UIButton *button_ = [UIButton new];
    [self addSubview:button_];
    if(button)button(button_);
    if (action) {
        if (!self.actionDict) {
            self.actionDict = [NSMutableDictionary dictionary];
        }
        [self.actionDict setObject:action forKey:KViewAddress(button_)];
        [button_ addTarget:self action:@selector(hh_buttonClicked:) forControlEvents:controlEvents];
    }
    if (block) {
        [button_ mas_makeConstraints:block];
    }
    return button_;
}
- (void)hh_buttonClicked:(UIButton *)sender
{
    void (^block)(UIButton *) = [self.actionDict objectForKey:KViewAddress(sender)];
    if (block) {
        block(sender);
    }
}
- (UISwitch *)hh_addSwitch:(void(^)(UISwitch *))Switch
{
    return [self hh_addSwitch:Switch constraints:nil];
}
- (UISwitch *)hh_addSwitch:(void(^)(UISwitch *))Switch constraints:(void(^)(MASConstraintMaker *))block
{
    return [self hh_addSwitch:Switch action:nil constraints:block];
}
- (UISwitch *)hh_addSwitch:(void(^)(UISwitch *))Switch action:(void (^)(UISwitch *))action constraints:(void(^)(MASConstraintMaker *))block
{
    UISwitch *switch_ = [UISwitch new];
    [self addSubview:switch_];
    if(Switch)Switch(switch_);
    if (action) {
        if (!self.actionDict) {
            self.actionDict = [NSMutableDictionary dictionary];
        }
        [self.actionDict setObject:action forKey:KViewAddress(switch_)];
        [switch_ addTarget:self action:@selector(hh_switchClickedAction:) forControlEvents:UIControlEventValueChanged];
    }
    if (block) {
        [switch_ mas_makeConstraints:block];
    }
    return switch_;
}
- (void)hh_switchClickedAction:(UISwitch *)Switch
{
    void (^block)(UISwitch *) = [self.actionDict objectForKey:KViewAddress(Switch)];
    if (block) {
        block(Switch);
    }
}
- (UITextField *)hh_addTextField:(void (^)(UITextField *))textField
{
    return [self hh_addTextField:textField action:nil];
}
- (UITextField *)hh_addTextField:(void (^)(UITextField *))textField action:(void (^)(UITextField *,BOOL))action
{
    return [self hh_addTextField:textField action:action constraints:nil];
}
- (UITextField *)hh_addTextField:(void (^)(UITextField *))textField action:(void (^)(UITextField *, BOOL))action constraints:(void (^)(MASConstraintMaker *))block
{
    UITextField *textField_ = [UITextField new];
    [self addSubview:textField_];
    if(textField)textField(textField_);
    if (action) {
        
        if (!self.actionDict) {
            self.actionDict = [NSMutableDictionary dictionary];
        }
        [self.actionDict setObject:action forKey:KViewAddress(textField_)];
        [textField_ addTarget:self action:@selector(hh_textFieldChangedAction:) forControlEvents:UIControlEventEditingChanged];
    }
    if (block) {
        [textField_ mas_makeConstraints:block];
    }
    return textField_;
}
- (void)hh_textFieldChangedAction:(UITextField *)textField
{
    UITextRange * selectedRange = [textField markedTextRange];
    UITextPosition * position   = [textField positionFromPosition:selectedRange.start offset:0];
    if(selectedRange && position)return;
    
    void(^block)(UITextField *, BOOL) = [self.actionDict objectForKey:KViewAddress(textField)];
    if (block) {
        
        NSString * nameString       = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        textField.text = nameString;
        
        BOOL isOverMax = NO;
        if (textField.maxCharacters) {
            
            if (nameString.length > textField.maxCharacters)
            {
                NSRange rangeIndex = [nameString rangeOfComposedCharacterSequenceAtIndex:textField.maxCharacters];
                isOverMax = YES;
                if (rangeIndex.length == 1)
                {
                    textField.text = [nameString substringToIndex:textField.maxCharacters];
                }
                else
                {
                    NSRange rangeRange = [nameString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, textField.maxCharacters)];
                    textField.text     = [nameString substringWithRange:rangeRange];
                }
            }
        }
        block(textField,isOverMax);
    }
}

- (UITextView *)hh_addTextView:(void(^)(UITextView *))textView
{
    return [self hh_addTextView:textView action:nil];
}
- (UITextView *)hh_addTextView:(void (^)(UITextView *))textView action:(void (^)(UITextView *, BOOL))action
{
    return [self hh_addTextView:textView action:action constraints:nil];
}
- (UITextView *)hh_addTextView:(void (^)(UITextView *))textView action:(void (^)(UITextView *, BOOL))action constraints:(void (^)(MASConstraintMaker *))block
{
    UITextView *textView_ = [UITextView new];
    [self addSubview:textView_];
    if (action) {
        
        if (!self.actionDict) {
            self.actionDict = [NSMutableDictionary dictionary];
        }
        [self.actionDict setObject:action forKey:KViewAddress(textView_)];
        textView_.delegate = self;
    }
    if(textView)textView(textView_);
    if (block) {
        [textView_ mas_makeConstraints:block];
    }
    return textView_;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    UITextRange *editRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:editRange.start offset:0];
    if (editRange && position) return;
    
    void(^block)(UITextView *,BOOL) = [self.actionDict objectForKey:KViewAddress(textView)];
    
    if (block) {
       
        BOOL isOverMax = NO;
        if (textView.maxCharacters) {
            if (textView.text.length > textView.maxCharacters) {
                
                isOverMax = YES;
                textView.text = [textView.text substringToIndex:textView.maxCharacters];
            }
        }
        block(textView,isOverMax);
    }
}

- (void)addBlockEvents:(UIControlEvents)controlEvents action:(void (^)(id sender))block
{
    if (![self isKindOfClass:[UIControl class]]) return;
    if (block) {
        if (!self.actionDict) {
            self.actionDict = [NSMutableDictionary dictionary];
        }
        [self.actionDict setObject:block forKey:KViewAddress(self)];
        UIControl *control = (UIControl *)self;
        [control addTarget:self action:@selector(hh_controlClickedAction:) forControlEvents:controlEvents];
    }
}
- (void)hh_controlClickedAction:(UIControl *)control
{
    void (^block)(UIControl *) = [self.actionDict objectForKey:KViewAddress(control)];
    if (block) {
        block(control);
    }
}

- (void)setActionDict:(NSMutableDictionary *)actionDict
{
    objc_setAssociatedObject(self, buttonDictionaryKey, actionDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)actionDict
{
    return objc_getAssociatedObject(self, buttonDictionaryKey);
}


@end
