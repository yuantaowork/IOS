//
//  UserNameController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/7/20.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "UserNameController.h"

@interface UserNameController ()

@property(strong,nonatomic)NSArray * dataArry;

@end

@implementation UserNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title  = @"选择被指派人";
    
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    _dataArry = [[NSArray alloc]initWithArray:[NSArray arrayWithArray:[LYFmdbTool queryData2:@"UserList"]]];
    [self.tableView reloadData];
    
}


#pragma mark -- table view delegate



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArry.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"usernamecell" forIndexPath:indexPath];

    cell.textLabel.text = [self Nallstring:[[_dataArry objectAtIndex:indexPath.row]valueForKey:@"name"]];
    
    return cell;
}

-(NSString *)Nallstring:(id)str {
    
    
    if ([str isEqual:[NSNull null]])
    {
        return @"暂无名字";
    }else
    {
        return str;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

     [self getHttpMeasureProcess:@{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"measure_id":[_bodyDataDic  valueForKey:@"id"],@"member_id":[[_dataArry objectAtIndex:indexPath.row]valueForKey:@"id"]}];
    
}


-(void)getHttpMeasureProcess:(NSDictionary*)dic
{
    
    //    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"member_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:measureAssign parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSLog(@"JSON: %@", responseObject);
        
//        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];//转换数据格式
//        NSLog(@"%@", content);
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"指派成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        
    }];
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserNameController"];
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
