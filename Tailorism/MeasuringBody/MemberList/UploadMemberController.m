//
//  UploadMemberController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/6/21.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "UploadMemberController.h"

@interface UploadMemberController ()
@property(strong,nonatomic)NSArray * dataArry;
@property(strong,nonatomic)NSMutableArray * tabledataArry;
@property(strong,nonatomic)NSMutableArray  * imageArry;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;


@end

@implementation UploadMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem =_doneButton;
    _imageArry = [[NSMutableArray alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"待上传客户列表";
    
}
- (IBAction)doneButton:(UIBarButtonItem *)sender {

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
            [dic removeObjectForKey:@"image1"];
            [dic removeObjectForKey:@"image2"];
            [dic removeObjectForKey:@"image3"];
            
            NSMutableDictionary * mutdic = [[NSMutableDictionary alloc]init];
            
            
            for (int i = 0; i<[dic allKeys].count; i++) {
                
                if ([[dic objectForKey:[[dic allKeys] objectAtIndex:i]]length]!=0)
                {
                    [mutdic addEntriesFromDictionary:@{[[dic allKeys]objectAtIndex:i]:[dic objectForKey:[[dic allKeys] objectAtIndex:i]]}];
                }
                
            }
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:memberAdd parameters:mutdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                NSLog(@"JSON: %@", responseObject);
                
                
                
                if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
                {
                    
                    
                    if ([LYFmdbTool insertMemberName2:@[@{@"name":[mutdic objectForKey:@"name"],@"phone_number":[mutdic objectForKey:@"phone"],@"consignee_address":[mutdic objectForKey:@"consignee_address"]}]])
                    {
                        
                        NSLog(@"上传成功,插入会员信息数据");
                    }
                    
                    [mutdic addEntriesFromDictionary:@{@"phone_number":[mutdic objectForKey:@"phone"]}];
                    [mutdic removeObjectForKey:@"phone"];
                    [mutdic addEntriesFromDictionary:@{@"id": [responseObject valueForKey:@"data"]}];
                    
                    if ([LYFmdbTool insertMember2:@[mutdic]])
                    {
                        NSLog(@"上传成功,插入姓名列表数据");
                    }
                    
                    
                    if ([LYFmdbTool deleteDB:[NSString stringWithFormat:@"upload_t_member WHERE phone =\"%@\"",[mutdic valueForKey:@"phone_number"]]]) {
                        
                        
                        NSLog(@"上传成功,删除该条上传数据");
                        
                        [_tabledataArry removeObject:[_dataArry objectAtIndex:i]];
                        [self.tableView reloadData];
                        
                        UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
                        item.badgeValue=[NSString stringWithFormat:@"%ld",(long)[[LYFmdbTool queryData:@"upload_t_member"]count]+(long)[[LYFmdbTool queryData:@"upload_Order"]count]];
                        if ([item.badgeValue isEqualToString:@"0"])
                        {
                            item.badgeValue =nil;
                        }
                        
                    }
                    
                    
                    if ([[[_dataArry objectAtIndex:i] valueForKey:@"image1"]length]!=0)
                    {
                        [_imageArry addObject:@{@"name":[mutdic objectForKey:@"name"],@"phone":[mutdic valueForKey:@"phone_number"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"member_id": [mutdic valueForKey:@"id"],@"type":@"1",@"imageName":[[_dataArry objectAtIndex:i] valueForKey:@"image1"]}];
                    }
                    if ([[[_dataArry objectAtIndex:i] valueForKey:@"image2"]length]!=0)
                    {
                        [_imageArry addObject:@{@"name":[mutdic objectForKey:@"name"],@"phone":[mutdic valueForKey:@"phone_number"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"member_id": [mutdic valueForKey:@"id"],@"type":@"2",@"imageName":[[_dataArry objectAtIndex:i] valueForKey:@"image2"]}];
                    }
                    if ([[[_dataArry objectAtIndex:i] valueForKey:@"image3"]length]!=0)
                    {
                        [[_dataArry objectAtIndex:i] addObject:@{@"name":[mutdic objectForKey:@"name"],@"phone":[mutdic valueForKey:@"phone_number"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"member_id": [mutdic valueForKey:@"id"],@"type":@"3",@"imageName":[[_dataArry objectAtIndex:i] valueForKey:@"image3"]}];
                    }
                    if (_imageArry.count!=0)
                    {
                         [self uplodimage];
                    }
                   
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"第%d条数据上传成功",i+1]];
                    
                    
                }else if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:-1]])
                {
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Token"];
                    AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                    [appdelegate getrootViewController];
                    
                    
                    
                }else
                {
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"第%d条数据上传失败",i]];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"Error: %@",  error);
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
            }];

            
        });
        
        

    }
    

    
    
}



