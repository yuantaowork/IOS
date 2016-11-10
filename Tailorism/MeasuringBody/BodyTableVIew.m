//
//  BodyTableVIew.m
//  Tailorism
//
//  Created by LIZhenNing on 16/7/13.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "BodyTableVIew.h"
#import "BodyTableViewCell.h"
#import "TimeModel.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "BodyDetailsController.h"
#import "adminBodyTableViewCell.h"
#import "UserNameController.h"
@interface BodyTableVIew()

@property (nonatomic, strong) NSTimer        *m_timer;
@property (nonatomic, strong) NSMutableArray *m_dataArray;
@property (nonatomic, strong) NSArray        *allDataArray;
@property (nonatomic, strong) UIViewController * superController;
@property bodyType  bodytype;


@end
@implementation BodyTableVIew


- (id)initWithFrame:(CGRect)frame type:(bodyType)type controller:(id)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.tag=type;
        _tableView.backgroundColor = [UIColor colorWithHex:@"F5F5F5"];
        _tableView.delegate = self;
        _tableView.frame = CGRectMake(0, 0,CGRectGetWidth(frame), CGRectGetHeight(frame)-(64+44));
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
         [_tableView registerNib:[UINib nibWithNibName:@"BodyTableViewCell" bundle:nil] forCellReuseIdentifier:@"BodyTableViewCell"];
         [_tableView registerNib:[UINib nibWithNibName:@"adminBodyTableViewCell" bundle:nil] forCellReuseIdentifier:@"adminBodyTableViewCell"];

      
        
//        self.m_dataArray = @[[TimeModel time:21],
//                             [TimeModel time:31],
//                             [TimeModel time:31],
//                             [TimeModel time:12],
//                             [TimeModel time:11],
//                             [TimeModel time:31],
//                             [TimeModel time:60],
//                             [TimeModel time:31],
//                             [TimeModel time:50],
//                             [TimeModel time:31]
//                             ];

        
        _superController = controller;
        
        _bodytype = type;
        
//        if (type ==0)
//        {
//            [self createTimer];
//        }

    }
    
    return self;
}


//倒计时创建
- (void)createTimer {
    
    if (self.m_timer !=nil) {
        
        [self.m_timer invalidate];
        self.m_timer = nil;
    }
    self.m_timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_m_timer forMode:NSRunLoopCommonModes];
}


//倒计时方法
- (void)timerEvent {
    
    int RepNum = 0; //用于判断时间倒计时多个为0重复数量
    
    for (int count = 0; count < _m_dataArray.count; count++) {
        
        TimeModel *model = _m_dataArray[count];
        [model countDown];
        
        
        NSIndexPath *inde = [NSIndexPath indexPathForRow:0 inSection:count];
        BodyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:inde];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@",[model currentTimeString]];
        
        if (model.m_countNum==0) {
            
           RepNum = RepNum+1;
            
            //全部为0后停止计时
            if (RepNum==_m_dataArray.count) {
                
                [_m_timer invalidate];
                _m_timer = nil;
            }
            
        }
        
    }
    
}

