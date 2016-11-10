//
//  BodyTableViewCell.h
//  Tailorism
//
//  Created by LIZhenNing on 16/7/14.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *address;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coftimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *timeTile;



@end
