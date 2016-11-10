//
//  OrderEntryViewController.h
//  Tailorism
//
//  Created by LIZhenNing on 16/5/10.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderEntryViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSDictionary   *memberDic;
@property (nonatomic, strong) NSString       *pushID;
@property (strong,nonatomic )NSDictionary     *imagedic;
@end
