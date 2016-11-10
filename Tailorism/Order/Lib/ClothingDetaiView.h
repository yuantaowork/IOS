//
//  ClothingDetaiView.h
//  Tailorism
//
//  Created by LIZhenNing on 16/6/3.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYCheckBoxButton.h"
#import "OrderTextField.h"
#import "ClothingModel.h"
@protocol ClothingDetaiDelagate <NSObject>


@optional

-(void)CheckBoxButton:(LYCheckBoxButton *)button;

-(void)addSonOrder:(UIButton *)btn;

-(void)delSonOrder:(NSInteger)ordertag;

-(void)orderData:(ClothingModel*)dic;
-(void)replaceOrderData:(ClothingModel*)dic index:(NSInteger)index;
@end

@interface ClothingDetaiView : UIView <UITextFieldDelegate>


@property (strong,nonatomic) id <ClothingDetaiDelagate>delegate;
@property (weak, nonatomic) IBOutlet UIView *menbanView;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UIButton *addSonButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong,nonatomic)UIViewController * superViewController;
@property (weak, nonatomic) IBOutlet UILabel *OrderTitle;
@property (weak, nonatomic) IBOutlet OrderTextField *mianliaoTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *lingxingTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *xiuxingTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *menjinTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *heshenduTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *huochapianTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *xiuzineirongTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *xiuziFontTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *xiuziColorTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *xiuziweiziTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *xiabaiTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *shuliangTextField;
@property (weak, nonatomic) IBOutlet OrderTextField *beizhuTextField;
@property (weak, nonatomic) IBOutlet LYCheckBoxButton *lingkuanbaiButton;
@property (weak, nonatomic) IBOutlet LYCheckBoxButton *xiukuanbaiButton;
@property (weak, nonatomic) IBOutlet LYCheckBoxButton *xiongdaiButton;
@property (weak, nonatomic) IBOutlet LYCheckBoxButton *xiuziButton;
@property (weak, nonatomic) IBOutlet OrderTextField *xiuziColor;
@property (weak, nonatomic) IBOutlet OrderTextField *xiuziweizhi;

@property(retain,nonatomic)NSString * tagstr;
+(ClothingDetaiView *)instanceTextView;

-(void)Num:(NSInteger)number data:(NSArray*)dataArry controller:(UIViewController*)contoller;

@end
