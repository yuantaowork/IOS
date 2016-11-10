//
//  OrderKeyBoardButton.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/12.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "OrderKeyBoardButton.h"
#import "OrderButton.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation OrderKeyBoardButton

//static SystemSoundID shake_sound_male_id = 0;
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.layer.borderColor=[[UIColor colorWithHex:@"5673b7"]CGColor];
    self.layer.borderWidth= 1.0f;
    
    self.tintColor = [UIColor clearColor];
    [self setTitleColor:[UIColor colorWithHex:@"5673b7"] forState:UIControlStateNormal];
    
    [self addTarget:self action:@selector(playWav:) forControlEvents:UIControlEventTouchUpInside];
    
    //更新内容测试11111
    
}

-(void)playWav:(UIButton *)btn{

        [self playSound];
}

-(void) playSound
{
    
    SystemSoundID myAlertSound;
    NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/Tock.caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
    AudioServicesPlaySystemSound(myAlertSound);
    
}
@end
