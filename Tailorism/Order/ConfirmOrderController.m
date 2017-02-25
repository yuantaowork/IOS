//
//  ConfirmOrderController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/20.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "ConfirmOrderController.h"
#import "LYUITextField.h"
#import "MemberType.h"
#import "JSONKit.h"
#import "MemberModel.h"
#import "OrderModel.h"
#import "ClothingModel.h"
#import "ScanningViewController.h"

@interface ConfirmOrderController ()<MWPhotoBrowserDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *confirmbutton;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSString *orderIDStr;

@end

@implementation ConfirmOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"确认订单";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = _confirmbutton;
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell1" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell2" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell3" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell3"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell4" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell4"];

    
    
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    

   }

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MemberModel * member = [[MemberModel alloc]init];
    _dataDic = member.mj_keyValues;
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==3)
    {
        return _orderdataArry.count;
    }else
    {
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        return 340;
    }else if (indexPath.section==1)
    {
        return 520;
    }else if (indexPath.section==2)
    {
        return 180;
    }else if (indexPath.section==3)
    {
        return 400;
    }else
    {
        return 340;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell;
    UITableViewCell * cell;
    
    switch (indexPath.section) {
        case 0:{
           cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell1" forIndexPath:indexPath];
            
            LYUITextField * _nameTextField = (LYUITextField *)[cell viewWithTag:22210];
            LYUITextField * _phoneNumField = (LYUITextField *)[cell viewWithTag:22212];
            LYUITextField * _addressTextField = (LYUITextField *)[cell viewWithTag:22214];
            LYUITextField * _dressing_nameTextField = (LYUITextField *)[cell viewWithTag:22216];
            LYUITextField * _zhifuTextField = (LYUITextField *)[cell viewWithTag:22211];
            LYUITextField * _dazheTextField = (LYUITextField *)[cell viewWithTag:22213];
            LYUITextField * _dazheyuanyinField = (LYUITextField *)[cell viewWithTag:22215];
            LYUITextField * _fapiaoTextField = (LYUITextField *)[cell viewWithTag:22217];
            UITextView * _beizhuTextField = (UITextView *)[cell viewWithTag:22218];
            LYUITextField * moneyLab = (LYUITextField *)[cell viewWithTag:22219];
            
           
            MemberModel * member = [[MemberModel alloc]init];
            OrderModel * order = [[OrderModel alloc]init];
            
            _nameTextField.text = member.name;
            _phoneNumField.text = member.phone_number;
            _addressTextField.text =member.consignee_address;
            _dressing_nameTextField.text = order.sale_name;
            _zhifuTextField.text = [MemberType meberType:order.pay_type type:@"pay_type"];
            _dazheTextField.text = order.discount;
            _fapiaoTextField.text = order.invoice;
            _beizhuTextField.text = [NSString stringWithFormat:@"客户备注:%@\n订单备注:%@",[self Nallstring:member.note],order.express_note];
            _dazheyuanyinField.text =order.discount_remark;
            
            
            int _moneyMoney = 0;
            
            for (int oderNum=0; oderNum <_orderdataArry.count; oderNum ++) {
                
                ClothingModel * clothing = [_orderdataArry objectAtIndex:oderNum];
                
                NSArray * arry  =   [LYFmdbTool queryData3:[NSString stringWithFormat:@"SELECT `price` FROM `fabricListdb` WHERE `code`=\"%@\"",clothing.code]];
                
                
                
                _moneyMoney = [[[arry objectAtIndex:0]valueForKey:@"price"]intValue]*[clothing.number intValue]+_moneyMoney;
                
                
            }
            

            moneyLab.text = [NSString  stringWithFormat:@"%.2f",_moneyMoney-[order.discount floatValue]];
            
        }
            break;
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell2" forIndexPath:indexPath];
            
            LYUITextField * shengaolabel     = (LYUITextField*)[cell viewWithTag:14110];
            LYUITextField * tizhonglabel     = (LYUITextField*)[cell viewWithTag:14111];
            LYUITextField * lingweilabel     = (LYUITextField*)[cell viewWithTag:14112];
            LYUITextField * jiankuanlabel    = (LYUITextField*)[cell viewWithTag:14113];
            LYUITextField * zuoxiuclabel     = (LYUITextField*)[cell viewWithTag:14114];
            LYUITextField * youxiuclabel     = (LYUITextField*)[cell viewWithTag:14115];
            LYUITextField * houyiclabel      = (LYUITextField*)[cell viewWithTag:14116];
            LYUITextField * qianyiclabel     = (LYUITextField*)[cell viewWithTag:14117];
            LYUITextField * qianxklabel      = (LYUITextField*)[cell viewWithTag:14118];
            LYUITextField * houbeiklabel     = (LYUITextField*)[cell viewWithTag:14119];
            LYUITextField * tixinglabel      = (LYUITextField*)[cell viewWithTag:14120];
            LYUITextField * zhanzilabel      = (LYUITextField*)[cell viewWithTag:14121];
            LYUITextField * xiongweiltlabel  = (LYUITextField*)[cell viewWithTag:14122];
            LYUITextField * xiongweicylabel  = (LYUITextField*)[cell viewWithTag:14123];
            LYUITextField * yaoweiltlabel    = (LYUITextField*)[cell viewWithTag:14124];
            LYUITextField * yaoweicylabel    = (LYUITextField*)[cell viewWithTag:14125];
            LYUITextField * xiabailtlabel    = (LYUITextField*)[cell viewWithTag:14126];
            LYUITextField * xiabaicylabel    = (LYUITextField*)[cell viewWithTag:14127];
            LYUITextField * xiufeiltlabel    = (LYUITextField*)[cell viewWithTag:14128];
            LYUITextField * xiufeicylabel    = (LYUITextField*)[cell viewWithTag:14129];
            LYUITextField * zuoxiukoultlabel = (LYUITextField*)[cell viewWithTag:14130];
            LYUITextField * zouxiukoucylabel = (LYUITextField*)[cell viewWithTag:14131];
            LYUITextField * youxiukltlabel   = (LYUITextField*)[cell viewWithTag:14132];
            LYUITextField * youxiukcylabel   = (LYUITextField*)[cell viewWithTag:14133];
            LYUITextField * fubulabel        = (LYUITextField*)[cell viewWithTag:14134];
            LYUITextField * jianbulabel      = (LYUITextField*)[cell viewWithTag:14135];
            
            
            shengaolabel.text = [_dataDic objectForKey:@"height"];
            tizhonglabel.text = [_dataDic objectForKey:@"weight"];
            lingweilabel.text = [_dataDic objectForKey:@"collar_opening"];
            jiankuanlabel.text = [_dataDic objectForKey:@"should_width"];
            zuoxiuclabel.text= [_dataDic objectForKey:@"left_sleeve"];
            youxiuclabel.text = [_dataDic objectForKey:@"right_sleeve"];
            houyiclabel.text = [_dataDic objectForKey:@"back_length"];
            qianyiclabel.text = [_dataDic objectForKey:@"front_length"];
            qianxklabel.text = [_dataDic objectForKey:@"chest"];
            houbeiklabel.text = [_dataDic objectForKey:@"back"];
            tixinglabel.text = [MemberType meberType:[_dataDic objectForKey:@"body_shape"] type:@"body_shape"];
            zhanzilabel.text = [MemberType meberType:[_dataDic objectForKey:@"station_layout"]type:@"station_layout"];
            xiongweiltlabel.text = [_dataDic objectForKey:@"chest_width"];
            xiongweicylabel.text = [_dataDic objectForKey:@"processed_chest_width"];
            yaoweiltlabel.text = [_dataDic objectForKey:@"middle_waisted"];
            yaoweicylabel.text = [_dataDic objectForKey:@"processed_middle_waisted"];
            xiabailtlabel.text = [_dataDic objectForKey:@"swing_around"];
            xiabaicylabel.text = [_dataDic objectForKey:@"processed_swing_around"];
            xiufeiltlabel.text = [_dataDic objectForKey:@"arm_width"];
            xiufeicylabel.text = [_dataDic objectForKey:@"processed_arm_width"];
            zuoxiukoultlabel.text = [_dataDic objectForKey:@"left_wrist_width"];
            zouxiukoucylabel.text = [_dataDic objectForKey:@"processed_left_wrist_width"];
            youxiukltlabel.text = [_dataDic objectForKey:@"right_wrist_width"];
            youxiukcylabel.text = [_dataDic objectForKey:@"processed_right_wrist_width"];
            fubulabel.text = [MemberType meberType:[_dataDic objectForKey:@"abdomen"]type:@"abdomen"];
            jianbulabel.text = [MemberType meberType:[_dataDic objectForKey:@"shoulder"]type:@"shoulder"];
    
           
            
            
        }
            break;
        case 2:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell3" forIndexPath:indexPath];
            
            NSLog(@"%@--image",_imagedic);
            
            UIImageView *imageveiw = (UIImageView *)[cell viewWithTag:99910];
            imageveiw.userInteractionEnabled = YES;
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap)];
            [imageveiw addGestureRecognizer:tapGesture];
            
            UIImageView *imageveiw1 = (UIImageView *)[cell viewWithTag:99911];
            imageveiw1.userInteractionEnabled = YES;
            UITapGestureRecognizer*tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap1)];
            [imageveiw1 addGestureRecognizer:tapGesture1];
            
            
            UIImageView *imageveiw2 = (UIImageView *)[cell viewWithTag:99912];
            imageveiw2.userInteractionEnabled = YES;
            UITapGestureRecognizer*tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap2)];
            [imageveiw2 addGestureRecognizer:tapGesture2];
            
            if (![[_imagedic valueForKey:@"image"]isEqual:[NSString string]]) {
                
          
                if([[_imagedic allKeys] containsObject:@"image"])
                {
                    imageveiw.image = [_imagedic valueForKey:@"image"];
                  
                }
            }
            if (![[_imagedic valueForKey:@"image1"]isEqual:[NSString string]]) {
                
                if([[_imagedic allKeys] containsObject:@"image1"])
                {
                    imageveiw1.image = [_imagedic valueForKey:@"image1"];
                    
                }
            }

            if (![[_imagedic valueForKey:@"image2"]isEqual:[NSString string]]) {
                
                if([[_imagedic allKeys] containsObject:@"image2"])
                {
                    imageveiw2.image = [_imagedic valueForKey:@"image2"];
                    
                }
            }

            
            
        }
            break;
        case 3:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell4" forIndexPath:indexPath];
            
            LYUITextField * mianliaoTextField = (LYUITextField*)[cell viewWithTag:656510];
            LYUITextField * lingxingTextField = (LYUITextField*)[cell viewWithTag:656511];
            LYUITextField * xiuxingTextField =(LYUITextField*)[cell viewWithTag:656512];
            LYUITextField * menjinTextField =(LYUITextField*)[cell viewWithTag:656513];
            LYUITextField * heshenduTextField =(LYUITextField*)[cell viewWithTag:656517];
            LYUITextField * xiuzineirongTextField =(LYUITextField*)[cell viewWithTag:656525];
            LYUITextField * zitiTextField =(LYUITextField*)[cell viewWithTag:656526];
            LYUITextField * xiuziyanseTextField =(LYUITextField*)[cell viewWithTag:656527];
            LYUITextField * xiuziweizhiTextField =(LYUITextField*)[cell viewWithTag:656528];
            LYUITextField * xiabaiTextField =(LYUITextField*)[cell viewWithTag:656519];
            LYUITextField * shuliangTextField =(LYUITextField*)[cell viewWithTag:656529];
            UITextView * mbeizhuTextField =(UITextView*)[cell viewWithTag:656530];
            LYUITextField * lingkuanbsButton =(LYUITextField*)[cell viewWithTag:656514];
            LYUITextField * xiukuanbsButton =(LYUITextField*)[cell viewWithTag:656515];
            LYUITextField * xiongdaiButton =(LYUITextField*)[cell viewWithTag:656516];
            LYUITextField * xiuziButton =(LYUITextField*)[cell viewWithTag:656524];
            LYUITextField * huochapian =(LYUITextField*)[cell viewWithTag:656518];
            
            
            ClothingModel * clothing = [_orderdataArry objectAtIndex:indexPath.row];
            
            
            mianliaoTextField.text = clothing.code;
            lingxingTextField.text = [MemberType meberType:clothing.collar_type type:@"collar_type"];
            xiuxingTextField.text = [MemberType meberType:clothing.sleeve_linging type:@"sleeve_linging"];
            menjinTextField.text = [MemberType meberType:clothing.placket type:@"placket"];
            heshenduTextField.text =[MemberType meberType:clothing.style type:@"style"];
            xiuzineirongTextField.text = clothing.embroidered_text;
            zitiTextField.text = [MemberType meberType:clothing.embroidered_font type:@"embroidered_font"];
            xiuziyanseTextField.text = clothing.color;
            xiuziweizhiTextField.text = clothing.embroidered_position;
            xiabaiTextField.text = [MemberType meberType:clothing.hem type:@"hem"];
            shuliangTextField.text = clothing.number;
            mbeizhuTextField.text = clothing.note;
            lingkuanbsButton.text = [MemberType meberType:clothing.white_collar type:@"waist_dart"];
            xiukuanbsButton.text = [MemberType meberType:clothing.white_sleeve type:@"waist_dart"];
            xiongdaiButton.text = [MemberType meberType:clothing.packet type:@"waist_dart"];
            xiuziButton.text = [MemberType meberType:clothing.embroidered type:@"waist_dart"];
            huochapian.text =  [MemberType meberType:clothing.live_insert type:@"live_insert"];
            
        }
            
            break;
            
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSString *)Nallstring:(id)str {
    
    
    if ([str isEqual:[NSNull null]])
    {
        return @"";
    }else if (str==nil){
        
         return @"";
    }else
    {
        return str;
    }
}


