//
//  LoginController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/4/28.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "LoginController.h"
#import "UMessage.h"

@interface LoginController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic)  UITextField *userTextField;
@property (weak, nonatomic)  UITextField *passwTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.dataSource =self;
    _tableView.delegate =self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"LoginRegister" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"];
    }
    return self;
}
- (IBAction)loginButton:(id)sender {
    
    if (_userTextField.text.length==0||_passwTextField.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"输入框不能为空!"];
        return;
    }
    
    [SVProgressHUD show];
    
    NSDictionary * dic = @{@"phone":[NSString stringWithFormat:@"%@",_userTextField.text],@"password":[NSString stringWithFormat:@"%@",_passwTextField.text]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval  = 30;
    
    
    [manager POST:LoginUrl parameters:dic progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            [SVProgressHUD dismiss];
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"againLogin"]==YES) {
                
                
                
                if (![[[responseObject objectForKey:@"data"] valueForKey:@"id"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"]]) {
                    
                    
                    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"TailorismDB.sqlite"];
                    
                    NSFileManager* fileManager=[NSFileManager defaultManager];
                    [fileManager removeItemAtPath:filePath error:nil];
                    
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"firstStart"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    
                }
                
            }
            
            //  同步数据
            [[NSUserDefaults standardUserDefaults]setObject:[responseObject objectForKey:@"token"] forKey:@"Token"];
             [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:[[responseObject objectForKey:@"data"] valueForKey:@"name"] forKey:@"adminname"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:[[responseObject objectForKey:@"data"] valueForKey:@"id"] forKey:@"adminID"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
     
            
            
            
            if ([[[responseObject objectForKey:@"data"] valueForKey:@"roles"]isKindOfClass:[NSArray class]]) {
                
                if ([[[responseObject objectForKey:@"data"] valueForKey:@"roles"]count]>0)
                {
                    if ([[[responseObject objectForKey:@"data"] valueForKey:@"roles"]containsObject:@"Manager"]) {
                        
                        [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"Roles"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }else {
                    
                        [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"Roles"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                    
                    
                }else
                {
                    [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"Roles"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }else {
                
                [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"Roles"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            [UMessage setAlias:_userTextField.text type:@"UserName" response:^(id responseObject, NSError *error) {
                
            }];
            
            
          
            
            AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            [appdelegate getrootViewController];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
////        NSLog(@"Error: %@---%@",  error,operation);
////        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%ld",(long)error.code]];
//
////       [error valueForKey:@"com.alamofire.serialization.response.error.data"]
////        
////        NSString *result = [[NSString alloc] initWithData:[error valueForKey:@"com.alamofire.serialization.response.error.data"]  encoding:NSUTF8StringEncoding];
////        
////        [SVProgressHUD showErrorWithStatus:result];
////        NSLog(@"%@",[error.userInfo valueForKey:@"NSDebugDescription"]);
//        NSLog(@"%@",(error.userInfo[NSUnderlyingErrorKey]));
        
        NSString * str  = [NSString stringWithFormat:@"%ld",(long)error.code];
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"系统错误,错误码:%@",str]];
        

    }];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"cell11111" forIndexPath:indexPath];
    _userTextField = (UITextField*)[cell viewWithTag:1000101];
    _passwTextField = (UITextField*)[cell viewWithTag:1000102];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_userTextField resignFirstResponder];
    [_passwTextField resignFirstResponder];
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
