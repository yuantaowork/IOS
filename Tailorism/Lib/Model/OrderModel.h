//
//  OrderModel.h
//  Tailorism
//
//  Created by LIZhenNing on 16/6/29.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

singleton_interface(OrderModel)

@property (copy, nonatomic) NSString *sale_name;   //销售人员
@property (copy, nonatomic) NSString *dressing_name; //着装顾问
@property (copy, nonatomic) NSString *pay_type; //支付方式
@property (copy, nonatomic) NSString *discount; //打折金钱
@property (copy, nonatomic) NSString *discount_remark;//打折原因
@property (copy, nonatomic) NSString *address; //地址
@property (copy, nonatomic) NSString *express_note; //订单备注
@property (copy, nonatomic) NSString *embroidered; //是否绣字
@property (copy, nonatomic) NSString *invoice;//发票
@property (copy, nonatomic) NSString *measure_time;//量体时间
@property (copy, nonatomic) NSString *service_end_time;//服务结束时间


@end
