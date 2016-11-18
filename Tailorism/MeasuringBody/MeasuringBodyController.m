//
//  MeasuringBodyController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/7/11.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "MeasuringBodyController.h"
#import "CouponTab.h"
#import "BodyTableVIew.h"
#import "TimeModel.h"
@interface MeasuringBodyController ()<CouponTabDelegate,UIScrollViewDelegate>
@property (strong,nonatomic)CouponTab  * coupontab;
@property (strong,nonatomic)BodyTableVIew  * newsBodyTable;
@property (strong,nonatomic)BodyTableVIew  * startBodyTable;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MeasuringBodyController

- (void)viewWillAppear:(BOOL)animated {    
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getHttpMeberList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(getHttpMeberList) name:@"BodyController" object:nil];
    
    _coupontab = [[CouponTab alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 46)];
    _coupontab.delegate =self;
    [self.view addSubview:_coupontab];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*2,0);
    _scrollView.delegate =self;
    
    _newsBodyTable   = [[BodyTableVIew alloc]initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-46) type:0 controller:self];
    _startBodyTable  = [[BodyTableVIew alloc]initWithFrame: CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-46) type:1 controller:self];

//    newBodyTable.delegate =self;
    [_scrollView addSubview:_newsBodyTable];
    [_scrollView addSubview:_startBodyTable];
    
    [self getHttpSettingsList];
}

-(void)getHttpSettingsList {
    
  
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager POST:settingsList parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            [[NSUserDefaults standardUserDefaults]setObject:[[[[responseObject objectForKey:@"data"]valueForKey:@"data"]objectAtIndex:0]valueForKey:@"value"] forKey:@"SettingsNum"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            

        }if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:-1]])
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Token"];
            AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            [appdelegate getrootViewController];
            
            
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
}


- (IBAction)shuaxin:(UIBarButtonItem *)sender {
    [self getHttpMeberList];
    
}


-(void)getHttpMeberList
{
    
    [SVProgressHUD show];
    
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"member_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"],@"pageSize":@"500"};
//    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:measureList parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {

        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];//转换数据格式
//        NSLog(@"%@", content);
        
      
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            [SVProgressHUD dismiss];
            [_newsBodyTable getHttpData:[[responseObject objectForKey:@"data"]valueForKey:@"data"]];

            [_startBodyTable getHttpData:[[responseObject objectForKey:@"data"]valueForKey:@"data"]];

        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);

    }];
}

-(void)getHttpMeasureProcess:(NSDictionary*)dic
{
    
//    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"member_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager POST:measureProcess parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            

            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}



-(void)couponTabindex:(NSInteger)index
{
    if (index==0)
    {
        
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else
    {
        [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:YES];
        
    }
}

#pragma -mark -选择滚动动画
- (void) scrollViewDidScroll:(UIScrollView *)sender {
    
    CGFloat pageWidth = sender.frame.size.width;
    
    int currentPage = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth);
    
    if (currentPage==0) {
        
        [_coupontab commitAnimations:YES];
        
    }else
    {
        [_coupontab commitAnimations:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MeasuringBodyController"];
    }
    return self;
}


@end
