//
//  UploadOrderController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/6/23.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "UploadOrderController.h"

@interface UploadOrderController ()
@property(strong,nonatomic)NSArray * dataArry;
@property(strong,nonatomic)NSMutableArray * tabledataArry;
@property(strong,nonatomic)NSMutableArray  * imageArry;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation UploadOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem =_doneButton;
    _imageArry = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"待上传订单列表";
    
}

- (IBAction)doneButton:(UIBarButtonItem *)sender {
    
    if ([[LYFmdbTool queryData:@"upload_t_member"]count]!=0)
    {
        [SVProgressHUD showInfoWithStatus:@"请先同步客户信息!!!"];
        return;
    }
    
    if (_dataArry.count==0)
    {
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("uplodmember", DISPATCH_QUEUE_SERIAL);
    
    for (int i = 0; i<_dataArry.count; i++)
    {
        
        dispatch_barrier_async(queue, ^{
            
            //block具体代码
            [SVProgressHUD show];
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
            [dic addEntriesFromDictionary:[_dataArry objectAtIndex:i]];
        
            
            NSMutableDictionary * mutdic = [[NSMutableDictionary alloc]init];
            
            
            for (int i = 0; i<[dic allKeys].count; i++) {
                
                if ([[dic objectForKey:[[dic allKeys] objectAtIndex:i]]length]!=0)
                {
                    [mutdic addEntriesFromDictionary:@{[[dic allKeys]objectAtIndex:i]:[dic objectForKey:[[dic allKeys] objectAtIndex:i]]}];
                }
                
            }
            ;
            NSArray * arry = [LYFmdbTool queryData2:[NSString stringWithFormat:@"t_member WHERE phone_number = \"%@\"",[dic valueForKey:@"phoneNumber"]]];
            
            
            [mutdic addEntriesFromDictionary:@{@"id":[[arry objectAtIndex:i]valueForKey:@"id"]}];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:OrdersAdd parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                NSLog(@"JSON: %@", responseObject);
                
                if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
                {
                    
                    
                    [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
//                    [self performSelector:@selector(getPopViewController) withObject:nil afterDelay:2.f];
                    
                    if ([LYFmdbTool deleteDB:[NSString stringWithFormat:@"upload_Order WHERE phoneNumber =\"%@\"",[dic valueForKey:@"phoneNumber"]]]) {
                        
                        
                        NSLog(@"上传成功,删除该条上传数据");
                        
                        [_tabledataArry removeObject:[_dataArry objectAtIndex:i]];
                        [self.tableView reloadData];
                        
                        UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
                        item.badgeValue=[NSString stringWithFormat:@"%ld",(long)[[LYFmdbTool queryData:@"upload_t_member"]count]+(long)[[LYFmdbTool queryData:@"upload_Order"]count]];
                        if ([item.badgeValue isEqualToString:@"0"])
                        {
                            item.badgeValue =nil;
                        }
                        
                    }else
                    {
                         NSLog(@"失败!!!!!!!!!!,删除该条上传数据");
                    }
                    
                }else
                {
                    
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"Error: %@",  error);
                
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
            }];
            
            
        });
        
 
        
    }
    
    
  
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _dataArry = [NSArray arrayWithArray:[LYFmdbTool queryData:@"upload_Order"]];
    
    _tabledataArry =[NSMutableArray arrayWithArray:_dataArry];
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _tabledataArry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"uplodordercell" forIndexPath:indexPath];
    UILabel * namelabel = (UILabel *)[cell viewWithTag:87601];
    UILabel * tellabel = (UILabel *)[cell viewWithTag:87602];
    
    namelabel.text = [self Nallstring:[[_tabledataArry objectAtIndex:indexPath.row]valueForKey:@"name"]];
    tellabel.text = [self Nallstring:[[_tabledataArry objectAtIndex:indexPath.row]valueForKey:@"phoneNumber"]];
    return cell;
}
-(NSString *)Nallstring:(id)str {
    
    if ([str isEqual:[NSNull null]])
    {
        return @"";
    }else
    {
        return str;
    }
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UploadOrderController"];
    }
    return self;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
