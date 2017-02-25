//
//  OrderDetailsController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/23.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "OrderDetailsController.h"
#import "MemberType.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ScanningViewController.h"
#import "WuliuViewController.h"

@interface OrderDetailsController ()<MWPhotoBrowserDelegate>

@property (strong, nonatomic) IBOutlet UITableView *OrderDetailListTabel;
@property (strong, nonatomic) NSMutableDictionary *orderdataDic;
@property (strong, nonatomic) NSMutableDictionary *memberDic;
@property (strong, nonatomic) NSArray * listDataArry;
@property (strong, nonatomic) NSArray * imageNameArry;
@property (nonatomic, strong) NSMutableArray *photos;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *moneyGO;

@end

@implementation OrderDetailsController

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    if ([self.statusTpye isEqualToString:@"4"]) {
        self.moneyGO.title = @"物流查询";
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell1" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell2" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell3" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell3"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell4" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell4"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell5" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderCell5"];
    
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"orderId":_orderDetailsID};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager POST:OrdersOrderDetail parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            _listDataArry =[[responseObject valueForKey:@"data"]valueForKey:@"product_orders"];
            _orderdataDic =[[responseObject valueForKey:@"data"]valueForKey:@"orders"];
            
            if ([self.statusTpye isEqualToString:@"4"]) {
                UIPasteboard *paste = [UIPasteboard generalPasteboard];
                if ([self.orderdataDic objectForKey:@"express_no"]) {
                    self.moneyGO.enabled = NO;
                    [SVProgressHUD showInfoWithStatus:@"没有对应的快递单号，请联系相关人员核实"];
                }
                else {
                    paste.string = [self.orderdataDic objectForKey:@"express_no"];
                }
            }
            
            
            if ([[[responseObject valueForKey:@"data"]valueForKey:@"member"]isKindOfClass:[NSArray class]])
            {
                if ([[[responseObject valueForKey:@"data"]valueForKey:@"member"] count] != 0) {
                    _memberDic  = [[[responseObject valueForKey:@"data"]valueForKey:@"member"] objectAtIndex:0];
                }
                
                
            }else
            {
//                [SVProgressHUD showInfoWithStatus:@"此订单为标准码订单"];
                _memberDic  = [[[responseObject valueForKey:@"data"]valueForKey:@"member"]valueForKey:[[_listDataArry objectAtIndex:0] valueForKey:@"collar"]];
            }
           
            if ([[[responseObject valueForKey:@"data"]valueForKey:@"images"]isKindOfClass:[NSArray class]]) {
                
                _imageNameArry =[[responseObject valueForKey:@"data"]valueForKey:@"images"];
            }
            
            [self.tableView reloadData];
          
//            if ([[_orderdataDic valueForKey:@"pay_status"]isEqualToString:@"0"]) {
            
                self.navigationItem.rightBarButtonItem = _moneyGO;
