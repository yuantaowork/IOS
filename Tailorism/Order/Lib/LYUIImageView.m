//
//  LYUIImageView.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/26.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "LYUIImageView.h"

@implementation LYUIImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    _iamgeShow = NO;
    self.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
    self.layer.borderWidth= 1.f;
}


@end
