//
//  MemberType.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/30.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "MemberType.h"

@implementation MemberType


+(NSString *)meberType:(NSString *)str type:(NSString*)type
{
  
    if ([type isEqualToString:@"body_shape"]) {
        
        
        if ([str isEqualToString:@"normal"]) {
            return @"一般";
            
        }else if ([str isEqualToString:@"thin"])
        {
            return @"纤细";
            
        }else if ([str isEqualToString:@"rich"])
        {
            return @"富贵";
            
        }else if ([str isEqualToString:@"little_fat"])
        {
            return @"微胖";
            
        }else if ([str isEqualToString:@"strong"])
        {
            return @"强壮";
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"station_layout"])
    {
        if ([str isEqualToString:@"normal"]) {
            return @"普通";
            
        }else if ([str isEqualToString:@"raised_chest"])
        {
            return @"挺胸";
            
        }else if ([str isEqualToString:@"humpbacked"])
        {
            return @"驼背";
            
        }else if ([str isEqualToString:@"coax_back"])
        {
            return @"哄背";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"shoulder"])
    {
        if ([str isEqualToString:@"normal"]) {
            return @"普通";
            
        }else if ([str isEqualToString:@"xiaoping_shoulder"])
        {
            return @"小平肩";
            
        }else if ([str isEqualToString:@"daping_shoulder"])
        {
            return @"大平肩";
            
        }else if ([str isEqualToString:@"small_shoulder"])
        {
            return @"小溜肩";
            
        }else if ([str isEqualToString:@"big_shoulder"])
        {
            return @"大溜肩";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"abdomen"])
    {
        if ([str isEqualToString:@"flat_belly"]) {
            return @"平腹";
            
        }else if ([str isEqualToString:@"micro_abdominal"])
        {
            return @"微腹";
            
        }else if ([str isEqualToString:@"upper_abdomen"])
        {
            return @"大腹";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"order_status"])
    {
        
        
        if ([str isEqualToString:@"0"]) {
            return @"等待接单";
            
        }else if ([str isEqualToString:@"1"])
        {
            return @"已接单";
            
        }else if ([str isEqualToString:@"2"])
        {
            return @"生产中";
            
        }else if ([str isEqualToString:@"3"])
        {
            return @"完成";
            
        }else if ([str isEqualToString:@"4"])
        {
            return @"发货";
            
        }else if ([str isEqualToString:@"5"])
        {
            return @"废弃";
            
        }else if ([str isEqualToString:@"6"])
        {
            return @"已审核";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"collar_type"])
    {

        if ([str isEqualToString:@"standed_collar"]) {
            return @"标准领";
            
        }else if ([str isEqualToString:@"cutaway_collar"])
        {
            return @"八字领";
            
        }else if ([str isEqualToString:@"honzcntal_collar"])
        {
            return @"一字领";
            
        }else if ([str isEqualToString:@"button_dawn_collar"])
        {
            return @"领尖扣领";
            
        }else if ([str isEqualToString:@"square_collar"])
        {
            return @"小方领";
            
        }else if ([str isEqualToString:@"round_collar"])
        {
            return @"圆领";
            
        }else if ([str isEqualToString:@"wing_collar"])
        {
            return @"礼服领";
            
        }else if ([str isEqualToString:@"stand_collar"])
        {
            return @"立领";
            
        }else if ([str isEqualToString:@"hidden_button_collar"])
        {
            return @"暗扣领";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"pay_type"])
    {
        
        if ([str isEqualToString:@"0"]) {
            return @"";
            
        }else if ([str isEqualToString:@"1"])
        {
            return @"法人-支付宝";
            
        }else if ([str isEqualToString:@"2"])
        {
            return @"法人-钱方好近";
            
        }else if ([str isEqualToString:@"3"])
        {
            return @"免费";
            
        }else if ([str isEqualToString:@"4"])
        {
            return @"月结-法人-支付宝";
            
        }else if ([str isEqualToString:@"5"])
        {
            return @"月结-法人-钱方好近";
            
        }else if ([str isEqualToString:@"6"])
        {
            return @"月结-法人-工行";
            
        }else if ([str isEqualToString:@"7"])
        {
            return @"公司-刷卡";
            
        }else if ([str isEqualToString:@"8"])
        {
            return @"法人-工行";
            
        }else if ([str isEqualToString:@"9"])
        {
            return @"银行对公";
            
        }else if ([str isEqualToString:@"10"])
        {
            return @"公司-支付宝";
            
        }else if ([str isEqualToString:@"11"])
        {
            return @"公司-微信";
            
        }else if ([str isEqualToString:@"12"])
        {
            return @"线下";
            
        }else if ([str isEqualToString:@"13"])
        {
            return @"法人微信";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"sleeve_linging"])
    {
        
        if ([str isEqualToString:@"single_button_cut_angle"]) {
            return @"单扣截角";
            
        }else if ([str isEqualToString:@"single_button_rand_angle"])
        {
            return @"单扣圆角";
            
        }else if ([str isEqualToString:@"single_button_straight_angle"])
        {
            return @"单扣直角";
            
        }else if ([str isEqualToString:@"dou_cut_angle"])
        {
            return @"双扣截角";
            
        }else if ([str isEqualToString:@"dou_straight_angle"])
        {
            return @"双扣圆角";
            
        }else if ([str isEqualToString:@"dou_straight_straight_angle"])
        {
            return @"双扣直角";
            
        }else if ([str isEqualToString:@"french_cut_angle"])
        {
            return @"法式截角";
            
        }else if ([str isEqualToString:@"french_round_angle"])
        {
            return @"法式圆角";
            
        }else if ([str isEqualToString:@"french_straight_angle"])
        {
            return @"法式直角";
            
        }else if ([str isEqualToString:@"short_sleeve"])
        {
            return @"短袖";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"placket"])
    {
        
        if ([str isEqualToString:@"frant_strap"]) {
            return @"明门襟";
            
        }else if ([str isEqualToString:@"flat_strap"])
        {
            return @"平门禁";
            
        }else if ([str isEqualToString:@"hidden_strap"])
        {
            return @"暗门襟";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"style"])
    {
        
        if ([str isEqualToString:@"slin"]) {
            return @"修身";
            
        }else if ([str isEqualToString:@"fit"])
        {
            return @"合身";
            
        }else if ([str isEqualToString:@"loosen"])
        {
            return @"宽松";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"live_insert"])
    {
        
        if ([str isEqualToString:@"0"]) {
            return @"无插片";
            
        }else if ([str isEqualToString:@"1"])
        {
            return @"固定插片";
            
        }else if ([str isEqualToString:@"2"])
        {
            return @"活插片";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"fold_back"])
    {
        
        if ([str isEqualToString:@"2"]) {
            return @"无褶";
            
        }else if ([str isEqualToString:@"1"])
        {
            return @"边褶";
            
        }else if ([str isEqualToString:@"0"])
        {
            return @"工字褶";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"waist_dart"])
    {
        
        if ([str isEqualToString:@"0"]) {
            return @"否";
            
        }else if ([str isEqualToString:@"1"])
        {
            return @"是";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"hem"])
    {
        
        if ([str isEqualToString:@"0"]) {
            return @"圆摆";
            
        }else if ([str isEqualToString:@"1"])
        {
            return @"平摆";
            
        }else if ([str isEqualToString:@"2"])
        {
            return @"开叉";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"embroidered_font"])
    {
        
        if ([str isEqualToString:@"normal"]) {
            return @"正体";
            
        }else if ([str isEqualToString:@"swash"])
        {
            return @"花体";
            
        }else if ([str isEqualToString:@"italic"])
        {
            return @"斜体";
            
        }else
        {
            return @"";
        }
        
    }else if ([type isEqualToString:@"packet"])
    {
        
        if ([str isEqualToString:@"1"]) {
            return @"是";
            
        }else if ([str isEqualToString:@"4"])
        {
            return @"否";
            
        }else
        {
            return @"";
        }
        
    }else
    {
        return @"";
    }

    

}
+(NSString *)orderType:(NSString *)str
{
 
        if ([str isEqualToString:@"标准领"]) {
            return @"standed_collar";
            
        }else if ([str isEqualToString:@"八字领"])
        {
            return @"cutaway_collar";
            
        }else if ([str isEqualToString:@"一字领"])
        {
            return @"honzcntal_collar";
            
        }else if ([str isEqualToString:@"领尖扣领"])
        {
            return @"button_dawn_collar";
            
        }else if ([str isEqualToString:@"小方领"])
        {
            return @"square_collar";
        }else if ([str isEqualToString:@"圆领"])
        {
            return @"round_collar";
        }else if ([str isEqualToString:@"礼服领"])
        {
            return @"wing_collar";
        }else if ([str isEqualToString:@"立领"])
        {
            return @"stand_collar";
        }else if ([str isEqualToString:@"暗扣领"])
        {
            return @"hidden_button_collar";
        }else if ([str isEqualToString:@"单扣截角"])
        {
            return @"single_button_cut_angle";
        }else if ([str isEqualToString:@"单扣圆角"])
        {
            return @"single_button_rand_angle";
        }else if ([str isEqualToString:@"单扣直角"])
        {
            return @"single_button_straight_angle";
        }else if ([str isEqualToString:@"双扣截角"])
        {
            return @"dou_cut_angle";
        }else if ([str isEqualToString:@"双扣圆角"])
        {
            return @"dou_straight_angle";
        }else if ([str isEqualToString:@"双扣直角"])
        {
            return @"dou_straight_straight_angle";
        }else if ([str isEqualToString:@"法式截角"])
        {
            return @"french_cut_angle";
        }else if ([str isEqualToString:@"法式圆角"])
        {
            return @"french_round_angle";
        }else if ([str isEqualToString:@"法式直角"])
        {
            
            return @"french_straight_angle";
            
        }else if ([str isEqualToString:@"短袖"])
        {
            
            return @"short_sleeve";
            
        }else if ([str isEqualToString:@"明门襟"])
        {
            return @"frant_strap";
        }else if ([str isEqualToString:@"平门禁"])
        {
            return @"flat_strap";
        }else if ([str isEqualToString:@"暗门襟"])
        {
            return @"hidden_strap";
        }else if ([str isEqualToString:@"修身"])
        {
            return @"slin";
        }else if ([str isEqualToString:@"合身"])
        {
            return @"fit";
        }else if ([str isEqualToString:@"宽松"])
        {
            return @"loosen";
        }else if ([str isEqualToString:@"是"])
        {
            return @"1";
        }else if ([str isEqualToString:@"否"])
        {
            return @"0";
        }else if ([str isEqualToString:@"正体"])
        {
            return @"normal";
        }else if ([str isEqualToString:@"花体"])
        {
            return @"swash";
        }else if ([str isEqualToString:@"斜体"])
        {
            return @"italic";
        }else if ([str isEqualToString:@"无褶"])
        {
            return @"2";
        }else if ([str isEqualToString:@"边褶"])
        {
            return @"1";
        }else if ([str isEqualToString:@"工字褶"])
        {
            return @"0";
        }else if ([str isEqualToString:@"圆摆"])
        {
            return @"0";
        }else if ([str isEqualToString:@"平摆"])
        {
            return @"1";
        }else if ([str isEqualToString:@"开叉"])
        {
            return @"2";
        }else if ([str isEqualToString:@"法人-支付宝"])
        {
            return @"1";
        }else if ([str isEqualToString:@"法人-钱方好近"])
        {
            return @"2";
        }else if ([str isEqualToString:@"免费"])
        {
            return @"3";
        }else if ([str isEqualToString:@"月结-法人-支付宝"])
        {
            return @"4";
        }else if ([str isEqualToString:@"月结-法人-钱方好近"])
        {
            return @"5";
        }else if ([str isEqualToString:@"月结-法人-工行"])
        {
            return @"6";
        }else if ([str isEqualToString:@"公司-刷卡"])
        {
            return @"7";
        }else if ([str isEqualToString:@"法人-工行"])
        {
            return @"8";
        }else if ([str isEqualToString:@"银行对公"])
        {
            return @"9";
        }else if ([str isEqualToString:@"公司-支付宝"])
        {
            return @"10";
        }else if ([str isEqualToString:@"公司-微信"])
        {
            return @"11";
        }else if ([str isEqualToString:@"线下"])
        {
            return @"12";
        }else if ([str isEqualToString:@"法人微信"])
        {
            return @"13";
        }else if ([str isEqualToString:@"无插片"])
        {
            return @"0";
        }else if ([str isEqualToString:@"固定插片"])
        {
            return @"1";
        }else if ([str isEqualToString:@"活插片"])
        {
            return @"2";
        }else
        {
            return @"";
        }
    
    
}



@end
