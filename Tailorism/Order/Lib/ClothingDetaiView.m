//
//  ClothingDetaiView.m
//  Tailorism
//
//  Created by LIZhenNing on 16/6/3.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "ClothingDetaiView.h"
#import "AlertTabelView.h"
#import "MemberType.h"
@implementation ClothingDetaiView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}
-(void)Num:(NSInteger)number data:(NSArray*)dataArry controller:(UIViewController*)contoller
{
    
    _superViewController = contoller;
    
    _OrderTitle.text = [NSString stringWithFormat:@"子订单-%ld",(long)number];

    _mianliaoTextField.rightViewMode = UITextFieldViewModeAlways;
    _mianliaoTextField.delegate = self;
    _mianliaoTextField.rightView = [self rightViewButton:620100 textfile:_mianliaoTextField];
    
    _lingxingTextField.rightViewMode = UITextFieldViewModeAlways;
    _lingxingTextField.delegate = self;
    _lingxingTextField.rightView = [self rightViewButton:620101 textfile:_lingxingTextField];
    
    _xiuxingTextField.rightViewMode = UITextFieldViewModeAlways;
    _xiuxingTextField.delegate = self;
    _xiuxingTextField.rightView = [self rightViewButton:620102 textfile:_xiuxingTextField];
    

    _menjinTextField.rightViewMode = UITextFieldViewModeAlways;
    _menjinTextField.delegate = self;
    _menjinTextField.rightView = [self rightViewButton:620103 textfile:_menjinTextField];
    
    
    _heshenduTextField.rightViewMode = UITextFieldViewModeAlways;
    _heshenduTextField.delegate = self;
    _heshenduTextField.rightView = [self rightViewButton:620104 textfile:_heshenduTextField];
    
    _huochapianTextField.rightViewMode = UITextFieldViewModeAlways;
    _huochapianTextField.delegate = self;
    _huochapianTextField.rightView = [self rightViewButton:620105 textfile:_huochapianTextField];
    
    _xiuziFontTextField.rightViewMode = UITextFieldViewModeAlways;
    _xiuziFontTextField.delegate = self;
    _xiuziFontTextField.rightView = [self rightViewButton:620107 textfile:_xiuziFontTextField];
    

    
    _xiabaiTextField.rightViewMode = UITextFieldViewModeAlways;
    _xiabaiTextField.delegate = self;
    _xiabaiTextField.rightView = [self rightViewButton:620113 textfile:_xiabaiTextField];
    

    _xiuziColor.rightViewMode = UITextFieldViewModeAlways;
    _xiuziColor.rightView = [self rightViewButton:620118 textfile:_xiuziColor];
    
    _xiuziweizhi.rightViewMode = UITextFieldViewModeAlways;
    _xiuziweizhi.rightView = [self rightViewButton:620119 textfile:_xiuziweizhi];
    
    if (number==1)
    {
        [_delButton setHidden:YES];
      
    }
    _delButton.tag =number;
    _tagstr = [NSString stringWithFormat:@"%ld",(long)number];
    

}

-(UIButton *)rightViewButton:(NSInteger)btntag textfile:(OrderTextField*)textField
{
    
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.tag=btntag;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"xialasanjiao.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(-10, 0, 64/2.5, 36/2.5);
    
    return rightButton;
}

-(void)rightButton:(UIButton*)sender
{
    AlertTabelView * viewcontroller = [[AlertTabelView alloc]init];
    viewcontroller.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    viewcontroller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [viewcontroller setTagID:sender.tag];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appdelegate getCurrentVC] presentViewController:viewcontroller animated:YES completion:^{
    viewcontroller.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
        
    }];
    
    
    [viewcontroller returnText:^(NSString *showText) {
        
        OrderTextField * odertext = (OrderTextField *)sender.superview;
        odertext.text =showText;
        if ([showText isEqualToString:@"其他颜色（请在备注中输入）"]) {
            _xiuziColorTextField.font = [UIFont systemFontOfSize:12];
        }
        else {
            _xiuziColorTextField.font = [UIFont systemFontOfSize:17];
        }
        
    }];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {


    return NO;
}




- (IBAction)delButton:(UIButton *)sender {
    
    UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除此子订单吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        

        
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self removeFromSuperview];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(delSonOrder:)]) {
        
              [_delegate delSonOrder:sender.tag];
        }
        
      
    }];
    
    [alertCtr addAction:firstAction];
    
    [alertCtr addAction:secondAction];
    
    
    [_superViewController presentViewController:alertCtr animated:YES completion:^{
        
    }];
                                   
}

