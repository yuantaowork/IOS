//
//  AlertTabelView.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/18.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "AlertTabelView.h"
#import "LYUITextField.h"
@interface AlertTabelView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *a_tableView;

@property (strong,nonatomic)NSArray * dataArry;


@end

@implementation AlertTabelView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _a_tableView.delegate =self;
    _a_tableView.dataSource =self;
}
-(void)setTagID:(NSInteger)tagID
{
    NSLog(@"tag---%ld",(long)tagID);

    switch (tagID) {
        case 1214:
            
//            _dataArry = @[@"法人-支付宝",@"法人-钱方好近",@"法人微信",@"公司-支付宝",@"公司-微信",@"线下",@"免费",@"月结-法人-支付宝",@"月结-法人-钱方好近",@"月结-法人-工行",@"公司-刷卡",@"法人-工行",@"银行对公"];
            _dataArry = @[@"公司-微信",@"线下"];
            
            break;
        case 620100:{
            
            NSMutableArray * arry = [[NSMutableArray alloc]init];
            
            for (int i =0; i<[[LYFmdbTool queryData3:@"SELECT * ,substr(code,4,3) AS a FROM fabricListdb WHERE is_delete = \"0\"  ORDER BY a"]count]; i++)
            {
                if ([[[[LYFmdbTool queryData3:@"SELECT * ,substr(code,4,3) AS a FROM fabricListdb WHERE is_delete = \"0\"  ORDER BY a"]objectAtIndex:i]valueForKey:@"status"]isEqualToString:@"1"]) {
                    
                    [arry addObject:[[[LYFmdbTool queryData3:@"SELECT * ,substr(code,4,3) AS a FROM fabricListdb WHERE is_delete = \"0\"  ORDER BY a"]objectAtIndex:i]valueForKey:@"code"]];
                }
          
            }
            
            _dataArry = arry;
        }
            break;
        case 620101:
            
            _dataArry = @[@"标准领",@"八字领",@"一字领",@"领尖扣领",@"小方领",@"圆领",@"礼服领",@"立领",@"暗扣领"];
            
            break;
        case 620102:
            
            _dataArry = @[@"单扣截角",@"单扣圆角",@"单扣直角",@"双扣截角",@"双扣圆角",@"双扣直角",@"法式截角",@"法式圆角",@"法式直角",@"短袖"];
            
            break;
        case 620103:
            
            _dataArry = @[@"明门襟",@"平门禁",@"暗门襟"];
            
            break;
        case 620104:
            
            _dataArry = @[@"修身",@"合身",@"宽松"];
            
            break;
        case 620105:
            
            _dataArry = @[@"无插片",@"固定插片",@"活插片"];
            
            break;
        case 620107:
            
            _dataArry = @[@"正体",@"花体"];
            
            break;
        case 620112:
            
            _dataArry = @[@"无褶",@"边褶",@"工字褶"];
            
            break;
        case 620113:
            
            _dataArry = @[@"圆摆",@"平摆",@"开叉"];
            
            break;
        case 620114:
            
            _dataArry = @[@"否",@"是"];
             break;
        case 70114:
            _dataArry = @[@"一般",@"纤细",@"富贵",@"微胖",@"强壮"];
            
            break;
        case 70115:
            _dataArry = @[@"普通",@"挺胸",@"驼背",@"哄背"];
            
            break;
        case 70116:
            _dataArry = @[@"普通",@"小平肩",@"大平肩",@"小溜肩",@"大溜肩"];
            
            break;
        case 70117:
            _dataArry = @[@"平腹",@"微腹",@"大腹"];
            
            break;
            
        case 620118:
            _dataArry = @[@"顺色",@"白色(HTP)",@"黑色(426)",@"绿色(54)",@"金色(120)",@"深蓝色(218)",@"品牌蓝色(226)",@"酒红色(155)",@"大红色(518)",@"棕色(568)",@"其他颜色（请在备注中输入）"];
            
            break;
            
        case 620119:
            _dataArry = @[@"左袖口",@"左中腰",@"门襟下摆"];
            
            break;
            
        default:
            break;
    }
    
    [_a_tableView reloadData];
    _tagid = tagID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlertTabelView"];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
-(void)tagid:(NSInteger)tagid
{
    NSLog(@"%ld",(long)tagid);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArry.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        
        return 0;
        
    }else{
        
        return 18;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"alertcell" forIndexPath:indexPath];
    cell.textLabel.text = [_dataArry objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    

    if (self.alertStringBlock != nil) {
        self.alertStringBlock([_dataArry objectAtIndex:indexPath.row]);
    }else
    {
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            LYUITextField * text = (LYUITextField*)[[appdelegate getCurrentVC].view viewWithTag:_tagid];
            text.text = [_dataArry objectAtIndex:indexPath.row];
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        
    }];

}


- (void)returnText:(AlertStringBlock)block{

    self.alertStringBlock = block;
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
