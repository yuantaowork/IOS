//
//  CouponTab.h
//  JZOLEmployerClient
//
//  Created by admin on 15/10/26.
//  Copyright © 2015年 jiazhengol. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CouponTabDelegate<NSObject>

@optional
-(void)couponTabindex:(NSInteger)index;

@end

@interface CouponTab : UIView

@property (strong,nonatomic)UILabel * redline;
@property (strong,nonatomic) id <CouponTabDelegate>delegate;


-(void)commitAnimations:(BOOL)animatbool;
@end