-(ClothingModel*)DoneData
{
    
//    NSDictionary *dic1;
//    if (_lingkuanbaiButton.selected)
//    {
//        dic1 = @{@"white_collar":@"是"};
//    }else
//    {
//        dic1 = @{@"white_collar":@"否"};
//    }
//    
//    NSDictionary *dic2;
//    if (_xiukuanbaiButton.selected)
//    {
//        dic2 = @{@"white_sleeve":@"是"};
//    }else
//    {
//        dic2 = @{@"white_sleeve":@"否"};
//    }
//    
//    NSDictionary *dic3;
//    if (_xiongdaiButton.selected)
//    {
//        dic3 = @{@"fold_back":@"是"};
//    }else
//    {
//        dic3 = @{@"fold_back":@"否"};
//    }
//    
//    NSDictionary *dic4;
//    if (_xiuziButton.selected)
//    {
//        dic4 = @{@"embroidered":@"是"};
//    }else
//    {
//        dic4 = @{@"embroidered":@"否"};
//    }

    NSDictionary * dic = @{@"code":_mianliaoTextField.text,
                           @"collar_type":[MemberType orderType:_lingxingTextField.text],
                           @"sleeve_linging":[MemberType orderType:_xiuxingTextField.text],
                           @"placket":[MemberType orderType:_menjinTextField.text],
                           @"style":[MemberType orderType:_heshenduTextField.text],
                           @"live_insert":[MemberType orderType:_huochapianTextField.text],
                           @"embroidered_text":_xiuzineirongTextField.text,
                           @"embroidered_font":[MemberType orderType:_xiuziFontTextField.text],
                           @"color":_xiuziColorTextField.text,
                           @"embroidered_position":_xiuziweiziTextField.text,
                           @"hem":[MemberType orderType:_xiabaiTextField.text],
                           @"number":_shuliangTextField.text,
                           @"note":_beizhuTextField.text,
                           @"white_collar":[NSNumber numberWithBool:_lingkuanbaiButton.selected],
                           @"white_sleeve":[NSNumber numberWithBool:_xiukuanbaiButton.selected],
                           @"packet":[self packet:_xiongdaiButton.selected],
                           @"embroidered":[NSNumber numberWithBool:_xiuziButton.selected]
                           };

//    NSMutableDictionary * datadic = [[NSMutableDictionary alloc]init];
//    [datadic addEntriesFromDictionary:dic1];
//    [datadic addEntriesFromDictionary:dic2];
//    [datadic addEntriesFromDictionary:dic3];
//    [datadic addEntriesFromDictionary:dic4];
//    [datadic addEntriesFromDictionary:dic];
    
    ClothingModel * odermodel = [[ClothingModel alloc]init];
    odermodel = nil;
    odermodel = [ClothingModel mj_objectWithKeyValues:dic];
    
    
    return odermodel;
}


-(NSString *)packet:(int)str
{
    if (str==1)
    {
        return @"1";
    }else
    {
        return @"4";
    }
}

- (IBAction)checkButton:(LYCheckBoxButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender ==_xiuziButton) {
        
        _xiuziweiziTextField.enabled = !_xiuziweiziTextField.enabled;
        _xiuzineirongTextField.enabled = !_xiuzineirongTextField.enabled;
        _xiuziColorTextField.enabled = !_xiuziColorTextField.enabled;
        _xiuziFontTextField.enabled = !_xiuziFontTextField.enabled;
        
        if (!_xiuziButton.selected) {
            
            _xiuziweiziTextField.text = @"";
            _xiuzineirongTextField.text = @"";
            _xiuziColorTextField.text = @"";
            _xiuziFontTextField.text = @"";
            
        }

    }
}


- (IBAction)doneTextButton:(UIButton *)sender {
    
    if (_mianliaoTextField.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"面料参数还未选择"];
        return;
    }
    
    if (_shuliangTextField.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"数量参数还未填写"];
        return;
    }
    
    if (_heshenduTextField.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"合身度参数还未选择"];
        return;
    }
    
    if (_xiuziButton.selected) {
        if (_xiuziFontTextField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"绣字字体未填写"];
            return;
        }
        if (_xiuziColorTextField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"绣字颜色未填写"];
            return;
        }
        if (_xiuziweiziTextField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"绣字位置未填写"];
            return;
        }
        if (_xiuzineirongTextField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"绣字内容未填写"];
            return;
        }
        
        if ([_xiuziColorTextField.text isEqualToString:@"其他颜色（请在备注中输入）"]) {
            if ([_beizhuTextField.text isEqualToString:@""]){
                [SVProgressHUD showErrorWithStatus:@"请在备注中输入绣字颜色"];
                return;
            }
        }
    }
  
    
    if ([_shuliangTextField.text intValue]<=0||[_shuliangTextField.text intValue]>=10) {
        
        [SVProgressHUD showErrorWithStatus:@"数量范围为0~10件,且必须为数字"];
        return;
    }
    
    
    
    if ([sender.titleLabel.text isEqual:@"完成输入"])
    {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(orderData:)]) {
            
            [_delegate orderData:[self DoneData]];
         
        }
        _superViewController.navigationItem.rightBarButtonItem.enabled = YES;
        [sender setTitle:@"修改参数" forState:UIControlStateNormal];
        _menbanView.hidden = NO;
        _addSonButton.enabled = YES;
        [self dismissKeyboard];
    }else if ([sender.titleLabel.text isEqual:@"修改参数"])
    {
  
        _menbanView.hidden = YES;
        _addSonButton.enabled = NO;
        _superViewController.navigationItem.rightBarButtonItem.enabled = NO;
        [sender setTitle:@"确认修改" forState:UIControlStateNormal];
        [self dismissKeyboard];
    }else if ([sender.titleLabel.text isEqual:@"确认修改"])
    {
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(replaceOrderData:index:)]) {
            
            [_delegate replaceOrderData:[self DoneData] index:[_tagstr integerValue]];
        }
        _superViewController.navigationItem.rightBarButtonItem.enabled = YES;
        [sender setTitle:@"修改参数" forState:UIControlStateNormal];
        _menbanView.hidden = NO;
        _addSonButton.enabled = YES;
        [self dismissKeyboard];
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyboard];
}

-(void)dismissKeyboard
{
    [_xiuzineirongTextField resignFirstResponder];
    [_xiuziColorTextField resignFirstResponder];
    [_xiuziweiziTextField resignFirstResponder];
    [_xiuziFontTextField resignFirstResponder];
    [_shuliangTextField resignFirstResponder];
}


- (IBAction)addSonOrder:(UIButton *)sender {
    

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(addSonOrder:)]) {
        
     [_delegate addSonOrder:sender];
        
    }
    _superViewController.navigationItem.rightBarButtonItem.enabled = NO;
    sender.hidden = YES;
    
}

+(ClothingDetaiView *)instanceTextView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ClothingDetaiView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
@end
