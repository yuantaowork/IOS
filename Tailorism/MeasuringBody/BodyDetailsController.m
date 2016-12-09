//
//  BodyDetailsController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/7/15.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "BodyDetailsController.h"

@interface BodyDetailsController ()<UITextFieldDelegate>

@property(strong,nonatomic)UITextField * textField;
@property(strong,nonatomic)UITextView * textView;
@end

@implementation BodyDetailsController

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        
        return 64;
    }else {
        
        return 130;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section==0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"BodyDetailsCell1" forIndexPath:indexPath];
        UILabel * nameLable = [cell viewWithTag:17801];
        UILabel * phoneLable = [cell viewWithTag:17802];
        UILabel * addressLable = [cell viewWithTag:17803];
        UILabel * timeLable = [cell viewWithTag:17804];
        
        nameLable.text = [_dataDic valueForKey:@"name"];
        phoneLable.text = [_dataDic valueForKey:@"phone"];
        addressLable.text = [_dataDic valueForKey:@"measure_address"];
        timeLable.text = [self datestr:[_dataDic valueForKey:@"add_time"]];
        
    }else if (indexPath.section==1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"BodyDetailsCell2" forIndexPath:indexPath];
        
        _textField = [cell viewWithTag:178902];
        _textField.delegate =self;
        
        
        _textView = [cell viewWithTag:178901];
        _textView.layer.borderColor = [UIColor colorWithHex:@"C9C9C9"].CGColor;
        _textView.layer.borderWidth = .5;
        _textView.layer.cornerRadius = 5;
        _textView.layer.masksToBounds = YES;
    
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BodyDetailsCell3" forIndexPath:indexPath];
        
    }
    
    // Configure the cell...
    
    return cell;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self datePicker:textField];
    return NO;
}
- (IBAction)doneBtn:(UIButton *)sender {
    
    if ([_textField.text length]==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请选择预约上门时间"];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate * measuredate = [formatter dateFromString:_textField.text];
    NSString *measuretimeSp = [NSString stringWithFormat:@"%ld", (long)[measuredate timeIntervalSince1970]];
    
    if ([_textView.text length]>0)
    {
         [self getHttpMeasureProcess:@{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"measure_id":[_dataDic valueForKey:@"id"],@"status":@"CONFIRMED",@"time":measuretimeSp,@"address":_textView.text}];
    }else
    {
        [self getHttpMeasureProcess:@{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"measure_id":[_dataDic valueForKey:@"id"],@"status":@"CONFIRMED",@"time":measuretimeSp}];
    }
    
    
    
    
}


-(void)getHttpMeasureProcess:(NSDictionary*)dic
{
    
    [SVProgressHUD show];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:measureProcess parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            [SVProgressHUD dismiss];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        
    }];
}




-(void)datePicker:(UITextField*)textField
{
    
    
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    picker.frame = CGRectMake(0, 40, 320, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择 与客户预约量体 时间\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        
        //        dateLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];;
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Asia/Shanghai"]];
        [dateformatter setDateFormat:@"yyyy/MM/dd hh:mm"];
        NSString *  locationString=[dateformatter stringFromDate:date];
        
        textField.text = locationString;
        
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(NSString *)datestr :(NSNumber * )str;
{
    NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:[str longLongValue]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy/MM/dd HH:ss:mm"];
    NSString *currentDateStr2 = [dateFormatter2 stringFromDate:confromTimesp2];
    
    return currentDateStr2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BodyDetailsController"];
    }
    return self;
}




@end
