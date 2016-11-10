//
//  EarningsRecordController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/8/11.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "EarningsRecordController.h"

@interface EarningsRecordController ()

@property (strong ,nonatomic)NSArray * dataArry;

@end

@implementation EarningsRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self getHttpstaffWithdraw];
    
}
#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56;
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!_dataArry) {
        return 0;
    }
    return _dataArry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;

        cell = [tableView dequeueReusableCellWithIdentifier:@"EarningsRecordCell" forIndexPath:indexPath];
    
        if (indexPath.row!=0) {
            
//            moneyLab.text = [[_historyArry objectAtIndex:indexPath.row-1]valueForKey:@"amount"];
//            timeLab.text = [[_historyArry objectAtIndex:indexPath.row-1]valueForKey:@"create_time"];
//            statusLab.text = [self statusType:[[_historyArry objectAtIndex:indexPath.row-1]valueForKey:@"status"]];
            
            
            NSString *str=[[_dataArry objectAtIndex:indexPath.row-1]valueForKey:@"create_time"];//时间戳
            NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            NSLog(@"date:%@",[detaildate description]);
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
            
            
            UILabel * orderTime = (UILabel *)[cell viewWithTag:891090];
            UILabel * memberName = (UILabel *)[cell viewWithTag:891091];
            UILabel * orderMoney = (UILabel *)[cell.contentView viewWithTag:891092];
            UILabel * yongOrder = (UILabel *)[cell.contentView viewWithTag:891093];
            
            orderTime.text = currentDateStr;
            memberName.text = [[_dataArry objectAtIndex:indexPath.row-1]valueForKey:@"name"];
            orderMoney.text = [[_dataArry objectAtIndex:indexPath.row-1]valueForKey:@"order_total"];
            
            NSString * yong = [[_dataArry objectAtIndex:indexPath.row-1]valueForKey:@"order_reward"];
            
            yongOrder.text = yong;
        }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


-(void)getHttpstaffWithdraw
{
    
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"user_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"],@"reward_type":@"ORDER"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET: rewardHistoryList parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            _dataArry = [[responseObject objectForKey:@"data"]valueForKey:@"data"];
            
            self.tableView.delegate  = self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
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
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EarningsRecordController"];
    }
    return self;
}



@end
