//
//  OrderButton.h
//  Tailorism
//
//  Created by LIZhenNing on 16/5/11.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderButton : NSObject

+(NSString *)keyBoardtag:(NSInteger)tag;


+(UITextField *)inputContentRestriction:(UITextField *)textfield btntag:(NSInteger)btntag;

@end
