//
//  ClothingViewController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/6/3.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "ClothingViewController.h"
#import "ClothingDetaiView.h"
#import "ConfirmOrderController.h"
#import "AdditionalInformationController.h"
#import "ClothingModel.h"
@interface ClothingViewController ()<UIScrollViewDelegate,ClothingDetaiDelagate>
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong,nonatomic)NSMutableArray * oderViewArry;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addOrderButton;
@property(strong,nonatomic)NSMutableArray *oderDataArry;

@property NSInteger oderNumber;
@end

@implementation ClothingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"制衣细节";
    
    _oderViewArry = [[NSMutableArray alloc]init];
    _oderDataArry = [[NSMutableArray alloc]init];
    
    self.navigationItem.rightBarButtonItem = _addOrderButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    _oderNumber = 1;
    _ScrollView.delegate = self;
    _ScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 900*_oderNumber+300);
    [_ScrollView flashScrollIndicators];
    _ScrollView.directionalLockEnabled = YES;
    
    
    ClothingDetaiView *view = [ClothingDetaiView instanceTextView];
    view.delegate =self;
    [view Num:_oderNumber data:nil controller:self];
    view.userInteractionEnabled = YES;
//    view.backgroundColor = [UIColor orangeColor];
    view.frame=CGRectMake(0, 0, CGRectGetWidth(_ScrollView.frame), 900);
    [_ScrollView addSubview:view];
    
    [_oderViewArry addObject:view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)delSonOrder:(NSInteger)ordertag
{
    [_oderViewArry removeObjectAtIndex:ordertag-1];
    
    
    if (_oderDataArry.count>=ordertag)
    {
        [_oderDataArry removeObjectAtIndex:ordertag-1];
    }
 
 
    for (int i = 0; i<_oderViewArry.count; i++)
    {

        ClothingDetaiView*view = (ClothingDetaiView *)[_oderViewArry objectAtIndex:i];
        [view setFrame:CGRectMake(0, 900*(i), CGRectGetWidth(_ScrollView.frame),900)];
        view.OrderTitle.text = [NSString stringWithFormat:@"子订单-%d",i+1];
        view.tagstr = [NSString stringWithFormat:@"%ld",(long)i+1];
        view.delButton.tag = i+1;
            
        
    }
    
    
    
    _oderNumber = _oderViewArry.count;
    _ScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 900*(_oderNumber)+300);
    
    
    
    ClothingDetaiView*clothingDetai = (ClothingDetaiView *)[_oderViewArry objectAtIndex:_oderViewArry.count-1];

    if ([clothingDetai.doneButton.titleLabel.text isEqualToString:@"修改参数"])
    {
        clothingDetai.addSonButton.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }else
    {
        clothingDetai.addSonButton.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    clothingDetai.addSonButton.hidden = NO;
    
    
}

-(void)addSonOrder:(UIButton *)btn
{
    
    
    if (_oderNumber ==5)
    {
        return;
    }
    _oderNumber = _oderNumber +1;
    
    //  加载一个一样的视图 ，也就是订单二
    ClothingDetaiView *view = [ClothingDetaiView instanceTextView];
    [view Num:_oderNumber data:nil controller:self];
    view.delegate =self;
    view.userInteractionEnabled = YES;
    view.frame=CGRectMake(0, 900*(_oderNumber-1), CGRectGetWidth(_ScrollView.frame),900);
    [_ScrollView addSubview:view];
    _ScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 900*_oderNumber+300);
    
    [_oderViewArry addObject:view];
    
}

-(void)orderData:(ClothingModel *)dic
{
    
    [_oderDataArry addObject:dic];
}

-(void)replaceOrderData:(ClothingModel *)dic index:(NSInteger)index
{
    [_oderDataArry replaceObjectAtIndex:index-1 withObject:dic];
    
}

- (IBAction)addOrderButton:(UIBarButtonItem *)sender {
    
    
//    NSDictionary * oderNameArry = [[NSUserDefaults standardUserDefaults]valueForKey:@"OderName"];
//    NSDictionary * liangyiccArry = [[NSUserDefaults standardUserDefaults]valueForKey:@"liangyicc"];
//    NSMutableDictionary * datadic = [[NSMutableDictionary alloc]init];
//    [datadic addEntriesFromDictionary:oderNameArry];
//    [datadic addEntriesFromDictionary:liangyiccArry];
    
    
//    ConfirmOrderController * conview = [[ConfirmOrderController alloc]init];
//    conview.orderdataArry = _oderDataArry;
//    conview.dataDic = datadic;
//    conview.push_ID = _pushID;
//    conview.imagedic = _iamge_dic;
    AdditionalInformationController * conview = [[AdditionalInformationController alloc]init];
    conview.iamge_dic = _iamge_dic;
    conview.orderdataArry = _oderDataArry;
    [self.navigationController pushViewController:conview animated:YES];
    
    
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClothingViewController"];
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
