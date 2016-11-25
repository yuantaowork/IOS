//
//  OrderDetailsController.h
//  Tailorism
//
//  Created by LIZhenNing on 16/5/23.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailsController : UITableViewController
@property (strong,nonatomic)NSString * orderDetailsID;
@property (strong,nonatomic)NSDictionary * photoNameAarry;;

@property (copy , nonatomic)NSString *statusTpye;

@end
