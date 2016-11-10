//
//  ClothingModel.h
//  Tailorism
//
//  Created by LIZhenNing on 16/6/29.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClothingModel : NSObject


//singleton_interface(ClothingModel)

@property (copy, nonatomic) NSString *code;   //布料编号
@property (copy, nonatomic) NSString *collar_type; // 领型
@property (copy, nonatomic) NSString *sleeve_linging; //袖型
@property (copy, nonatomic) NSString *placket; //门襟
@property (copy, nonatomic) NSString *packet; //胸袋
@property (copy, nonatomic) NSString *style; //合身度
@property (copy, nonatomic) NSString *live_insert; //活插片
@property (copy, nonatomic) NSString *embroidered; //是否绣字
@property (copy, nonatomic) NSString *embroidered_text;//内容
@property (copy, nonatomic) NSString *embroidered_font; //字体
@property (copy, nonatomic) NSString *color; //颜色
@property (copy, nonatomic) NSString *embroidered_position; //位置
@property (copy, nonatomic) NSString *number; //数量
@property (copy, nonatomic) NSString *note; //备注
@property (copy, nonatomic) NSString *white_collar; //领款白色
@property (copy, nonatomic) NSString *white_sleeve; //袖口白色
@property (copy, nonatomic) NSString *hem; //袖口白色



@end