#pragma mark -- tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Roles"]isEqualToString:@"Yes"])
        {
            return 2;
        }else
        {
            return 1;
        }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return _allDataArray.count;

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * tablecell;
    
    if (indexPath.row==0)
    {
        BodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BodyTableViewCell" forIndexPath:indexPath];
        
        TimeModel * model = nil;
        if (_m_dataArray.count==0) {
            
            model = [TimeModel time:0];
        }else
        {
            model = _m_dataArray[indexPath.row];
        }
        
        
        if (_bodytype==0)
        {
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",[model currentTimeString]];
            cell.timeTile.text = @"剩余处理时间:";
            
        }else {
            
            cell.timeTile.text = @"具体上门时间:";
            cell.timeLabel.textColor = [UIColor darkGrayColor];
            cell.timeLabel.text = [self datestr:[[_allDataArray objectAtIndex:indexPath.section]valueForKey:@"measure_time"]];
        }
        
        
        
        cell.nameLabel.text = [[_allDataArray objectAtIndex:indexPath.section]valueForKey:@"name"];
        cell.address.text = [[_allDataArray objectAtIndex:indexPath.section]valueForKey:@"measure_address"];
        cell.coftimeLabel.text = [self datestr:[[_allDataArray objectAtIndex:indexPath.section]valueForKey:@"add_time"]];
        cell.statusLabel.text = [self nullStr:[[_allDataArray objectAtIndex:indexPath.section]valueForKey:@"status"]];
        cell.phoneLable.text = [[_allDataArray objectAtIndex:indexPath.section]valueForKey:@"phone"];
        [cell.callButton addTarget:self action:@selector(callButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.address scrollRangeToVisible:NSMakeRange([cell.address.text length], 5)];
        cell.callButton.tag = indexPath.section;
        if (_bodytype==1) {
        
          
            
            if ([[[_allDataArray objectAtIndex:indexPath.section]valueForKey:@"arrive_time"]isKindOfClass:[NSNull class]]) {
                
                [cell.callButton setTitle:@"开始量体" forState:UIControlStateNormal];
//                cell.statusLabel.text =@"开始量体";
                
            }else
            {
                cell.statusLabel.text  = @"开始量体";
                [cell.callButton setTitle:@"量体完成" forState:UIControlStateNormal];
            }
            
            
            if ([[[_allDataArray objectAtIndex:indexPath.section]valueForKey:@"status"]isEqualToString:@"COMPLETED"]) {
             
                cell.statusLabel.text  = @"已完成";
                [cell.callButton setTitle:@"已完成" forState:UIControlStateNormal];
                cell.callButton.enabled = NO;
            }
        }
        

        
        tablecell=cell;
    }else
    {
         adminBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adminBodyTableViewCell" forIndexPath:indexPath];
        cell.adminName.text = [self Nallstring:[[_allDataArray objectAtIndex:indexPath.section]valueForKey:@"staff_name"]];
        cell.adminBtn.tag = indexPath.section;
        [cell.adminBtn addTarget:self action:@selector(distribution:) forControlEvents:UIControlEventTouchUpInside];
         tablecell =cell;
        
        if (_bodytype==1)
        {
            cell.adminBtn.hidden =YES;
        }
    }
    

    
    return tablecell;
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
-(void)callButton:(UIButton*)btn
{


     [SVProgressHUD show];

    if (_bodytype==0) {
        
        NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:btn.tag];
        BodyTableViewCell * cell = [self.tableView cellForRowAtIndexPath:index];
        if ([cell.timeLabel.text isEqualToString:@"00:00"]) {
            
            [SVProgressHUD showInfoWithStatus:@"由于时效内未处理,系统已分配给其他人"];
            return;
        }
        
        [self getHttpMeasureProcess:@{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"measure_id":[[_allDataArray objectAtIndex:btn.tag] valueForKey:@"id"],@"status":@"CONTACTED"}];
      
    }else {
        
        
        if ([btn.titleLabel.text isEqualToString:@"开始量体"]) {
            
            NSDate * today = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMTForDate:today];
            NSDate *localeDate = [today dateByAddingTimeInterval:interval];
            NSLog(@"%@", localeDate);
            // 时间转换成时间戳
            NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
            NSLog(@"timeSp : %@", timeSp);
            
            
            [self getHttpMeasureProcess:@{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"measure_id":[[_allDataArray objectAtIndex:btn.tag] valueForKey:@"id"],@"arrive_time":timeSp}];
            
        }else if ([btn.titleLabel.text isEqualToString:@"量体完成"]) {
            
            [self getHttpMeasureProcess:@{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"measure_id":[[_allDataArray objectAtIndex:btn.tag] valueForKey:@"id"],@"status":@"COMPLETED"}];
            
        }
        

        
    }


}


-(void)distribution:(UIButton *)btn
{
    
    
    UserNameController * username = [[UserNameController alloc]init];
    username.bodyDataDic = [_allDataArray objectAtIndex:btn.tag];
    [_superController.navigationController pushViewController:username animated:YES];
    

}


