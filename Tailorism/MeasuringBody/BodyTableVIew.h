//
//  BodyTableVIew.h
//  Tailorism
//
//  Created by LIZhenNing on 16/7/13.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    NewReservation,
    Reservation,
    
}bodyType;

@interface BodyTableVIew : UIView <UITableViewDataSource,UITableViewDelegate>

@property(retain,nonatomic)UITableView * tableView;


- (id)initWithFrame:(CGRect)frame type:(bodyType)type controller:(id)controller;
-(void)getHttpData:(NSArray *)dataArry;
@end
