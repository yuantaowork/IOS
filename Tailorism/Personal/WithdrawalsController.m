//
//  WithdrawalsController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/8/8.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "WithdrawalsController.h"
#import "EarningsRecordController.h"
@interface WithdrawalsController ()

@property(nonatomic ,strong)NSArray *historyArry;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightButtonItem;

@end

@implementation WithdrawalsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self getHttpstaffWithdrawHistory];
    
}

-(void)getHttpstaffWithdrawHistory
{
    
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"member_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET: staffWithdrawHistory parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            _historyArry = [[responseObject objectForKey:@"data"]valueForKey:@"data"];
            
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
- (IBAction)Withdrawals:(UIButton *)sender {
    
    
    
    [self getHttpstaffWithdraw];
}

-(void)getHttpstaffWithdraw
{
    
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"amount":[_dataDic valueForKey:@"remaining"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST: staffWithdraw parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            NSString * str1  = [NSString stringWithFormat:@"%d",[[_dataDic valueForKey:@"withdraw"]intValue]+[[_dataDic valueForKey:@"remaining"]intValue]];
            [_dataDic setObject:str1 forKey:@"withdraw"];
            [_dataDic setObject:@"0" forKey:@"remaining"];
            [self getHttpstaffWithdrawHistory];
            
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

- (IBAction)pushController:(id)sender {
    
    EarningsRecordController * view = [[EarningsRecordController alloc]init];
    view.order_rate = [_dataDic valueForKey:@"order_rate"];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        return 167;
        
    }else if (indexPath.section==1){
        

        return 167;
        
    }else {
        
        return 56;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        
        return 1;
        
    }if (section==1) {
        
        return 1;
    }else
    {
        return _historyArry.count+1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section==0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"WithdrawalsCell1" forIndexPath:indexPath];
        UILabel * OrderMoney = (UILabel *)[cell viewWithTag:889910];
        UILabel * tiMoney = (UILabel *)[cell viewWithTag:889911];
        UILabel * yongMoney = (UILabel *)[cell viewWithTag:889912];
        UILabel * yiMoney = (UILabel *)[cell viewWithTag:889913];
        UILabel * keMoney = (UILabel *)[cell viewWithTag:889914];
        
        OrderMoney.text = [_dataDic valueForKey:@"order_total"];
        tiMoney.text = [_dataDic valueForKey:@"order_rate"];
        yongMoney.text = [_dataDic valueForKey:@"total_reward"];
        yiMoney.text = [_dataDic valueForKey:@"withdraw"];
        keMoney.text = [_dataDic valueForKey:@"remaining"];
        
        
    }else if (indexPath.section==1) {
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"WithdrawalsCell2" forIndexPath:indexPath];
        UIButton * button = (UIButton *)[cell viewWithTag:12902];
        if ([[_dataDic valueForKey:@"remaining"]intValue]<500) {
            
            button.enabled = NO;
            
        }else {
            
            button.enabled = YES;
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WithdrawalsCell3" forIndexPath:indexPath];
        
        UILabel * moneyLab = (UILabel *)[cell viewWithTag:98790];
        UILabel * timeLab = (UILabel *)[cell viewWithTag:98791];
        UILabel * statusLab = (UILabel *)[cell.contentView viewWithTag:98792];
        
        if (indexPath.row!=0) {
            
            
//            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateStyle:NSDateFormatterMediumStyle];
//            [formatter setTimeStyle:NSDateFormatterShortStyle];
//            [formatter setDateFormat:@"yyyy-MM-dd"];
//            NSDate *date = [formatter dateFromString:[[_historyArry objectAtIndex:indexPath.row-1]valueForKey:@"create_time"]];
//            NSDate *date = [formatter dateFromString:[[_historyArry objectAtIndex:indexPath.row-1]valueForKey:@"create_time"]];
//            NSLog(@"date1:%@",date);  
//            NSString *nowtimeStr = [formatter stringFromDate:date];
            
            NSString *str=[[_historyArry objectAtIndex:indexPath.row-1]valueForKey:@"create_time"];//时间戳
            NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            NSLog(@"date:%@",[detaildate description]);
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
            
            
            moneyLab.text = [[_historyArry objectAtIndex:indexPath.row-1]valueForKey:@"amount"];
            timeLab.text = currentDateStr;
            statusLab.text = [self statusType:[[_historyArry objectAtIndex:indexPath.row-1]valueForKey:@"status"]];
            
        }
        
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


-(NSString*)statusType:(NSString *)str {
    
    if ([str isEqualToString:@"ACCEPTED"]) {
        
        return @"成功";
        
    }else if ([str isEqualToString:@"PENDING"]) {
        
        return @"待确认";
        
    }else {
        
        return @"失败";
    }
    
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WithdrawalsController"];
    }
    return self;
}

@end
