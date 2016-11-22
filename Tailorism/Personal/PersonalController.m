 //
//  PersonalController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/23.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "PersonalController.h"
#import "UploadMemberController.h"
#import "UploadOrderController.h"
#import "WithdrawalsController.h"

@interface PersonalController () <UIAlertViewDelegate>

@property (strong, nonatomic)NSMutableDictionary * dataDic;
@property (strong, nonatomic)NSString * adminName;
@property NSInteger currentPage;
@property NSInteger maxPage;
@property BOOL NoNetwork;


@end

@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _dataDic = [[NSMutableDictionary alloc]init];

}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
   
    [self getHttpstaffDetails];
    
}

-(void)getHttpstaffDetails
{
    
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"member_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST: staffDetails parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            _dataDic = [NSMutableDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];

            self.tableView.delegate  = self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        return 89;
        
    }else if (indexPath.section==1){
        
        if (indexPath.row==0) {
            
            return 43;
        }else
        {
            return 70;
        }
    }else {
        
        return 60;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        
        return 1;
    }if (section==1) {
        
        return 2;
    }else
    {
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section==0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"personalcell1" forIndexPath:indexPath];
        

        UILabel * nameLab = (UILabel *)[cell viewWithTag:19901];
        UILabel * adminType = (UILabel *)[cell viewWithTag:19902];
        UILabel * phoneNum = (UILabel *)[cell viewWithTag:19903];
        UILabel * areaLab = (UILabel *)[cell viewWithTag:19904];
        
        nameLab.text = [_dataDic valueForKey:@"name"];
        adminType.text = [self adminType:[_dataDic valueForKey:@"type"]];
        phoneNum.text = [_dataDic valueForKey:@"phone"];
        areaLab.text = [_dataDic valueForKey:@"area"];


        
    }else if (indexPath.section==1) {
        
        
        switch (indexPath.row) {
            case 0: {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"personalcell2" forIndexPath:indexPath];
         
            }
                break;
            case 1: {
                cell = [tableView dequeueReusableCellWithIdentifier:@"personalcell4" forIndexPath:indexPath];
                
                UILabel * OrdrNum = (UILabel *)[cell viewWithTag:90142];
                UILabel * OrdrMoney = (UILabel *)[cell viewWithTag:90143];
                
                OrdrNum.text = [_dataDic valueForKey:@"order_count"];
                OrdrMoney.text = [_dataDic valueForKey:@"order_total"];
                
                
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        
        switch (indexPath.row) {
                
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"personalcell3" forIndexPath:indexPath];
                break;
            case 1:{
                cell = [tableView dequeueReusableCellWithIdentifier:@"personalcell6" forIndexPath:indexPath];
                UILabel * label  =(UILabel*)[cell viewWithTag:202021];
                label.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                break;
            }
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:@"personalcell7" forIndexPath:indexPath];
                break;

                
            default:
                break;
        }
    }
    
    // Configure the cell...
    
    return cell;
}



-(NSString*)adminType:(NSString*)str {
    
    if ([str isEqualToString:@"FULL_TIME"]) {
        
        return @"全职着装顾问";
        
    }else if ([str isEqualToString:@"FULL_TIME_MANAGER"]) {
        
        return @"全职着装顾问经理";
        
    }else if ([str isEqualToString:@"PART_TIME"]) {
        
        return @"兼职着装顾问";
        
    }else {
        
        return @"代理商";
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section==0) {
      
        
    }else if (indexPath.section==1){
        
        switch (indexPath.row) {
            case 0: {
                WithdrawalsController * view = [[WithdrawalsController alloc]init];
                view.dataDic = _dataDic;
                [self.navigationController pushViewController:view animated:YES];
            
            }
                
                
                break;
                
            default:
                break;
        }
        
    }else
    {
        switch (indexPath.row) {

            case 0:{

                [self getHttpFabricList];
                
                
            }
                break;
            case 2:
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"主人不要走！" delegate:self cancelButtonTitle:@"转身留下" otherButtonTitles:@"狠心离开", nil];
                [alert show];
                
                
                
            }
               
                break;
                
            default:
                break;
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        return;
    }
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"againLogin"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]synchronize];
    AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appdelegate getrootViewController];
}

- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp)
        
        return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
    
    
}

static float progress = 0.0f;



