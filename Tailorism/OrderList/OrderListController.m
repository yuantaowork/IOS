//
//  OrderListController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/22.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "OrderListController.h"
#import "OrderDetailsController.h"
#import "MemberType.h"
#import "SYNavigationDropdownMenu.h"
#import "MJRefresh.h"
#import "MemberDetailsController.h"
@interface OrderListController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SYNavigationDropdownMenuDataSource, SYNavigationDropdownMenuDelegate>


@property(strong,nonatomic)NSMutableArray *listDataArry;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *orderListTabel;
@property (strong, nonatomic) IBOutlet NSString *statusTpye;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;
@property CGFloat contenty;
@property NSInteger currentPage;
@property (nonatomic , assign)NSInteger maxPage;

@end

@implementation OrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _currentPage = 1;
    _maxPage = 1;
    _statusTpye = @"0";
    _searchBar.delegate = self;
    [self.searchBar setShowsCancelButton:YES];
    
    SYNavigationDropdownMenu *menu = [[SYNavigationDropdownMenu alloc] initWithNavigationController:self.navigationController];
    menu.dataSource = self;
    menu.delegate = self;
    self.navigationItem.titleView = menu;
    self.navigationItem.rightBarButtonItem = _rightItem;
    
    _orderListTabel.delegate = self;
    _orderListTabel.dataSource = self;

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _orderListTabel.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getHttpOrderList:@"1" phoneNum:_searchBar.text header:YES status:_statusTpye];
        
    }];


    _orderListTabel.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
     
        if (_maxPage==_currentPage) {


            [SVProgressHUD showInfoWithStatus:@"没有更多了哦"];
            
            [_orderListTabel.mj_footer endRefreshing];
            return ;
        }
        [self getHttpOrderList:[NSString stringWithFormat:@"%ld",(long)_currentPage+1] phoneNum:_searchBar.text header:NO status:_statusTpye];
        
    }];
    [_orderListTabel.mj_header beginRefreshing];
    

    
}

//` 添加临时订单布局在订单页面
- (IBAction)rigthitme:(UIBarButtonItem *)sender {
    
    // 准备初始化配置参数
    NSString *title = @"临时客户下单";
    NSString *message = @"请输入您要下单的手机号";
    NSString *okButtonTitle = @"确定";
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建文本框
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入手机号";
        textField.secureTextEntry = NO;
    }];
    
    
    UIAlertAction *cancelokAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // 读取文本框的值显示出来
        
        
    }];
    
    // 创建操作
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 读取文本框的值显示出来
        
        UITextField *phoneNum = alertDialog.textFields.firstObject;
        if (![self isValidateMobile:phoneNum.text]) {
            [SVProgressHUD showErrorWithStatus:@"输入手机格式不正确"];
        }
        else {
            [self getHttpMeberList:phoneNum.text];
        }
    }];
    
    
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:cancelokAction];
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    [self presentViewController:alertDialog animated:YES completion:nil];
}


-(void)getHttpMeberList:(NSString *)phoneNum
{
    
    [SVProgressHUD show];
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"phone_number":phoneNum};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST: MerberList parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        

        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            if ([[[responseObject objectForKey:@"data"]valueForKey:@"data"]isKindOfClass:[NSArray class]]) {
                
                
                if ([[[responseObject objectForKey:@"data"]valueForKey:@"data"]count]>0) {
                    
                    
                    NSArray * arry =[[responseObject objectForKey:@"data"]valueForKey:@"data"];
                    
                    if ([[[arry objectAtIndex:0]valueForKey:@"dressing_name"]isKindOfClass:[NSNull class]]||[[[arry objectAtIndex:0]valueForKey:@"dressing_name"] length]==0) {
                        
                            [SVProgressHUD dismiss];
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"已查询到客户信息,是否继续操作?" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                        }]];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
    
                            MemberDetailsController * view  = [[MemberDetailsController alloc]init];
                            view.listDataArry =arry;
                            view.phoneNum = [[arry objectAtIndex:0]valueForKey:@"phone_number"];
                            view.pushID = @"1";
                            [self.navigationController pushViewController:view animated:YES];
                            
                            
                            
                        }]];
                        [self presentViewController:alert animated:true completion:nil];

                        
                        
                        
                    }else{
                        
                        if ([[[[[responseObject objectForKey:@"data"]valueForKey:@"data"] objectAtIndex:0]valueForKey:@"dressing_name"]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"adminname"]]) {
                            
                            [SVProgressHUD showInfoWithStatus:@"该客户为您的本地客户,请在客户列表中查询"];
                            
                        }else {
                            
                            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"该客户已归属着装顾问%@!",[[[[responseObject objectForKey:@"data"]valueForKey:@"data"] objectAtIndex:0]valueForKey:@"dressing_name"]]];
                        }
                        
                    }
                    
                    
                }else {
                    
                    [SVProgressHUD showInfoWithStatus:@"未查询到该客户信息"];
                }
                
                
            }else {
                
                [SVProgressHUD showInfoWithStatus:@"未查询到该客户信息"];
            }
            
            
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

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self.tabBarController.tabBar setHidden:NO];
//    
//}


