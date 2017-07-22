# HHAddSubviews
以聚合的形式增加视图，事件，约束。

**label：方法**

```objc
    [self.view hh_addLabel:^(UILabel *label) {
        self.label = label;
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
    } constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
    }];
```
**button：方法**

```objc
    [self.view hh_addButton:^(UIButton *button) {
        self.button = button;
        [button setImage:[UIImage imageNamed:@"action_picture"] forState:UIControlStateNormal];
    } action:^(UIButton *sender) {//button点击事件
        NSLog(@"点击了按钮");
    } constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label).offset(50);
        make.centerX.equalTo(self.view);
    }];
```
**textField：方法**

```objc

    [self.view hh_addTextField:^(UITextField *textField) {
        self.textField = textField;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"请输入文字，不超过十个字";
        [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        textField.maxCharacters = 10;//设置最大字数
    } action:^(UITextField *textField, BOOL isOverMax) {//字数改变回调
        NSLog(@"isOverMax==YES,超过了字数限制");
    } constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).offset(50);
        make.centerX.equalTo(self.view);
    }];

```

**说明**
>1、为何第一个属性设置block不需要弱引用，此和`masonry`等同，并没有对象引用block，属性设置之后就会被释放。
>2、`action`事件以对象的内存地址为`key`存储在`actionDict`中，`action`block中需要使用弱引用。当然也可以不用，只需要打破环路即可，把视图的`actionDict`置为`nil`即可。在基类调用如下函数：

```objc
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!self.navigationController.topViewController)///过滤非销毁的视图，如push进来的上层界面
    [self enumSubViewsTree:self.view];
}
- (void)enumSubViewsTree:(UIView *)view
{//递归遍历子控件，把存有block的actionDict置为nil
    if (view.actionDict) view.actionDict = nil;
    for (UIView *subV in view.subviews)[self enumSubViewsTree:subV];
}
```
>3、此分类包含了常用的控件，需要依赖第三方框架[masonry](https://github.com/SnapKit/Masonry)