-(void)uplodimage
{
    
    dispatch_queue_t queue = dispatch_queue_create("uplodmember1", DISPATCH_QUEUE_SERIAL);
    
    for (int i =0; i<_imageArry.count; i++) {
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageArry objectAtIndex:i]valueForKey:@"imageName"]];   // 保存文件的名称
        UIImage *img = [UIImage imageWithContentsOfFile:filePath];
        
        NSMutableDictionary * dic  = [[NSMutableDictionary alloc]init];
        [dic addEntriesFromDictionary:[_imageArry objectAtIndex:i]];
        [dic removeObjectForKey:@"imageName"];
        
        dispatch_barrier_async(queue, ^{
            
            
            
            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:appUpload parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                
                
                NSData *data = UIImageJPEGRepresentation([self normalizedImage:img],0.2);
                [formData appendPartWithFileData:data name:@"upload" fileName:@"upload.png" mimeType:@"image/png"];
                
            } error:nil];
            
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSURLSessionUploadTask *uploadTask;
            uploadTask = [manager
                          uploadTaskWithStreamedRequest:request
                          progress:^(NSProgress * _Nonnull uploadProgress) {
                              // This is not called back on the main queue.
                              // You are responsible for dispatching to the main queue for UI updates
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  //Update the progress view
                                  //                          [progressView setProgress:uploadProgress.fractionCompleted];
                                  
                              });
                          }
                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                              if (error) {
                                  NSLog(@"Error: %@", error);
                                  [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
                                  
                              } else {
                                  
                                  //                                  NSLog(@"%@ %@", response, responseObject);
                                  
                                  NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                                  NSLog(@"%@", content);
                                  
                                  
                                  if ([LYFmdbTool insertImageName2:@[@{@"id":@"",@"m_id":[dic valueForKey:@"member_id"],@"name":[[content valueForKey:@"data"]valueForKey:@"file"],@"type":[dic valueForKey:@"type"]}]del:NO] ) {
                                      
                                      
                                  }
                                  
                                  
                                  NSString *filePath1 = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[content valueForKey:@"data"]valueForKey:@"file"]];   // 保存文件的名称
                                  [UIImageJPEGRepresentation(img,0.2) writeToFile:filePath1 atomically:YES];
                                  
                                  NSFileManager* fileManager=[NSFileManager defaultManager];
                                  [fileManager removeItemAtPath:filePath error:nil];
                                  
                                 
                                  
                              }
                          }];
            
            [uploadTask resume];
            
        });
        
    }

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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _dataArry = [NSArray arrayWithArray:[LYFmdbTool queryData:@"upload_t_member"]];
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
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"uplodcell" forIndexPath:indexPath];
    UILabel * namelabel = (UILabel *)[cell viewWithTag:87601];
    UILabel * tellabel = (UILabel *)[cell viewWithTag:87602];
    
    namelabel.text = [self Nallstring:[[_tabledataArry objectAtIndex:indexPath.row]valueForKey:@"name"]];
    tellabel.text = [self Nallstring:[[_tabledataArry objectAtIndex:indexPath.row]valueForKey:@"phone"]];
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
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UploadMemberController"];
    }
    return self;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

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
