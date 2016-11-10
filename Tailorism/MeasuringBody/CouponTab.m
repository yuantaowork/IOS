//
//  CouponTab.m
//  JZOLEmployerClient
//
//  Created by admin on 15/10/26.
//  Copyright © 2015年 jiazhengol. All rights reserved.
//

#import "CouponTab.h"

@implementation CouponTab
{
    UIButton * butone;
    UIButton * buttwo;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        
        butone = [UIButton buttonWithType:UIButtonTypeCustom];
        butone.frame = CGRectMake(0, 4,CGRectGetWidth(frame)/2, CGRectGetHeight(frame)-8);
        [butone setTitle:@"新的预约" forState:UIControlStateNormal];
        butone.titleLabel.font = [UIFont systemFontOfSize:15.f];
        butone.tag = 100;
        [butone addTarget:self action:@selector(selectbutton:) forControlEvents:UIControlEventTouchUpInside];
        [butone setTitleColor:[UIColor colorWithHex:@"6d87c3"] forState:UIControlStateSelected];
        [butone setTitleColor:[UIColor colorWithHex:@"6D6D6D"] forState:UIControlStateNormal];
        [butone setSelected:YES];
        butone.userInteractionEnabled = YES;
        [self addSubview:butone];
      
        
        buttwo = [UIButton buttonWithType:UIButtonTypeCustom];
        buttwo.frame = CGRectMake(CGRectGetWidth(frame)/2, 4,CGRectGetWidth(frame)/2, CGRectGetHeight(frame)-8);
        [buttwo setTitle:@"待上门预约" forState:UIControlStateNormal];
        buttwo.titleLabel.font = [UIFont systemFontOfSize:15.f];
        buttwo.tag= 102;
        [buttwo addTarget:self action:@selector(selectbutton:) forControlEvents:UIControlEventTouchUpInside];
        [buttwo setTitleColor:[UIColor colorWithHex:@"6D6D6D"] forState:UIControlStateNormal];
        [buttwo setTitleColor:[UIColor colorWithHex:@"6d87c3"] forState:UIControlStateSelected];
        [self addSubview:buttwo];

        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-1, CGRectGetWidth(frame), 1)];
        line.backgroundColor = [UIColor colorWithHex:@"E3E3E3"];
        [self addSubview:line];
        
        
        _redline = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-3,CGRectGetWidth(frame)/2, 3)];
        _redline.backgroundColor = [UIColor colorWithHex:@"6d87c3"];
        [self addSubview:_redline];

    }
    return self;
}

-(void)selectbutton:(UIButton*)aBtn
{

    if (aBtn.tag==100)
    {
        [self commitAnimations:NO];
        [_delegate couponTabindex:0];

    }else
    {
        [self commitAnimations:YES];
        [_delegate couponTabindex:1];
    }
}

-(void)commitAnimations:(BOOL)animatbool
{
    
    [UIView animateWithDuration:0.5 animations:^{

        if (animatbool)
        {
              [_redline setFrame:CGRectMake(CGRectGetWidth(_redline.frame),_redline.frame.origin.y,CGRectGetWidth(_redline.frame), 3)];
            
        }else
        {
             [_redline setFrame:CGRectMake(0,_redline.frame.origin.y,CGRectGetWidth(_redline.frame), 3)];
        }
        
    }];

    if (!animatbool)
    {
        [butone setSelected:YES];
        [buttwo setSelected:NO];
        butone.userInteractionEnabled = NO;
        buttwo.userInteractionEnabled = YES;
    }else
    {
        [butone setSelected:NO];
        [buttwo setSelected:YES];
        butone.userInteractionEnabled = YES;
        buttwo.userInteractionEnabled = NO;
    }

}



@end