//            }else {
//                
//                self.navigationItem.rightBarButtonItem = nil;
//            }
            
        }if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:-1]])
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Token"];
            AppDelegate * appdelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            [appdelegate getrootViewController];
            
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];

    
}
- (IBAction)moneyGO:(id)sender {
    
    if ([self.statusTpye isEqualToString:@"4"]) {
        
        WuliuViewController *wuliuVC = [[WuliuViewController alloc] init];
        wuliuVC.express_no = [self.orderdataDic objectForKey:@"express_no"];
        [self.navigationController pushViewController:wuliuVC animated:YES];
        
    }
    else {
        ScanningViewController * sVC = [[ScanningViewController alloc]init];
        sVC.order_ID = [_orderdataDic valueForKey:@"id"];
        sVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:sVC animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_listDataArry isEqual:@0]) {
        return 3;
    }
    return 3+_listDataArry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (section ==3) {
//        
////        return _listDataArry.count;
//        return 2;
//        
//    }else
//    {
//        return 1;
//    }
    
    if (section<3)
    {
        return 1;
    }else
    {
         return 2;
    }
  
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        return 280;
    }else if (indexPath.section==1)
    {
        return 520;
    }else if (indexPath.section==2)
    {
        return 180;
    }else
    {
        if (indexPath.row==0)
        {
            return 400;
            
        }else{
            
            return 80;
        }
      
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
             LYUITextField * _dazheYuanyinField = (LYUITextField *)[cell viewWithTag:22215];
            LYUITextField * _fapiaoTextField = (LYUITextField *)[cell viewWithTag:22217];
            UITextView * _beizhuTextField = (UITextView *)[cell viewWithTag:22218];
            LYUITextField * moneyLab = (LYUITextField *)[cell viewWithTag:22219];
            
            
            _nameTextField.text = [self Nallstring:[_orderdataDic objectForKey:@"name"]];
            _phoneNumField.text = [self Nallstring:[_orderdataDic objectForKey:@"phone_number"]];
            _addressTextField.text =[self Nallstring:[_orderdataDic objectForKey:@"address"]];
            _dressing_nameTextField.text = [self Nallstring:[_orderdataDic objectForKey:@"sale_name"]];
            _zhifuTextField.text = [MemberType meberType:[self Nallstring:[_orderdataDic objectForKey:@"pay_type"]]type:@"pay_type"];
            _dazheTextField.text = [self Nallstring:[_orderdataDic objectForKey:@"discount"]];
            _fapiaoTextField.text = [self Nallstring:[_orderdataDic objectForKey:@"invoice"]];
            _beizhuTextField.text = [NSString stringWithFormat:@"客户备注:%@\n订单备注:%@",[self Nallstring:[_memberDic objectForKey:@"note"]],[self Nallstring:[_orderdataDic objectForKey:@"express_note"]]];
            _dazheYuanyinField.text =[self Nallstring:[_orderdataDic objectForKey:@"discount_remark"]];
            moneyLab.text =[self Nallstring:[_orderdataDic objectForKey:@"pay_money"]];
            
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
            LYUITextField * jianbulabel   = (LYUITextField*)[cell viewWithTag:14134];
            LYUITextField * fubulabel   = (LYUITextField*)[cell viewWithTag:14135];
            
            shengaolabel.text = [self Nallstring:[_memberDic objectForKey:@"height"]];
            tizhonglabel.text = [self Nallstring:[_memberDic objectForKey:@"weight"]];
            lingweilabel.text = [self Nallstring:[_memberDic objectForKey:@"collar_opening"]];
            jiankuanlabel.text =[self Nallstring: [_memberDic objectForKey:@"should_width"]];
            zuoxiuclabel.text= [self Nallstring:[_memberDic objectForKey:@"left_sleeve"]];
            youxiuclabel.text = [self Nallstring:[_memberDic objectForKey:@"right_sleeve"]];
            houyiclabel.text = [self Nallstring:[_memberDic objectForKey:@"back_length"]];
            qianyiclabel.text = [self Nallstring:[_memberDic objectForKey:@"front_length"]];
            qianxklabel.text = [self Nallstring:[_memberDic objectForKey:@"chest"]];
            houbeiklabel.text = [self Nallstring:[_memberDic objectForKey:@"back"]];
            
            xiongweiltlabel.text =[self Nallstring: [_memberDic objectForKey:@"chest_width"]];
            xiongweicylabel.text =[self Nallstring: [_memberDic objectForKey:@"processed_chest_width"]];
            yaoweiltlabel.text = [self Nallstring:[_memberDic objectForKey:@"middle_waisted"]];
            yaoweicylabel.text =[self Nallstring: [_memberDic objectForKey:@"processed_middle_waisted"]];
            xiabailtlabel.text = [self Nallstring:[_memberDic objectForKey:@"swing_around"]];
            xiabaicylabel.text = [self Nallstring:[_memberDic objectForKey:@"processed_swing_around"]];
            xiufeiltlabel.text = [self Nallstring:[_memberDic objectForKey:@"arm_width"]];
            xiufeicylabel.text = [self Nallstring:[_memberDic objectForKey:@"processed_arm_width"]];
            zuoxiukoultlabel.text = [self Nallstring:[_memberDic objectForKey:@"left_wrist_width"]];
            zouxiukoucylabel.text = [self Nallstring:[_memberDic objectForKey:@"processed_left_wrist_width"]];
            youxiukltlabel.text = [self Nallstring:[_memberDic objectForKey:@"right_wrist_width"]];
            youxiukcylabel.text = [self Nallstring:[_memberDic objectForKey:@"processed_right_wrist_width"]];
            
            
            jianbulabel.text = [MemberType meberType:[self Nallstring:[_memberDic objectForKey:@"shoulder"]] type:@"shoulder"];
            fubulabel.text = [MemberType meberType:[self Nallstring:[_memberDic objectForKey:@"abdomen"]] type:@"abdomen"];
            tixinglabel.text = [MemberType meberType:[self Nallstring:[_memberDic objectForKey:@"body_shape"]] type:@"body_shape"];
            zhanzilabel.text = [MemberType meberType:[self Nallstring:[_memberDic objectForKey:@"station_layout"]] type:@"station_layout"];
            
            
            
            
        }
            break;
        case 2:{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell3" forIndexPath:indexPath];

            UIImageView *imageveiw = (UIImageView *)[cell viewWithTag:99910];
            imageveiw.userInteractionEnabled = YES;
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)];
            [imageveiw addGestureRecognizer:tapGesture];
            
            UIImageView *imageveiw1 = (UIImageView *)[cell viewWithTag:99911];
            imageveiw1.userInteractionEnabled = YES;
            UITapGestureRecognizer*tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)];
            [imageveiw1 addGestureRecognizer:tapGesture1];
            
            
            UIImageView *imageveiw2 = (UIImageView *)[cell viewWithTag:99912];
            imageveiw2.userInteractionEnabled = YES;
            UITapGestureRecognizer*tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)];
            [imageveiw2 addGestureRecognizer:tapGesture2];
            
            for (int i = 0; i<_imageNameArry.count; i++)
            {
                
                if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"1"])
                {
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];   // 保存文件的名称
                    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
                    imageveiw.image = img;
                    
                    NSString * namestr = [NSString stringWithFormat:@"%@memberUpload/%@/%@",imageHTTPUrl,[_memberDic valueForKey:@"id"],[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                    
                    [imageveiw sd_setImageWithURL:[NSURL URLWithString:namestr]
                     
                                 placeholderImage:img options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     NSLog(@"---------------%lu--%lu",(long)receivedSize,(long)expectedSize);
                                     
                                 } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     
                       
                                 }];
                    
                    
                    //
                    
                }
                if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"2"]) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];   // 保存文件的名称
                    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
                    imageveiw1.image = img;
                    
                    NSString * namestr = [NSString stringWithFormat:@"%@memberUpload/%@/%@",imageHTTPUrl,[_memberDic valueForKey:@"id"],[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                    
                    [imageveiw1 sd_setImageWithURL:[NSURL URLWithString:namestr]
                     
                                  placeholderImage:img options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      NSLog(@"---------------%lu--%lu",(long)receivedSize,(long)expectedSize);
                                      
                                  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      
                                     
                                  }];
                    
                    
                }
                if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"3"]) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];   // 保存文件的名称
                    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
                    imageveiw2.image = img;
                    
                    
                    NSString * namestr = [NSString stringWithFormat:@"%@memberUpload/%@/%@",imageHTTPUrl,[_memberDic valueForKey:@"id"],[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                    
                    [imageveiw2 sd_setImageWithURL:[NSURL URLWithString:namestr]
                     
                                  placeholderImage:img options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      NSLog(@"---------------%lu--%lu",(long)receivedSize,(long)expectedSize);
                                      
                                  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      
                               
                                  }];
                }
                
            }
        }
            
            break;
            
        default:
        {
            if (indexPath.row==0) {
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell4" forIndexPath:indexPath];
                
                LYUITextField * mianliaoTextField = (LYUITextField*)[cell viewWithTag:656510];
                LYUITextField * lingxingTextField = (LYUITextField*)[cell viewWithTag:656511];
                LYUITextField * xiuxingTextField =(LYUITextField*)[cell viewWithTag:656512];
                LYUITextField * menjinTextField =(LYUITextField*)[cell viewWithTag:656513];
                LYUITextField * heshenduTextField =(LYUITextField*)[cell viewWithTag:656517];
                LYUITextField * huochapianTextField =(LYUITextField*)[cell viewWithTag:656518];
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
                
                
                
                NSInteger section = indexPath.section;
                
                mianliaoTextField.text = [[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"fabric_code"];
                lingxingTextField.text = [MemberType meberType:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"collar_type"]type:@"collar_type"];
                xiuxingTextField.text = [MemberType meberType:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"sleeve_linging"]type:@"sleeve_linging"];
                menjinTextField.text = [MemberType meberType:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"placket"]type:@"placket"];
                heshenduTextField.text = [MemberType meberType:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"style"]type:@"style"];
                huochapianTextField.text = [MemberType meberType:[self Nallstring:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"live_insert"]]type:@"live_insert"];
                xiuzineirongTextField.text = [self Nallstring:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"embroidered_text"]];
                zitiTextField.text = [MemberType meberType:[self Nallstring:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"embroidered_font"]]type:@"embroidered_font"];
                xiuziyanseTextField.text =[self Nallstring: [[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"color"]];
                xiuziweizhiTextField.text = [self Nallstring:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"embroidered_position"]];
                xiabaiTextField.text = [MemberType meberType:[self Nallstring:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"hem"]]type:@"hem"];
                shuliangTextField.text = [self Nallstring:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"number"]];
                mbeizhuTextField.text = [self Nallstring:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"note"]];
                lingkuanbsButton.text = [MemberType meberType:[NSString stringWithFormat:@"%@",[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"white_collar"]]type:@"waist_dart"];
                xiukuanbsButton.text = [MemberType meberType:[NSString stringWithFormat:@"%@",[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"white_sleeve"]]type:@"waist_dart"];
                xiongdaiButton.text =[MemberType meberType:[NSString stringWithFormat:@"%@",[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"packet"]]type:@"packet"];
                xiuziButton.text = [self xiuziintBOOL:[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"embroidered"]];
                
                
                
                
            }else{
                
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmOrderCell5" forIndexPath:indexPath];
                
                NSMutableArray *arry = [NSMutableArray array];
                for (int i = 292910; i <= 292917; i ++) {
                    UILabel *label = (UILabel *)[cell viewWithTag:i];
                    [arry addObject:label];
                }
                
//                UILabel * label1 = (UILabel*)[cell viewWithTag:292910];
//                UILabel * label2 = (UILabel*)[cell viewWithTag:292911];
//                UILabel * label3 = (UILabel*)[cell viewWithTag:292912];
//                UILabel * label4 = (UILabel*)[cell viewWithTag:292913];
//                UILabel * label5 = (UILabel*)[cell viewWithTag:292914];
//                UILabel * label6 = (UILabel*)[cell viewWithTag:292915];
//                UILabel * label7 = (UILabel*)[cell viewWithTag:292916];
//                UILabel * label8 = (UILabel*)[cell viewWithTag:292917];
//                
//                NSArray * arry = [NSArray arrayWithObjects:label1,label2,label3,label4,label5,label6,label7,label8,nil];
                
                
                for (int i =0; i<arry.count; i++)
                {
                    
                    if (![[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"qrinfo"]isKindOfClass:[NSArray class]]) {
                        
                        if ([[[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"qrinfo"]allKeys]containsObject:@"status"])
                        {
                            
                            if (i<=[[[[_listDataArry objectAtIndex:indexPath.section-3] objectForKey:@"qrinfo"]valueForKey:@"status"]intValue]-1) {
                                
                                UILabel *label = (UILabel *)[arry objectAtIndex:i];
                                label.textColor = [UIColor colorWithHex:@"5673b7"];
                            }
                            
                            
                        }
                        
                    }
                }
                
                
            }
            
        }
            
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;


}

