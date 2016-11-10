//
//  MemberModel.h
//  Tailorism
//
//  Created by LIZhenNing on 16/6/20.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberModel : NSObject

singleton_interface(MemberModel)

@property (copy, nonatomic) NSString *name;   //姓名
@property (copy, nonatomic) NSString *phone_number; //手机号
@property (copy, nonatomic) NSString *consignee_address; //收货地址
@property (copy, nonatomic) NSString *note; //备注
@property (copy, nonatomic) NSString *height; //身高
@property (copy, nonatomic) NSString *weight; //体重
@property (copy, nonatomic) NSString *collar_opening; //领围
@property (copy, nonatomic) NSString *chest_width; //胸围
@property (copy, nonatomic) NSString *processed_chest_width; //胸围成衣
@property (copy, nonatomic) NSString *middle_waisted;//腰围
@property (copy, nonatomic) NSString *processed_middle_waisted; //腰围成衣
@property (copy, nonatomic) NSString *swing_around; //下摆
@property (copy, nonatomic) NSString *processed_swing_around; //下摆成衣
@property (copy, nonatomic) NSString *arm_width; //袖肥
@property (copy, nonatomic) NSString *processed_arm_width; //袖肥成衣
@property (copy, nonatomic) NSString *left_wrist_width; //左袖口
@property (copy, nonatomic) NSString *processed_left_wrist_width; //左袖口成衣
@property (copy, nonatomic) NSString *right_wrist_width; //右袖口
@property (copy, nonatomic) NSString *processed_right_wrist_width; //右袖口成衣
@property (copy, nonatomic) NSString *should_width;//肩宽
@property (copy, nonatomic) NSString *left_sleeve; //左袖长
@property (copy, nonatomic) NSString *right_sleeve; //右袖长
@property (copy, nonatomic) NSString *back_length; //后衣长
@property (copy, nonatomic) NSString *front_length; //前背宽
@property (copy, nonatomic) NSString *chest; //前胸
@property (copy, nonatomic) NSString *back; //后背
@property (copy, nonatomic) NSString *shoulder; //肩部
@property (copy, nonatomic) NSString *abdomen; //腹部
@property (copy, nonatomic) NSString *body_shape; //体型
@property (copy, nonatomic) NSString *station_layout; //站姿
@property (copy, nonatomic) NSString *meberID; //站姿
@property (copy, nonatomic) NSString *dressing_name; //站姿




@end
