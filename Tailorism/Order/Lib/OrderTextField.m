//
//  OrderTextField.m
//  Tailorism
//
//  Created by LIZhenNing on 16/6/4.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "OrderTextField.h"

@implementation OrderTextField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius=5.0f;
    self.layer.masksToBounds=YES;
    self.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
    self.layer.borderWidth= 1.f;
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.returnKeyType = UIReturnKeyDone;
}

-(void)rightButton:(UIButton*)sender
{
    
    
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