-(void)getHttpOrderList:(NSString*)pageNum phoneNum:(NSString*)phoneNum header:(BOOL)header status:(NSString*)status
{
    
    [SVProgressHUD show];
    
    if (pageNum==nil) {
        pageNum=@"1";
    }
    NSString *idStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"];
    
    NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]init];
    [dataDic addEntriesFromDictionary:@{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"]}];
    [dataDic addEntriesFromDictionary:@{@"add_user_id":idStr}];
    [dataDic addEntriesFromDictionary:@{@"page":pageNum}];
    
    if ([status length]>0)
    {
        [dataDic addEntriesFromDictionary:@{@"status":_statusTpye}];
    }

    
    if ([phoneNum length]>0)
    {
        [dataDic addEntriesFromDictionary:@{@"phone":phoneNum}];
    }
    
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager POST:ordersList parameters:dataDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqual:[NSNumber numberWithInt:0]])
        {
            
            if (header) {
                
                _listDataArry =[NSMutableArray arrayWithArray:[[responseObject valueForKey:@"data"] valueForKey:@"list"]];
            }else {
            
                [_listDataArry addObjectsFromArray:[[responseObject valueForKey:@"data"] valueForKey:@"list"]];
            }
            
            [_orderListTabel reloadData];
            
            
            if (header){[_orderListTabel.mj_header endRefreshing];}else{[_orderListTabel.mj_footer endRefreshing];}
            
            _currentPage =[[[[responseObject valueForKey:@"data"] valueForKey:@"pager"]valueForKey:@"page"]intValue];
            
            NSString *tempPageCount = [[[responseObject valueForKey:@"data"] valueForKey:@"pager"]valueForKey:@"pageCount"];
            _maxPage = [tempPageCount integerValue];
            if ([tempPageCount isEqual:@0]) {
                _maxPage = 1;
            }
            
            
            [SVProgressHUD dismiss];
            
        }if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:-1]])
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Token"];
            AppDelegate * appdelegate =(AppDelegate*) [[UIApplication sharedApplication]delegate];
            [appdelegate getrootViewController];
            
            
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
         if (header){[_orderListTabel.mj_header endRefreshing];}else{[_orderListTabel.mj_footer endRefreshing];}
    }];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self getHttpOrderList:@"1" phoneNum:_searchBar.text header:YES status:@""];
    // Do the search...
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self getHttpOrderList:@"1" phoneNum:_searchBar.text header:YES status:_statusTpye];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return _listDataArry.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//    `搜索框的高度
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section

{
    
    return 18.0 ;
    
}


- ( CGFloat )tableView:( UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    
    return 9.0 ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[_orderListTabel dequeueReusableCellWithIdentifier:@"OrderListCell1" forIndexPath:indexPath];
    
    UILabel * nameNum = (UILabel *)[cell viewWithTag:1212110];
    UILabel * telname = (UILabel *)[cell viewWithTag:1212111];
    UILabel * snNum = (UILabel *)[cell viewWithTag:1212112];
    UILabel * orderType = (UILabel *)[cell viewWithTag:1212113];
    UILabel * liangtiName = (UILabel *)[cell viewWithTag:1212114];
    UILabel * payType = (UILabel *)[cell viewWithTag:1212115];
    
    nameNum.text = [self Nallstring:[[_listDataArry objectAtIndex:indexPath.section]valueForKey:@"name"]];
    telname.text = [self Nallstring:[[_listDataArry objectAtIndex:indexPath.section]valueForKey:@"phone_number"]];
    snNum.text = [self Nallstring:[[_listDataArry objectAtIndex:indexPath.section]valueForKey:@"sn"]];
    orderType.text = [self Nallstring:[MemberType meberType:[[_listDataArry objectAtIndex:indexPath.section]valueForKey:@"status"] type:@"order_status"]];
    liangtiName.text =[self Nallstring:[[_listDataArry objectAtIndex:indexPath.section]valueForKey:@"dressing_name"]];
    payType.text =[self payType:[self Nallstring:[[_listDataArry objectAtIndex:indexPath.section]valueForKey:@"pay_status"]]];
    
    if ([payType.text isEqualToString:@"未支付"]) {
        
        payType.textColor = [UIColor redColor];
    }else {
        
        payType.textColor = [UIColor blackColor];
    }
    return cell;
}

-(NSString *)payType:(NSString*)str {
    
    if ([str isEqualToString:@"0"]) {
        
        return @"未支付";
        
    }else {
        
        return @"已支付";
    }
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OrderDetailsController * view = [[OrderDetailsController alloc]init];
    view.orderDetailsID = [[_listDataArry objectAtIndex:indexPath.section]valueForKey:@"id"];
    view.statusTpye = self.statusTpye;
    [self.navigationController pushViewController:view animated:YES];
    
}

- (UIColor *)titleColorForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu
{
    return [UIColor whiteColor];
}
- (NSArray<NSString *> *)titleArrayForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return self.titleArray;
}

- (CGFloat)arrowPaddingForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return 10.0;
}

- (UIImage *)arrowImageForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    return [UIImage imageNamed:@"Arrow"];
}

- (void)navigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu didSelectTitleAtIndex:(NSUInteger)index {
 
    _statusTpye = [NSString stringWithFormat:@"%lu",(unsigned long)index];
    
     [self getHttpOrderList:@"1" phoneNum:_searchBar.text header:YES status:_statusTpye];
}

#pragma mark - Property method

- (NSArray<NSString *> *)titleArray {
    return @[@"等待接单", @"已接单", @"生产中", @"完成", @"发货", @"废弃",@"已审核"];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    [_searchBar resignFirstResponder];
//    _searchBar.text = @"";
    
}

- (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(170|173|171|172|175|176|177|178|179|(13[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderListController"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:NO];
}


@end
