//
//  LYUITextField.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/10.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "LYUITextField.h"
#import "AlertTabelView.h"
#import "AppDelegate.h"


@implementation LYUITextField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius=5.0f;
    self.layer.masksToBounds=YES;
    self.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
    self.layer.borderWidth= 1.f;
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"xialasanjiao.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(-10, 0, 64/2.5, 36/2.5);
    [button addTarget:self action:@selector(textField:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView=button;
    
    self.returnKeyType = UIReturnKeyDone;
//    self.delegate = self;
//    self.rightViewMode = UITextFieldViewModeAlways;
}
-(void)textField:(UITextView *)textField
{
    
    
    NSLog(@"%@----%ld",  self.placeholder,(long)self.tag);
    AlertTabelView * viewcontroller = [[AlertTabelView alloc]init];
    viewcontroller.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    viewcontroller.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [viewcontroller setTagID:self.tag];
   AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[appdelegate getCurrentVC] presentViewController:viewcontroller animated:YES completion:^{
        
       
    viewcontroller.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    }];
}



- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += 10;
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    bounds.origin.x += 10;
    return bounds;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self resignFirstResponder];
    return YES;
}


- (CGRect) rightViewRectForBounds:(CGRect)bounds {
    
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 10;
    return textRect;
}


@end