- (IBAction)confirmButton:(id)sender {
//    
//    if ([LYFmdbTool insertOrderList:@[_dataDic]])
//    {
//        [SVProgressHUD showSuccessWithStatus:@"下单成功!"];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        self.tabBarController.selectedIndex = 3;
//    }
    [self getHttpAddOrder];
}



-(void)getHttpAddOrder
{
    NSMutableDictionary *bigDic = [NSMutableDictionary dictionary];

    [SVProgressHUD show];
    NSMutableArray * donedataArry = [[NSMutableArray alloc]init];
    
    for (int i =0; i<_orderdataArry.count; i++) {
        
        ClothingModel * clothing = [_orderdataArry objectAtIndex:i];
        
        
        NSDictionary * data = @{@"collar":@"0",
                                @"code":clothing.code,//布料编号
                                @"collar_type":clothing.collar_type,// 领型
                                @"sleeve_linging":clothing.sleeve_linging,//袖型
                                @"placket":clothing.placket,//门襟
                                @"packet":clothing.packet,//胸袋
                                @"style":clothing.style,//合身度
                                @"live_insert":clothing.live_insert,//活插片
                                @"embroidered":clothing.embroidered,//是否绣字
                                @"embroidered_text":clothing.embroidered_text,//内容
                                @"embroidered_font":clothing.embroidered_font,//字体
                                @"color":clothing.color,//颜色
                                @"embroidered_position":clothing.embroidered_position,//位置
                                @"hem":clothing.hem,//下摆
                                @"number":clothing.number,//数量
                                @"note":clothing.note,//备注
                                @"white_collar":clothing.white_collar,//领款白色
                                @"white_sleeve":clothing.white_sleeve,//袖款白色
                                };
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        
 
            for (int i = 0; i<[data allKeys].count; i++) {
                
                if ([[data objectForKey:[[data allKeys] objectAtIndex:i]]length]!=0)
                {
                    [dic addEntriesFromDictionary:@{[[data allKeys]objectAtIndex:i]:[data objectForKey:[[data allKeys] objectAtIndex:i]]}];
                }
                
            }
            
            [donedataArry addObject:dic];

    }
    
    
    
    
    
    NSString *jsonString = [[NSString alloc] initWithData: [self toJSONData:donedataArry]
                                                    encoding:NSUTF8StringEncoding];
//    [bigDic setObject:jsonString forKey:@"item_details"];
//    
//    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"Token"];
//    [bigDic setObject:token forKey:@"token"];
//    MemberModel * member = [[MemberModel alloc] init];
//    OrderModel * ordermodel = [[OrderModel alloc] init];
    
    
    
    
    NSMutableDictionary * memberdic = [[NSMutableDictionary alloc]init];
    
    
    NSDictionary * token = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"]};
//    [memberdic addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:@"DONEMEMBER"]];
    
    MemberModel * member = [[MemberModel alloc]init];
    OrderModel * ordermodel = [[OrderModel alloc]init];
    
    if (![_push_ID isEqualToString:@"1"]) {
        
        [memberdic addEntriesFromDictionary:@{@"id":member.meberID}];
    }
    
    [memberdic addEntriesFromDictionary:token];
    [memberdic addEntriesFromDictionary:@{@"phoneNumber":member.phone_number}];
    [memberdic addEntriesFromDictionary:@{@"name":member.name}];
    [memberdic addEntriesFromDictionary:@{@"order_type":@"4"}];
    [memberdic addEntriesFromDictionary:@{@"address":member.consignee_address}];
    [memberdic addEntriesFromDictionary:ordermodel.mj_keyValues];
    
    NSMutableDictionary * lastDatadic = [[NSMutableDictionary alloc]init];

    if (![_push_ID isEqualToString:@"1"]) {
        for (int i = 0; i<[memberdic allKeys].count; i++) {
            if ([[memberdic objectForKey:[[memberdic allKeys] objectAtIndex:i]]length]!=0) {
                [lastDatadic addEntriesFromDictionary:@{[[memberdic allKeys]objectAtIndex:i]:[memberdic objectForKey:[[memberdic allKeys] objectAtIndex:i]]}];
            }
        }
    }
    else {
        [lastDatadic addEntriesFromDictionary:memberdic];
    }

    [lastDatadic addEntriesFromDictionary:@{ @"dressing_name":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminname"]}];//着装顾问
    [lastDatadic addEntriesFromDictionary:@{ @"staff_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"]}];//着装顾问
    
    
    NSMutableDictionary *dic11111 = [[NSMutableDictionary alloc]init];
    [dic11111 addEntriesFromDictionary:@{@"item_details":jsonString}];
    [dic11111 addEntriesFromDictionary:lastDatadic];
    
    
    
    if (![_push_ID isEqualToString:@"1" ])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:OrdersAdd parameters:dic11111 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            if ([[responseObject objectForKey:@"status"]isKindOfClass:[NSNumber class]])
            {
                if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
                {
                    _orderIDStr = [[responseObject objectForKey:@"data"]valueForKey:@"order_id"];
                    [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
                    [self performSelector:@selector(getPopViewController) withObject:nil afterDelay:2.f];
                    
                    
                }else
                {
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
                }
            }else
            {
                if ([[responseObject objectForKey:@"status"]isEqualToString:@"0"])
                {
                    
                    [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
                    [self performSelector:@selector(getPopViewController) withObject:nil afterDelay:2.f];
                    
                    
                }else
                {
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
                }
            }
            
     
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
            [self performSelector:@selector(getPopViewController) withObject:nil afterDelay:2.f];
            
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
            
        }];
    }else
    {
#warning 来个断点，不知道什么情况下能够跳进来
        if ([LYFmdbTool uplodOrderList:@[dic11111] del:NO]) {
            
            [SVProgressHUD showSuccessWithStatus:@"成功保存数据到本地!请稍等点击待上传订单提交到网络...."];
             [self performSelector:@selector(getPopViewController) withObject:nil afterDelay:3.f];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"系统故障,保存数据到本地失败,请联系开发人员!!!"];
        }
        
    }

}