-(void)getHttpMeasureProcess:(NSDictionary*)dic
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager POST:measureProcess parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            [SVProgressHUD dismiss];
            
            if (_bodytype ==0)
            {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[responseObject objectForKey:@"data"] valueForKey:@"phone"]];
                
                NSLog(@"str======%@",str);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
          
            }
            NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"BodyController" object:nil];
//            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"10086"];


        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        
    }];
    
    
}



-(NSString*)nullStr:(id)str
{
    if ([str isKindOfClass:[NSNull class]])
    {
        return @"";
        
    }else if ([str isEqualToString:@"CONTACTED"])
    {
        return @"已联系";
        
    }else if ([str isEqualToString:@"CONFIRMED"])
    {
        return @"等待量体";
        
    }else
    {
        return @"未联系";
    }
}

-(NSString *)datestr :(NSNumber * )str;
{
    NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:[str longLongValue]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy/MM/dd HH:ss:mm"];
    NSString *currentDateStr2 = [dateFormatter2 stringFromDate:confromTimesp2];
    
    return currentDateStr2;
}

-(void)getHttpData:(NSArray *)dataArry
{
    self.m_dataArray = [[NSMutableArray alloc]init];
    NSMutableArray * newdataArray = [[NSMutableArray alloc]init];
    NSMutableArray * startdataArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<dataArry.count; i++)
    {
        
        if ([[[dataArry objectAtIndex:i]valueForKey:@"status"]isKindOfClass:[NSString class]]) {
            
            if ([[dataArry[i]valueForKey:@"status"]isEqualToString:@"CONFIRMED"]) {
                
                [startdataArray addObject:dataArry[i]];
                
            }else
            {
                [newdataArray addObject:dataArry[i]];
            }
        }
    }

    
    
    
    if (_bodytype==0) {
        
        _allDataArray = [NSArray arrayWithArray:newdataArray];
    
        for (int num=0; num<_allDataArray.count; num++)
        {
            
            NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[[[_allDataArray objectAtIndex:num]valueForKey:@"update_time"]longLongValue]];
            //            NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:1469764200];
            //            NSDate *add90Min = [date2 dateByAddingTimeInterval:(10*60)];
            
            int num =  [[[NSUserDefaults standardUserDefaults]valueForKey:@"SettingsNum"]intValue];
            NSDate *newdate = [[NSDate date] initWithTimeInterval:60 * num sinceDate:date2];
            NSLog(@"%f",[newdate timeIntervalSinceNow]);
            
            
            
            NSDate * responseTimeInterval = [NSDate dateWithTimeIntervalSince1970:[newdate timeIntervalSinceNow]];
            
            NSLog(@"%@",responseTimeInterval );
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
            NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *comps  = [calendar components:unitFlags fromDate:responseTimeInterval];
            
            int min = (int)[comps minute];
            int sec = (int)[comps second];

            
            NSLog(@"%d,%d",min,sec);
            
            if ([newdate timeIntervalSinceNow]<=0)
            {
                
                 [_m_dataArray addObject:[TimeModel time:0]];
            }else
            {
//
                 [_m_dataArray addObject:[TimeModel time:min*60+sec]];
                
            }
           
        }
        
         [self createTimer];
    }else
    {
        _allDataArray = [NSArray arrayWithArray:startdataArray];
        
    }



    
    [_tableView reloadData];
}

#pragma mark -- table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        return 170;
    }else
    {
        return 40;
    }
    
   
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
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (0 == row) {
        
        if (_bodytype==0) {
            
            if ([[[_allDataArray objectAtIndex:indexPath.section]valueForKey:@"status"]isEqualToString:@"CONTACTED"]) {
                
                BodyDetailsController * view = [[BodyDetailsController alloc]init];
                view.dataDic = [_allDataArray objectAtIndex:indexPath.section];
                [_superController.navigationController pushViewController:view animated:YES];
                
            }else
            {
                BodyTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                
                if ([cell.timeLabel.text isEqualToString:@"00:00"]) {
                    
                    [SVProgressHUD showInfoWithStatus:@"由于时效内未处理,系统已分配给其他人"];
                    
                }
                
            }
            
        }
        
    }
    
}


@end
