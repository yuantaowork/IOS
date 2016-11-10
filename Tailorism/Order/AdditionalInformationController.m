//
//  AdditionalInformationController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/6/29.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "AdditionalInformationController.h"
#import "ConfirmOrderController.h"
#import "MemberModel.h"
#import "OrderModel.h"
#import "MemberType.h"
@interface AdditionalInformationController ()<UITextFieldDelegate>
@property (strong,nonatomic)LYUITextField * saleNameText; //销售人员
@property (strong,nonatomic)LYUITextField * payTypeText;  //支付方式
@property (strong,nonatomic)LYUITextField * discountText; //打折金额
@property (strong,nonatomic)LYUITextField * discountRemarkText; //打折原因
@property (strong,nonatomic)LYUITextField * invoiceText; //发票
@property (strong,nonatomic)LYUITextField * measureTimeText; //量体时间
@property (strong,nonatomic)LYUITextField * serviceEndTimeText; //结束时间
@property (strong,nonatomic)LYUITextField * expressNote; //结束时间


@end

@implementation AdditionalInformationController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
    
}
- (IBAction)nextButton:(UIButton *)sender {
    
    if ([_payTypeText.text length]==0) {
        
        [SVProgressHUD showInfoWithStatus:@"有必填项未填写"];
        return;
    }
    
    if ([_discountText.text length]>0) {
        
        if ([_discountRemarkText.text length]==0) {
            
            [SVProgressHUD showInfoWithStatus:@"填写打折金额后,打折原因必须填写"];
            return;
        }
    }

//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
//     NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//     [formatter setTimeZone:timeZone];
//    
//    NSDate * measuredate = [formatter dateFromString:_measureTimeText.text];
//    NSString *measuretimeSp = [NSString stringWithFormat:@"%ld", (long)[measuredate timeIntervalSince1970]];
//    
//    NSDate * serviceEndDate = [formatter dateFromString:_serviceEndTimeText.text];
//    NSString *serviceEndSp = [NSString stringWithFormat:@"%ld", (long)[serviceEndDate timeIntervalSince1970]];
    
    
    NSDictionary * dic = @{@"sale_name":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminname"],
                           @"pay_type":[MemberType orderType:[self Nallstring:_payTypeText.text]],
                           @"discount":[self Nallstring:_discountText.text],
                           @"discount_remark":[self Nallstring:_discountRemarkText.text],
                           @"invoice":[self Nallstring:_invoiceText.text],
                           @"express_note":[self Nallstring:_expressNote.text]
                           };
    
    OrderModel * ordermodel = [[OrderModel alloc]init];
    ordermodel = nil;
    //  将字典的 key——value 对 直接转换成对应的模型
    //  对模型的要求，key——value 对 中的 key 值必须在模型中有
    ordermodel = [OrderModel mj_objectWithKeyValues:dic];
    
    
    ConfirmOrderController * view = [[ConfirmOrderController alloc]init];
    view.imagedic = _iamge_dic;
    view.orderdataArry = _orderdataArry;
    [self.navigationController pushViewController:view animated:YES];
    
}

- (void)dateClick:(UITextField*)textfield{
    

    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeTime;
    
    
    if (textfield==_serviceEndTimeText) {
        
        NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
//        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Asia/Shanghai"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate*inputDate = [inputFormatter dateFromString:_measureTimeText.text];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: inputDate];
        NSDate *localeDate = [inputDate  dateByAddingTimeInterval: interval];
        NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([localeDate timeIntervalSinceReferenceDate] + 4*3600+900)];
        
        picker.minimumDate = newDate;
        
        NSLog(@"%@",picker.minimumDate);
        
//        picker.maximumDate = localeDate;
        
    }
    
  
    
    
    picker.frame = CGRectMake(0, 40, 320, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择 开始/结束 时间\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        
        //        dateLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];;
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Asia/Shanghai"]];
        [dateformatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSString *  locationString=[dateformatter stringFromDate:date];
        
        textfield.text = locationString;
        
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(NSString *)Nallstring:(id)str {
    
    
    if ([str isEqual:[NSNull null]]||str==nil)
    {
       
        
        return @"";
    }else
    {
     
        return str;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
        switch (indexPath.row) {
//            case 0:
//                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation1" forIndexPath:indexPath];
//                _saleNameText = (LYUITextField*)[cell.contentView viewWithTag:66770];
//                
//                break;
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation2" forIndexPath:indexPath];
                _payTypeText = (LYUITextField*)[cell.contentView viewWithTag:1214];
                _payTypeText.rightViewMode = UITextFieldViewModeAlways;
                _payTypeText.delegate = self;
                
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation3" forIndexPath:indexPath];
                _discountText = (LYUITextField*)[cell.contentView viewWithTag:66772];
                _discountText.delegate = self;
                break;
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation4" forIndexPath:indexPath];
                _discountRemarkText = (LYUITextField*)[cell.contentView viewWithTag:66773];
                _discountRemarkText.delegate = self;
                break;
            case 3:{
                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation5" forIndexPath:indexPath];
                _invoiceText = (LYUITextField*)[cell.contentView viewWithTag:66774];
                break;
            }
//            case 5:
//                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation6" forIndexPath:indexPath];
//                _measureTimeText = (LYUITextField*)[cell.contentView viewWithTag:66775];
//                _measureTimeText.delegate = self;
//                break;
//            case 6:
//                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation7" forIndexPath:indexPath];
//                _serviceEndTimeText = (LYUITextField*)[cell.contentView viewWithTag:66776];
//                _serviceEndTimeText.delegate = self;
//                break;
            case 4:
                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation8" forIndexPath:indexPath];
                _expressNote = (LYUITextField*)[cell.contentView viewWithTag:66777];
                break;
            case 5:
                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation9" forIndexPath:indexPath];
                break;

                
            default:
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"AdditionalInformation10" forIndexPath:indexPath];
                break;
        }
    // Configure the cell...
    
    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignResponder];
}


-(void)resignResponder
{
    [_saleNameText resignFirstResponder]; //销售人员
    [_payTypeText resignFirstResponder];  //支付方式
    [_discountText resignFirstResponder]; //打折金额
    [_discountRemarkText resignFirstResponder]; //打折原因
    [_invoiceText resignFirstResponder]; //发票
    [_measureTimeText resignFirstResponder]; //量体时间
    [_serviceEndTimeText resignFirstResponder]; //结束时间
    [_expressNote resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self resignResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_measureTimeText==textField||_serviceEndTimeText==textField) {
       
        if (_serviceEndTimeText==textField) {
            
            if ([_measureTimeText.text length]==0) {
                
                [SVProgressHUD showInfoWithStatus:@"请先选择上门时间"];
                return NO;
            }
        }
        
        [self dateClick:textField];
        
    }
    
    
    if (_discountText==textField||_discountRemarkText==textField) {
        
        if (_discountText ==textField) {
            
            return YES;
        }
        
        
        if (_discountRemarkText ==textField) {
            
            if ([_discountText.text length]==0) {
                
                [SVProgressHUD showInfoWithStatus:@"请先填写打折金额"];
                return NO;
            }else
            {
                return YES;
            }
        }
    }
    
    
    return NO;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdditionalInformationController"];
    }
    return self;
}


@end