-(void)getHttpMeberList:(NSString *)pagestr success:(void(^)(BOOL Success))httpSuccess
{
    
    [[ UIApplication sharedApplication] setIdleTimerDisabled:YES];
    NSDictionary * dic = nil;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Roles"]isEqualToString:@"Yes"])
    {
        dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"pageSize":@"20",@"page":pagestr };
        
    }else
    {
        dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"pageSize":@"20",@"page":pagestr,@"uid":[[NSUserDefaults standardUserDefaults] valueForKey:@"adminID"]};
        
    }
    
  
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager POST:MerberList parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        NSLog(@"%@______",uploadProgress);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            
            
            if ([[[responseObject objectForKey:@"data"]valueForKey:@"data"]count]==0) {
                
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstStart"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self getHttpFabricList];
                return ;
            }
            
            NSMutableArray * dataarry = [[NSMutableArray alloc]init];
            for (int i =0; i<[[[responseObject objectForKey:@"data"]objectForKey:@"data"]count]; i++)
            {
                
                
                NSDictionary * dic = [[[responseObject objectForKey:@"data"]objectForKey:@"data"]objectAtIndex:i];
                
                if (![[dic objectForKey:@"phone_number"]isEqual:[NSNull null]])
                {
                    if (![[dic objectForKey:@"name"]isEqual:[NSNull null]]&&[[dic objectForKey:@"name"]length]!=0)
                    {

                        [dataarry addObject:@{@"name":[dic objectForKey:@"name"],@"phone_number":[dic objectForKey:@"phone_number"],@"consignee_address":[dic objectForKey:@"consignee_address"]}];
                    }else
                    {
                        [dataarry addObject:@{@"name":@"暂无姓名",@"phone_number":[dic objectForKey:@"phone_number"],@"consignee_address":[dic objectForKey:@"consignee_address"]}];
                    }
                    
                    
                }
                
            }
            
            NSDictionary* memberImgdic =[[responseObject objectForKey:@"data"]objectForKey:@"memberImg"];
            NSMutableArray * muatarry = [[NSMutableArray alloc]init];
            
            for (int i =0; i<[[memberImgdic allKeys]count]; i++) {
                
                for (int j=0; j< [[memberImgdic valueForKey:[[memberImgdic allKeys] objectAtIndex:i]]count]; j++) {
                    
                    
                    
                    [muatarry addObject: [[memberImgdic valueForKey:[[memberImgdic allKeys] objectAtIndex:i]]objectAtIndex:j]];
                    
                }
                
                
            }
            
            NSLog(@"图片名称-----%@",muatarry);
            
            
            if ([LYFmdbTool insertMember2:[[responseObject objectForKey:@"data"]objectForKey:@"data"]]) {
                
                
                if ([LYFmdbTool insertMemberName:dataarry])
                {
                    if (muatarry.count !=0)
                    {
                        if ([LYFmdbTool insertImageName2 :muatarry del:NO])
                        {
                            
                            
                        }
                        
                    }

                }
                
                _currentPage =[[[[responseObject valueForKey:@"data"] valueForKey:@"pager"]valueForKey:@"page"]intValue];
                _maxPage =[[[[responseObject valueForKey:@"data"] valueForKey:@"pager"]valueForKey:@"pageCount"]intValue];
                progress =  (float)_currentPage/(float)_maxPage;
                
                
                [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"系统配置中,请不要退出或中断网络 进度:%.0f%%",progress*100]];
                
                double delayInSeconds1 = 2.0;
                dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds1 * NSEC_PER_SEC);
                dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                    
                    
                    if (_currentPage!=_maxPage) {
                        
                        [self getHttpMeberList:[NSString stringWithFormat:@"%ld",(long)_currentPage+1]success:^(BOOL Success) {
                            
                            
                        }];
                    }else
                    {
                        [SVProgressHUD showSuccessWithStatus:@"全部数据更新成功"];
                        [self getHttpFabricList];
                        _NoNetwork = NO;
                        
                    
                        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstStart"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
         
                       [[NSNotificationCenter defaultCenter]postNotificationName:@"MeberList" object:nil];
                        
                    }
                    
                });
                
            }else
            {
                
            }
            
            
            
            
            NSLog(@"%@--姓名数据",dataarry);
            
            
        
            
        }else
        {
            
        }
        
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"Error: %@",  [error.userInfo valueForKey:@"NSLocalizedDescription"]);
        if ([[error.userInfo valueForKey:@"NSLocalizedDescription"]isEqualToString:@"似乎已断开与互联网的连接。"])
        {
            
            _NoNetwork = YES;
            [SVProgressHUD showErrorWithStatus:@"似乎已断开与互联网的连接,请点击同步按钮继续更新!"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        }

    }];
    
    
      [[ UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
}


-(void)getHttpFabricList
{
    [SVProgressHUD show];
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"pageSize":@"500"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager POST:fabricList parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            
            if ([LYFmdbTool fabricListdb:[[responseObject objectForKey:@"data"]objectForKey:@"data"]del:YES]) {
                
                [SVProgressHUD showSuccessWithStatus:@"同步面料信息成功!"];
            }
            
            
            
        }if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:-1]])
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            [appdelegate getrootViewController];
            
            
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
    
    [self getHttpUserList];
}


-(void)getHttpUserList {
    
    
    
    [SVProgressHUD show];
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager POST:UserList parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            [LYFmdbTool dropDB:@"UserList"];
            
            if ([LYFmdbTool userList:[[responseObject objectForKey:@"data"]objectForKey:@"data"]]) {
                
                [SVProgressHUD showSuccessWithStatus:@"同步系统配置信息成功!"];
            }
            
            
            
        }if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:-1]])
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Token"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            [appdelegate getrootViewController];
            
            
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
}



-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalController"];
    }
    return self;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
