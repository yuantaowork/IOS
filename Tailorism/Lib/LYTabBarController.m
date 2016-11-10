//
//  LYTabBarController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/10.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "LYTabBarController.h"
#import "MemberListController.h"
@interface LYTabBarController ()<UITabBarControllerDelegate>
@end

@implementation LYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedIndex = 0;
//    self.tabBar.tintColor = [UIColor colorWithHex:@"5673b7"];
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabarbg"];

    self.delegate = self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{

    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
