//
//  WuliuViewController.m
//  Tailorism
//
//  Created by 袁涛 on 2016/11/24.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "WuliuViewController.h"

@interface WuliuViewController ()

@property (nonatomic , strong)UIWebView *myWebView;

@end

@implementation WuliuViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [self.tabBarController.tabBar setHidden:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"良衣";
    
    [SVProgressHUD showInfoWithStatus:@"已自动复制快递单号，长按可粘贴"];
    
    self.myWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.kuaidi100.com/"]]];
    self.myWebView.opaque = NO;
    self.myWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myWebView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
