//
//  OrderViewController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/10.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "OrderViewController.h"
#import "LYUITextField.h"
#import "OrderEntryViewController.h"
#import "LYCheckBoxButton.h"
#import "ClothingViewController.h"
#import "MemberType.h"
#import "MemberModel.h"
@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *OrderTabelView;
@property (weak,nonatomic)LYUITextField * nameTextField;
@property (weak,nonatomic)LYUITextField * phoneNumField;
@property (weak,nonatomic)LYUITextField * addressTextField;

@property BOOL dazheBOOL;
@property BOOL fapiaoBOOL;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _OrderTabelView.delegate = self;
    _OrderTabelView.dataSource = self;
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:viewTap];
    
//    if (![_pushStr isEqualToString:@"1"]&&![_pushStr isEqualToString:@"3"])
//    {
//        

//    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==3)
    {
        return 20;
        
    }else
    {
        return 60;
    }
   
}


//  可以用自定义 View 写出来，这里用 tableView 写的，一共有 7 行，有些不妥
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = (UITableViewCell *)[_OrderTabelView dequeueReusableCellWithIdentifier:@"OrderTabelViewcellID1" forIndexPath:indexPath];
            _nameTextField = (LYUITextField *)[cell viewWithTag:1210];
            
            if ([_pushStr isEqualToString:@"1"]||[_pushStr isEqualToString:@"3"])
            {
                _nameTextField.text = [self Nallstring:[_memberDataDic objectForKey:@"name"]];
            }
            break;
        case 1:
            cell = (UITableViewCell *)[_OrderTabelView dequeueReusableCellWithIdentifier:@"OrderTabelViewcellID2" forIndexPath:indexPath];
             _phoneNumField = (LYUITextField *)[cell viewWithTag:1211];
            if ([_pushStr isEqualToString:@"1"]||[_pushStr isEqualToString:@"3"])
            {
                 _phoneNumField.text = [self Nallstring:[_memberDataDic objectForKey:@"phone_number"]];
                _phoneNumField.enabled = NO;
            }
            break;
        case 2:
            cell = (UITableViewCell *)[_OrderTabelView dequeueReusableCellWithIdentifier:@"OrderTabelViewcellID3" forIndexPath:indexPath];
               _addressTextField = (LYUITextField *)[cell viewWithTag:1212];
            if ([_pushStr isEqualToString:@"1"]||[_pushStr isEqualToString:@"3"])
            {
                if ([[self Nallstring:[_memberDataDic objectForKey:@"consignee_address"]]isEqualToString:@""])
                {
                    _addressTextField.text = _addressTextField.text;
                }else
                {
                    _addressTextField.text = [self Nallstring:[_memberDataDic objectForKey:@"consignee_address"]];
                }
                
            }
            break;
            
        case 4:
            cell = (UITableViewCell *)[_OrderTabelView dequeueReusableCellWithIdentifier:@"OrderTabelViewcellID4" forIndexPath:indexPath];
            
            break;
           
        default:
            cell = (UITableViewCell *)[_OrderTabelView dequeueReusableCellWithIdentifier:@"OrderTabelViewcellID5" forIndexPath:indexPath];
            break;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

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

