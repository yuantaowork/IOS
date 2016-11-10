//
//  UIColor+Category.m
//  JZOLEmployerClient
//
//  Created by Ada on 15/8/28.
//  Copyright (c) 2015年 jiazhengol. All rights reserved.
//

#import "UIColor+JZOL.h"

@implementation UIColor (JZOL)

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r) / 255.0 green: (g) / 255.0 blue:(b) / 255.0 alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

+(UIColor*)colorWithHex:(NSString*)hexString
{
    unsigned int red = 0;
    unsigned int green = 0;
    unsigned int blue = 0;
    
    [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red];
    
    [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
    
    [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue];
    
    //    NSLog(@"%u, %u, %u ",red,green,blue);
    return RGB(red, green, blue);
}
+(UIColor*)colorWithHex:(NSString*)hexString alpha:(CGFloat)alpha
{
    unsigned int red = 0;
    unsigned int green = 0;
    unsigned int blue = 0;
    
    [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red];
    
    [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
    
    [[NSScanner scannerWithString:[hexString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue];
    
    return RGBA(red, green, blue,alpha);
}
@end