-(NSString *)intBOOL:(id)num
{
    
    if (num==0) {
        
        
        return @"否";
        
        
    }else
    {
        return @"是";
        
        
    }
    
}

-(NSString *)xiuziintBOOL:(NSString *)num
{
    if ([num isEqualToString:@"0"]) {
        return @"否";
        
        
    }else
    {
        return @"是";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section==2) {
       }

    



}


- (void)imgTap:(UITapGestureRecognizer *)tap {

//    [self imgashowView:0];
    
    UIImageView *myImageView = (UIImageView *)tap.view;
    self.photos = [NSMutableArray array];
    [self.photos addObject:[MWPhoto photoWithImage:myImageView.image]];
    
    if (_imageNameArry.count==0)
    {
        return;
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
    [browser setCurrentPhotoIndex:(myImageView.tag - 99910)];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
    
}


#warning 用上面的函数简化掉了一下步骤
/*
-(void)imageTap1
{
    [self imgashowView:1];
}

-(void)imageTap2
{
    [self imgashowView:2];
}

-(void)imgashowView:(int)Num
{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    self.photos = photos;
    
    UIImageView *imageveiw = (UIImageView *)[self.view viewWithTag:99910];
    UIImageView *imageveiw1 = (UIImageView *)[self.view viewWithTag:99911];
    UIImageView *imageveiw2 = (UIImageView *)[self.view viewWithTag:99912];
    
    
    
    for (int i = 0; i<_imageNameArry.count; i++)
    {
        
        if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"1"])
        {
            
            [photos addObject:[MWPhoto photoWithImage:imageveiw.image]];
            
        }
        if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"2"]) {
            
            [photos addObject:[MWPhoto photoWithImage:imageveiw1.image]];
            
        }
        if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"3"]) {
            
            [photos addObject:[MWPhoto photoWithImage:imageveiw2.image]];
            
        }
        
    }
    
    
    if (_imageNameArry.count==0)
    {
        return;
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

*/

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarController.tabBar.hidden = YES;
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderDetailsController"];
    }
    return self;
}

@end
