//
//  AddMeberController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/10.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "AddMeberController.h"
#import "LYUITextField.h"
@interface AddMeberController ()
@property (weak, nonatomic) IBOutlet LYUITextField *nameTextField;
@property (weak, nonatomic) IBOutlet LYUITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet LYUITextField *weChatTextField;
@property (weak, nonatomic) IBOutlet LYUITextField *addressTextField;

@end

@implementation AddMeberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBarController.tabBar setHidden:YES];

    
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
