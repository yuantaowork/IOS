//
//  LYCheckBoxButton.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/10.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "LYCheckBoxButton.h"

@implementation LYCheckBoxButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [self addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    self.layer.borderColor=[[UIColor grayColor]CGColor];
    self.layer.borderWidth= 1.0f;
    self.layer.cornerRadius=5.0f;
    self.layer.masksToBounds=YES;
    
    
    self.tintColor = [UIColor clearColor];
    [self setTitleColor:[UIColor colorWithHex:@"5673b7"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:@"CheckBoxButton.png"] forState:UIControlStateSelected];
//    _Sections = 0;
}



@end
