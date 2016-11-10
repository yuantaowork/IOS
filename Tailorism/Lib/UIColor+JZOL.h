//
//  UIColor+Category.h
//  JZOLEmployerClient
//
//  Created by Ada on 15/8/28.
//  Copyright (c) 2015年 jiazhengol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JZOL)

+(UIColor*)colorWithHex:(NSString*)hexString;
+(UIColor*)colorWithHex:(NSString*)hexString alpha:(CGFloat)alpha;
@end
