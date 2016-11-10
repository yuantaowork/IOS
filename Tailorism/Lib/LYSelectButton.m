//
//  LYSelectButton.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/11.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "LYSelectButton.h"

@implementation LYSelectButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.borderColor=[[UIColor colorWithHex:@"5673b7"]CGColor];
    self.layer.borderWidth= 1.0f;
    
    self.tintColor = [UIColor clearColor];
    [self setTitleColor:[UIColor colorWithHex:@"5673b7"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:@"shujbtnbg.jpg"] forState:UIControlStateSelected];
    

}


@end
