//
//  OrderButton.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/11.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "OrderButton.h"

@implementation OrderButton

+(NSString *)keyBoardtag:(NSInteger)tag
{
    NSString * str = nil;
    switch (tag) {
        case 80000:
            str = @"0";
            break;
        case 8001:
            str = @"1";
            break;
        case 8002:
            str = @"2";
            break;
        case 8003:
            str = @"3";
            break;
        case 8004:
            str = @"4";
            break;
        case 8005:
            str = @"5";
            break;
        case 8006:
            str = @"6";
            break;
        case 8007:
            str = @"7";
            break;
        case 8008:
            str = @"8";
            break;
        case 8009:
            str = @"9";
            break;
        case 80011:
            str = @".";
            break;
            
        default:
            break;
    }
    
    return str;
}
+(UITextField *)inputContentRestriction:(UITextField *)textfield btntag:(NSInteger)btntag;{
    
    if (btntag==80010) {
        
        if ([textfield.text length]==0)
            return textfield;
        
        if ([textfield.text isEqualToString:@"0."]){
            textfield.text =@"";
            return textfield;
        }
        textfield.text =[textfield.text substringToIndex:[textfield.text length]-1];
        
    }else
    {
        if (btntag ==80000&&[textfield.text length]==0)
            return textfield;
        
        if ([textfield.text length]==0&&btntag==80011) {
            
            textfield.text = @"0.";
        }
        
        if([textfield.text rangeOfString:@"."].location !=NSNotFound&&btntag==80011)//_roaldSearchText
            return textfield;
        
        textfield.text =[textfield.text stringByAppendingString:[OrderButton keyBoardtag:btntag]];
    }
    
    return textfield;
}

@end