-(NSString*)packetNall:(NSString*)str{

    if ([str isEqualToString:@"0"])
    {
        return @"4";
    }else
    {
        return @"1";
    }

}


- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

-(void)getPopViewController
{
//
    
    
    OrderModel * ordermodel = [[OrderModel alloc]init];
    //if ([ordermodel.pay_type isEqualToString:@"12"]) {
        
         [self.navigationController popToRootViewControllerAnimated:YES];
        
    /*}else {
        
        ScanningViewController * sVC = [[ScanningViewController alloc]init];
        sVC.order_ID = _orderIDStr;
        sVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:sVC animated:YES];
        
    }
    */
    

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==2) {
        
         }
  
}
-(void)imageTap
{
    if([[_imagedic allKeys] containsObject:@"image"])
    {
          [self imgashowView:0];
    }
  
}

-(void)imageTap1
{
    if([[_imagedic allKeys] containsObject:@"image1"])
    {
        [self imgashowView:1];
    }
}

-(void)imageTap2
{
    if([[_imagedic allKeys] containsObject:@"image2"])
    {
        [self imgashowView:2];
    }

}
-(void)imgashowView:(int)Num
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    self.photos = photos;
    
    
    if (![[_imagedic valueForKey:@"image"]isEqual:[NSString string]]) {
        
        [photos addObject:[MWPhoto photoWithImage:[_imagedic valueForKey:@"image"]]];
    }
    if (![[_imagedic valueForKey:@"image1"]isEqual:[NSString string]]) {
        
        [photos addObject:[MWPhoto photoWithImage:[_imagedic valueForKey:@"image1"]]];
    }
    
    if (![[_imagedic valueForKey:@"image2"]isEqual:[NSString string]]) {
        
        [photos addObject:[MWPhoto photoWithImage:[_imagedic valueForKey:@"image2"]]];
    }
    
    
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows =  NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    browser.autoPlayOnAppear = YES;
    [browser setCurrentPhotoIndex:Num];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];

}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
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
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ConfirmOrderController"];
    }
    return self;
}



//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
