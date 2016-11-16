//
//  AppDelegate.h
//  Tailorism
//
//  Created by LIZhenNing on 16/5/6.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)forceUpVersion;

-(void)getrootViewController;
- (UIViewController *)getCurrentVC;
-(void)getHttpMeberList;
@end