- (IBAction)checkBox:(LYCheckBoxButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.tag==9991)
    {
        _dazheBOOL=sender.selected;
    }
    
    if (sender.tag==9992)
    {
        _fapiaoBOOL = sender.selected;
    }
    
    [_OrderTabelView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)NextButton:(UIButton *)sender {
 
    
    if ([_nameTextField.text length]==0||[_phoneNumField.text length]==0||[_addressTextField.text length]==0) {
        
        [SVProgressHUD showErrorWithStatus:@"有必填项未填写!"];
        return;
    }


    
    if (![self isValidateMobile:_phoneNumField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }

    
      NSDictionary * dic = @{@"name":_nameTextField.text,@"phone_number":_phoneNumField.text,@"consignee_address":_addressTextField.text};
      MemberModel *member = [[MemberModel alloc]init];
    
      member = nil;
    
    
    if ([_pushStr isEqualToString:@"3"]) {
        
        
        NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]init];
        [dataDic addEntriesFromDictionary:_memberDataDic];
        [dataDic addEntriesFromDictionary:dic];
        
        member= [MemberModel mj_objectWithKeyValues:dataDic];
        
        member= [MemberModel mj_objectWithKeyValues:@{@"meberID":[dataDic valueForKey:@"id"]}];
        
        ClothingViewController*order = [[ClothingViewController alloc]init];
        order.iamge_dic = _imagedic;
        
        [self.navigationController pushViewController:order animated:YES];

        
        
        
    }else if ([_pushStr isEqualToString:@"1"]){
        
        NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]init];
        [dataDic addEntriesFromDictionary:_memberDataDic];
        [dataDic addEntriesFromDictionary:dic];
        
        member= [MemberModel mj_objectWithKeyValues:dataDic];
        
        member= [MemberModel mj_objectWithKeyValues:@{@"meberID":[dataDic valueForKey:@"id"]}];
        
        OrderEntryViewController * order = [[OrderEntryViewController alloc]init];
        order.pushID = @"1";
        order.memberDic = _memberDataDic;
        order.imagedic = _imagedic;
        order.title = @"录入会员数据";
        [self.navigationController pushViewController:order animated:YES];
        
        
    }else
    {
         member= [MemberModel mj_objectWithKeyValues:dic];
        
        
        [SVProgressHUD show];
        
        NSDictionary * token = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"]};
        NSMutableDictionary * httpDetaDic = [[NSMutableDictionary alloc]init];
        [httpDetaDic addEntriesFromDictionary:dic];
        [httpDetaDic addEntriesFromDictionary:@{@"phone":[dic valueForKey:@"phone_number"]}];
        [httpDetaDic addEntriesFromDictionary:@{@"dressing_name":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminname"]}];
        [httpDetaDic addEntriesFromDictionary:token];
        

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

        [manager POST:memberAdd parameters:httpDetaDic progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            
            
            
            
            if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                
                
                /*
                 
                 NSMutableDictionary的addEntriesFromDictionary：方法的使用，这是一个整体拼接字典的方法：
                 
                 
                 - (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary
                 这个方法在进行多个字典拼接的时候非常有用，举例如下：
                 //先定义需要使用的KEY
                 NSString *LAST=@"lastName";
                 NSString *FIRST=@"firstName";
                 NSString *SUFFIX=@"suffix";
                 NSString *TITLE=@"title";
                 
                 NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                 @"Jo", FIRST, @"Smith", LAST, nil];
                 
                 NSDictionary *newDict=[NSDictionary dictionaryWithObjectsAndKeys:
                 @"Jones", LAST, @"Hon.", TITLE, @"J.D.", SUFFIX, nil];
                 
                 
                 //合并两个字典  
                 [dict addEntriesFromDictionary: newDict];  
                 这个方法会改变 dict字典对象的LAST所对应的值，另外再添加@"Hon."和TITLE、@"J.D. "和SUFFIX两个键/值对。
                
                
                
                */
                
                [httpDetaDic addEntriesFromDictionary:@{@"id": [responseObject valueForKey:@"data"]}];
                
                if ([LYFmdbTool insertMemberName:@[@{@"name":[httpDetaDic objectForKey:@"name"],@"phone_number":[httpDetaDic objectForKey:@"phone"],@"consignee_address":[httpDetaDic objectForKey:@"consignee_address"]}]])
                {
                    
                    
                }
                
                [httpDetaDic addEntriesFromDictionary:dic];
                
                [httpDetaDic removeObjectForKey:@"phone"];;
                [httpDetaDic removeObjectForKey:@"meberID"];
                
                if ([LYFmdbTool insertMember2:@[httpDetaDic]])
                {
                    
                }
                
                [SVProgressHUD showSuccessWithStatus:@"添加客户成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            NSString * str = [NSString stringWithFormat:@"%@",error];
            [SVProgressHUD showErrorWithStatus:str];
            
            
        }];


    }
    
    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(170|173|171|172|175|176|177|178|179|(13[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#warning viewDidAppear  并没有走这个方法
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![_pushStr isEqualToString:@"1"]&&![_pushStr isEqualToString:@"3"])
    {
//        [self.tabBarController.tabBar setHidden:NO];
    }
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:3];
    item.badgeValue=[NSString stringWithFormat:@"%ld",(long)[[LYFmdbTool queryData:@"upload_t_member"]count]+(long)[[LYFmdbTool queryData:@"upload_Order"]count]];
    if ([item.badgeValue isEqualToString:@"0"])
    {
        item.badgeValue =nil;
    }
    
 
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (![_pushStr isEqualToString:@"1"]&&![_pushStr isEqualToString:@"3"])
    {
        _nameTextField.text = @"";
        _phoneNumField.text = @"";
        _addressTextField.text = @"";

    }
    
    
 
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_nameTextField resignFirstResponder];
    [_phoneNumField resignFirstResponder];
    [_addressTextField resignFirstResponder];

}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderViewController"];
    }
    return self;
}


- (void)tapAction {
    [self.view endEditing:YES];
}



@end
