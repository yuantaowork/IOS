//
//  AppDelegate.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/6.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "AFNetworkReachabilityManager.h"
#import "UMessage.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>


#define PGY_APPKEY @"c8b9fff0b387d6f2ad4f49e76257672a"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    [UMessage startWithAppkey:@"57874d6667e58eec8d000658" launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    [UMessage setLogEnabled:YES];
    
    
    [self getrootViewController];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    [[PgyManager sharedPgyManager] setThemeColor:[UIColor colorWithHex:@"37C5A1"]];
    [[PgyManager sharedPgyManager] setShakingThreshold:4.0];
    
    
    [SVProgressHUD  setBackgroundColor:[UIColor colorWithHex:@"6d87c3" alpha:.9]];
    [SVProgressHUD  setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"未识别的网络");
//                break;
//                
//            case AFNetworkReachabilityStatusNotReachable:
//                NSLog(@"不可达的网络(未连接)");
//                [SVProgressHUD showInfoWithStatus:@"无网络"];
//                [[NSUserDefaults standardUserDefaults]setObject:@"NoNet" forKey:@"NetType"];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"2G,3G,4G...的网络");
//                [SVProgressHUD showInfoWithStatus:@"当前为2G/3G/4G网络"];
//                [[NSUserDefaults standardUserDefaults]setObject:@"4G" forKey:@"NetType"];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"wifi的网络");
//                [SVProgressHUD showInfoWithStatus:@"当前为WIFI网络"];
//                [[NSUserDefaults standardUserDefaults]setObject:@"WIFI" forKey:@"NetType"];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//                break;
//            default:
//                break;
//        }
//    }];
//    [manager startMonitoring];
    
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
  
    callCenter.callEventHandler=^(CTCall* call){

        
     
        if (call.callState == CTCallStateDialing){
            
            NSLog(@"Call Dialing");
            
        }
        
        if (call.callState == CTCallStateConnected){
            
            NSLog(@"Call Connected");
            
            
//            [self performSelectorOnMainThread:@selector(closeTalk) withObject:nil waitUntilDone:YES];
            
        }
        
        if (call.callState == CTCallStateDisconnected){
            

            
            NSLog(@"Call Disconnected");
        
        }
    
    };
    
    
    
    return YES;
}

-(void)getrootViewController
{

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        
        NSLog(@"第一次启动");
        
        
        
    }else{
        NSLog(@"不是第一次启动");
        

      }

        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Token"]!=nil)
        {
            
            UIStoryboard * storeyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.window.rootViewController =[storeyboard instantiateInitialViewController];

        }else
        {
            LoginController * loginView = [[LoginController alloc]init];

            self.window.rootViewController = loginView;
        }

}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    //  [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}


-(void)getHttpMeberList
{
    
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"pageSize":@"1"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager POST:MerberList parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            
            if ([LYFmdbTool insertMember:[[responseObject objectForKey:@"data"]objectForKey:@"data"]del:NO appdelegate:YES] ) {
                
//                [SVProgressHUD showSuccessWithStatus:@"同步通讯录成功!"];
            }
            
            NSMutableArray * dataarry = [[NSMutableArray alloc]init];
            for (int i =0; i<[[[responseObject objectForKey:@"data"]objectForKey:@"data"]count]; i++)
            {
                
                
                NSDictionary * dic = [[[responseObject objectForKey:@"data"]objectForKey:@"data"]objectAtIndex:i];
                
                if (![[dic objectForKey:@"phone_number"]isEqual:[NSNull null]])
                {
                    if (![[dic objectForKey:@"name"]isEqual:[NSNull null]])
                    {
                        [dataarry addObject:@{@"name":[dic objectForKey:@"name"],@"phone_number":[dic objectForKey:@"phone_number"],@"consignee_address":[dic objectForKey:@"consignee_address"]}];
                    }
                    
                }
                
            }
//            if ([LYFmdbTool insertMemberName:dataarry])
//            {
//                
//            }
            
//            NSLog(@"%@--姓名数据",dataarry);
            
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
}

@end
