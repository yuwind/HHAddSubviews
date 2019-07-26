//
//  UIView+HHAddSubviews.m
//  HHBaseTableViewControllerDemo
//
//  Created by 豫风 on 2017/7/20.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "UIView+HHAddSubviews.h"
#import <objc/runtime.h>
#import "UIView+HHLayout.h"


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

@dynamic ownerController;

- (UIViewController *)ownerController
{
    if ([[self nextResponder] isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)[self nextResponder];
    }
    if (![self superview]) return nil;
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark -- 快速添加视图

- (UIView *)hh_addView:(void(^)(UIView *))view
{
    UIView *view_ = [UIView new];
    [self addSubview:view_];
    if(view)view(view_);
    return view_;
}
- (UILabel *)hh_addLabel:(void (^)(UILabel *))label
{
    UILabel *label_ = [UILabel new];
    [self addSubview:label_];
    if(label)label(label_);
    return label_;
}

- (UIImageView *)hh_addImageView:(void(^)(UIImageView *))imageView
{
    UIImageView *imageView_ = [UIImageView new];
    [self addSubview:imageView_];
    if(imageView)imageView(imageView_);
    return imageView_;
}

- (UIButton *)hh_addButton:(void (^)(UIButton *))button
{
    return [self hh_addButton:button action:nil];
}
- (UIButton *)hh_addButton:(void(^)(UIButton *))button action:(void (^)(UIButton *))action
{
    return [self hh_addButton:button events:UIControlEventTouchUpInside action:action];
}
- (UIButton *)hh_addButton:(void (^)(UIButton *))button events:(UIControlEvents)controlEvents action:(void (^)(UIButton *))action
{
    UIButton *button_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button_];
    if(button)button(button_);
    if (action) {
        if (!self.actionDict) {
            self.actionDict = [NSMutableDictionary dictionary];
        }
        [self.actionDict setValue:action forKey:KViewAddress(button_)];
        [button_ addTarget:self action:@selector(hh_buttonClicked:) forControlEvents:controlEvents];
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
    return [self hh_addSwitch:Switch action:nil];
}
- (UISwitch *)hh_addSwitch:(void(^)(UISwitch *))Switch action:(void (^)(UISwitch *))action
{
    UISwitch *switch_ = [UISwitch new];
    [self addSubview:switch_];
    if(Switch)Switch(switch_);
    if (action) {
        if (!self.actionDict) {
            self.actionDict = [NSMutableDictionary dictionary];
        }
        [self.actionDict setValue:action forKey:KViewAddress(switch_)];
        [switch_ addTarget:self action:@selector(hh_switchClickedAction:) forControlEvents:UIControlEventValueChanged];
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
    UITextField *textField_ = [UITextField new];
    [self addSubview:textField_];
    if(textField)textField(textField_);
    if (action) {
        
        if (!self.actionDict) {
            self.actionDict = [NSMutableDictionary dictionary];
        }
        [self.actionDict setValue:action forKey:KViewAddress(textField_)];
        [textField_ addTarget:self action:@selector(hh_textFieldChangedAction:) forControlEvents:UIControlEventEditingChanged];
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
    UITextView *textView_ = [UITextView new];
    [self addSubview:textView_];
    if (action) {
        
        if (!self.actionDict) {
            self.actionDict = [NSMutableDictionary dictionary];
        }
        [self.actionDict setValue:action forKey:KViewAddress(textView_)];
        textView_.delegate = self;
    }
    if(textView)textView(textView_);
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
- (void)hh_addGestureType:(HHGestureType)type gesture:(void (^)(UIGestureRecognizer *))gesture action:(void (^)(UIGestureRecognizer *gesture))block
{
    UIGestureRecognizer *gestureRec = nil;
    switch (type) {
        case HHGestureTypeTap:
            gestureRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        case HHGestureTypePan:
            gestureRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        case HHGestureTypeSwipe:
            gestureRec = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        case HHGestureTypePinch:
            gestureRec = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        case HHGestureTypeRotation:
            gestureRec = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        case HHGestureTypeLongPress:
            gestureRec = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        default:
            break;
    }
    [self addGestureRecognizer:gestureRec];
    if (gesture) {
        gesture(gestureRec);
    }
    if (!self.actionDict) {
        self.actionDict = [NSMutableDictionary dictionary];
    }
    [self.actionDict setValue:block forKey:KViewAddress(gestureRec)];
}
- (void)hh_gestureRecognizerDidChanged:(UIGestureRecognizer *)gesture
{
    void (^block)(UIGestureRecognizer *) = [self.actionDict objectForKey:KViewAddress(gesture)];
    if (block) {
        block(gesture);
    }
}

- (void)hh_addBlockEvents:(UIControlEvents)controlEvents action:(void (^)(id sender))block
{
    if (![self isKindOfClass:[UIControl class]]) return;
    if (block) {
        if (!self.actionDict) {
            self.actionDict = [NSMutableDictionary dictionary];
        }
        [self.actionDict setValue:block forKey:KViewAddress(self)];
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

- (void)hh_arrangeSubviews:(HHArrangeStyle)style
{
    [self hh_arrangeSubviews:self.subviews inset:UIEdgeInsetsZero space:0 style:style];
}

- (void)hh_arrangeSubviews:(NSArray *)subViews inset:(UIEdgeInsets)inset space:(CGFloat)space style:(HHArrangeStyle)style
{
    UIView *preView = nil;
    if (style == HHArrangeHorizonal) {
        for (int i = 0; i<self.subviews.count; i++) {
            UIView *subView = self.subviews[i];
            if (i == 0) { subView.left_.top_.bott_.constList(@(inset.left),@(inset.top),@(-inset.bottom),nil).on_();
            }
            if (i == (self.subviews.count-1)){
                if (preView) { subView.left_.top_.bott_.widt_.equalTo(preView.righ_).offset_(space).on_();
                    subView.righ_.constant(-inset.right).on_();
                    self.subviews[0].widt_.equalTo(subView).on_();
                }else{
                    subView.righ_.constant(-inset.right).on_();
                }
            }else if (preView) {
                subView.left_.top_.bott_.widt_.equalTo(preView.righ_).offset_(space).on_();
            }
            preView = subView;
        }
    }else if (style == HHArrangeVertical){
        for (int i = 0; i<self.subviews.count; i++) {
            UIView *subView = self.subviews[i];
            if (i == 0) { subView.left_.top_.righ_.constList(@(inset.left),@(inset.top),@(-inset.right),nil).on_();
            }
            if (i == (self.subviews.count-1)){
                if (preView) {
                    subView.top_.left_.righ_.heit_.equalTo(preView.bott_).offset_(space).on_();
                    subView.bott_.constant(-inset.bottom).on_();
                    self.subviews[0].heit_.equalTo(subView).on_();
                }else{
                    subView.bott_.constant(-inset.right).on_();
                }
            }else if (preView) { subView.top_.left_.righ_.heit_.equalTo(preView.bott_).offset_(space).on_();
            }
            preView = subView;
        }
    }
}

- (void)hh_arrangeSubViews:(NSArray *)array totalWidth:(CGFloat)totalWidth itemHeight:(CGFloat)itemHeight inset:(UIEdgeInsets)inset lineCount:(int)lineCount lineSpace:(CGFloat)lineSpace margin:(CGFloat)margin
{
    CGFloat itemWidth = (totalWidth-inset.left-inset.right-(lineCount-1)*lineSpace)/lineCount;
    for (int i = 0; i<array.count; i++) {
        int row = i/lineCount;
        int column = i%lineCount;
        CGFloat xPosition = inset.left+column*(itemWidth+lineSpace);
        CGFloat yPosition = inset.top+row*(itemHeight+margin);
        UIView *view = array[i];
        view.topLeft_(CGRectMake(xPosition, yPosition, itemWidth, itemHeight));
        if (i==array.count-1) {
            view.bott_.constant(-inset.bottom).on_();
        }
    }
}

@end
