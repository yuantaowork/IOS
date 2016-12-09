//
//  OrderEntryViewController.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/10.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "OrderEntryViewController.h"
#import "LYUITextField.h"
#import "OrderButton.h"
#import "LYSelectButton.h"
#import "AlertTabelView.h"
#import "ClothingViewController.h"
#import "LYUIImageView.h"
#import "MemberListController.h"
#import "MemberType.h"
#import "MemberModel.h"
@interface OrderEntryViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet LYUITextField *defaultTextField; ///第一个输入框-量衣尺寸
@property (weak, nonatomic) IBOutlet LYUITextField *additionalTextField;///第二个输入框-成衣尺寸
@property (weak, nonatomic) IBOutlet UILabel *defaultTitle;
@property (weak, nonatomic) IBOutlet UILabel *additionalTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLayout;/// 两个TextField上下间距约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defultLayoutHight; ///TextField高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *additionalLayoutHight;///TextField高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultTextFieldTopLayout;///第一个TextField顶高约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneBtnLayout;  ///按钮间距约束

@property(strong,nonatomic)NSArray * defaultArry; ///第一个TextField Titel
@property(strong,nonatomic)NSArray * additionalArry;///第二个TextField Titel
@property(strong,nonatomic)NSMutableArray * initialDataArry;
@property(strong,nonatomic)NSMutableArray * finishedArry;

@property (strong ,nonatomic)NSArray * imageNameArry;

@property(weak,nonatomic) LYUIImageView *selectImageView;


@property NSInteger  selectedButtonTag; ///参数按钮排，选中标示
@property NSInteger  selectedImageViewTag; ///imageview，选中标示



@property BOOL  ONETEXTIMAGEVIEW;
@property BOOL  TWOTEXTIMAGEVIEW;
@property BOOL  THREETEXTIMAGEVIEW;


@end

static BOOL selectField;///选中的TextField 判断

@implementation OrderEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBarController.tabBar setHidden:YES];
    
    [SVProgressHUD showWithStatus:self.showMessage];
    [self performSelector:@selector(viewinit) withObject:nil afterDelay:1.0f];

}

-(void)viewinit
{
    _defaultTextField.delegate = self;
    _additionalTextField.delegate = self;
    
    _imageNameArry = [NSArray arrayWithArray:[LYFmdbTool queryData2:[NSString stringWithFormat:@"ImageName WHERE m_id = '%@'",[_memberDic valueForKey:@"id"]]]];
    
    selectField = YES;
    _selectedButtonTag = 70000;
    
    [self clothingParametersBtnType:_selectedButtonTag select:YES];
    [self performSelector:@selector(modifyConstant) withObject:nil afterDelay:0.1];
    
    _defaultArry = @[@"身高",@"体重",@"领围",@"胸围-量衣尺寸",@"腰围-量衣尺寸",@"下摆-量衣尺寸"
                     ,@"袖肥-量衣尺寸",@"左袖口-量衣尺寸",@"右袖口-量衣尺寸",@"肩宽",@"左袖长",
                     @"后衣长",@"前胸宽",@"后背宽",@"体型",@"站姿",@"肩部",@"腹部",@"备注",@""];
    
    _additionalArry = @[@"",@"",@"",@"胸围-成衣尺寸",@"腰围-成衣尺寸",@"下摆-成衣尺寸"
                        ,@"袖肥-成衣尺寸",@"左袖口-成衣尺寸",@"右袖口-成衣尺寸",@"",@"右袖长",
                        @"前衣长",@"",@"",@"",@"",@"",@"",@"",@""];
    
    
    _initialDataArry = [[NSMutableArray alloc]init];
    _finishedArry = [[NSMutableArray alloc]init];

    

    if ([_pushID isEqualToString:@"1"])
    {
        
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"height"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"weight"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"collar_opening"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"chest_width"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"middle_waisted"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"swing_around"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"arm_width"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"left_wrist_width"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"right_wrist_width"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"should_width"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"left_sleeve"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"back_length"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"chest"]]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"back"]]];
        [_initialDataArry addObject:[MemberType meberType:[self Nallstring:[_memberDic objectForKey:@"body_shape"]]type:@"body_shape"]];
        [_initialDataArry addObject:[MemberType meberType:[self Nallstring:[_memberDic objectForKey:@"station_layout"]]type:@"station_layout"]];
        [_initialDataArry addObject:[MemberType meberType:[self Nallstring:[_memberDic objectForKey:@"shoulder"]]type:@"shoulder"]];
        [_initialDataArry addObject:[MemberType meberType:[self Nallstring:[_memberDic objectForKey:@"abdomen"]]type:@"abdomen"]];
        [_initialDataArry addObject:[self Nallstring:[_memberDic objectForKey:@"note"]]];
        [_initialDataArry addObject:@""];
        
        _defaultTextField.text = [_initialDataArry objectAtIndex:0];
        
        
        for (int i=0;i< _initialDataArry.count; i++) {
            
            LYSelectButton * button = (LYSelectButton*)[self.view viewWithTag:i+70000];
            
            NSLog(@"%ld---开始",(long)button.tag);
            if ([[_initialDataArry objectAtIndex:i]length]!=0)
            {
                NSLog(@"%@",[_initialDataArry objectAtIndex:i]);
                
                if (![[_initialDataArry objectAtIndex:i]isEqualToString:@"<null>"]) {
                    
                     button.selected = YES;
                    NSLog(@"%------ld",(long)button.tag);
                }
                
               
              
            }
        }
        
        
        [_finishedArry addObject:@""];
        [_finishedArry addObject:@""];
        [_finishedArry addObject:@""];
        [_finishedArry addObject:[self Nallstring:[_memberDic objectForKey:@"processed_chest_width"]]];
        [_finishedArry addObject:[self Nallstring:[_memberDic objectForKey:@"processed_middle_waisted"]]];
        [_finishedArry addObject:[self Nallstring:[_memberDic objectForKey:@"processed_swing_around"]]];
        [_finishedArry addObject:[self Nallstring:[_memberDic objectForKey:@"processed_arm_width"]]];
        [_finishedArry addObject:[self Nallstring:[_memberDic objectForKey:@"processed_left_wrist_width"]]];
        [_finishedArry addObject:[self Nallstring:[_memberDic objectForKey:@"processed_right_wrist_width"]]];
        [_finishedArry addObject:@""];
        [_finishedArry addObject:[self Nallstring:[_memberDic objectForKey:@"right_sleeve"]]];
        [_finishedArry addObject:[self Nallstring:[_memberDic objectForKey:@"front_length"]]];
        [_finishedArry addObject:@""];
        [_finishedArry addObject:@""];
        [_finishedArry addObject:@""];
        [_finishedArry addObject:@""];
        [_finishedArry addObject:@""];
        [_finishedArry addObject:@""];
        [_finishedArry addObject:@""];
        [_finishedArry addObject:@""];
        [self performSelector:@selector(getPhoto) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
        
        
    }else
    {
        
        for (int i =0; i<20; i++){
            
            [_initialDataArry addObject:@""];
            [_finishedArry addObject:@""];
        }
        
    }

    [SVProgressHUD dismiss];
}
-(void)getPhoto
{
    
    LYUIImageView * imageview = (LYUIImageView*)[self.view viewWithTag:100];
    LYUIImageView * imageview1 = (LYUIImageView*)[self.view viewWithTag:101];
    LYUIImageView * imageview2 = (LYUIImageView*)[self.view viewWithTag:102];
    
    
    if (![[_imagedic valueForKey:@"image"]isEqual:[NSString string]]) {
        
        if([[_imagedic allKeys] containsObject:@"image"])
        {
            imageview.image = [_imagedic valueForKey:@"image"];
            imageview.clipsToBounds = YES;
            imageview.iamgeShow  =YES;
        }
        
       
    }
    if (![[_imagedic valueForKey:@"image1"]isEqual:[NSString string]]) {
        
        if([[_imagedic allKeys] containsObject:@"image1"])
        {
            imageview1.image = [_imagedic valueForKey:@"image1"];
            imageview1.clipsToBounds = YES;
            imageview1.iamgeShow  =YES;
        }
        
        
    }
   
    if (![[_imagedic valueForKey:@"image2"]isEqual:[NSString string]]) {
        
        if([[_imagedic allKeys] containsObject:@"image2"])
        {
            imageview2.image = [_imagedic valueForKey:@"image2"];
            imageview2.clipsToBounds = YES;
            imageview2.iamgeShow  =YES;
        }
        
    }

}

-(NSString *)Nallstring:(id)str {
    
    
    if ([str isEqual:[NSNull null]])
    {
        return @"";
    }else if ([str isEqualToString:@"<null>"]) {
        
        return @"";
    }
    else if ([str isEqual:@"0.0"])
    {
        return @"";
    }else
    {
        return str;
    }
}

- (IBAction)doneButton:(UIButton *)sender {
    [self selectbutton:_selectedButtonTag];
    if (![self checkMessage]) {
        [SVProgressHUD showErrorWithStatus:@"量衣或成衣尺寸未填写"];
        return;
    }
    /*
    NSInteger i = [self checkAllMessage];
    if (999 != i) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请输入%@",[_defaultArry objectAtIndex:i]]];
        return;
    }
    */
    
    if (_selectedButtonTag==70019) {
        
        [self selectbutton:70000];
        
    }
    
    NSString * body_shapestr= nil;
    if ([[_initialDataArry objectAtIndex:14]isEqualToString:@"一般"]) {
        body_shapestr = @"normal";
        
    }else if ([[_initialDataArry objectAtIndex:14]isEqualToString:@"纤细"])
    {
        body_shapestr = @"thin";
    }else if ([[_initialDataArry objectAtIndex:14]isEqualToString:@"富贵"])
    {
        body_shapestr = @"rich";
    }else if ([[_initialDataArry objectAtIndex:14]isEqualToString:@"微胖"])
    {
        body_shapestr = @"little_fat";
    }else if ([[_initialDataArry objectAtIndex:14]isEqualToString:@"强壮"])
    {
        body_shapestr = @"strong";
    }else
    {
        body_shapestr = @"";
    }
    
    
    NSString * station_layoutstr= nil;
    if ([[_initialDataArry objectAtIndex:15]isEqualToString:@"普通"]) {
        station_layoutstr = @"normal";
        
    }else if ([[_initialDataArry objectAtIndex:15]isEqualToString:@"挺胸"])
    {
        station_layoutstr = @"raised_chest";
    }else if ([[_initialDataArry objectAtIndex:15]isEqualToString:@"驼背"])
    {
        station_layoutstr = @"humpbacked";
    }else if ([[_initialDataArry objectAtIndex:15]isEqualToString:@"哄背"])
    {
        station_layoutstr = @"coax_back";
    }else
    {
        station_layoutstr = @"";
    }
    
    NSString * shoulderstr= nil;
    if ([[_initialDataArry objectAtIndex:16]isEqualToString:@"普通"]) {
        shoulderstr = @"normal";
        
    }
    else if ([[_initialDataArry objectAtIndex:16]isEqualToString:@"小平肩"])
    {
        shoulderstr = @"xiaoping_shoulder";
    }else if ([[_initialDataArry objectAtIndex:16]isEqualToString:@"大平肩"])
    {
        shoulderstr = @"daping_shoulder";
    }else if ([[_initialDataArry objectAtIndex:16]isEqualToString:@"小溜肩"])
    {
        shoulderstr = @"small_shoulder";
    }else if ([[_initialDataArry objectAtIndex:16]isEqualToString:@"大溜肩"])
    {
        shoulderstr = @"big_shoulder";
    }else
    {
        shoulderstr = @"";
    }
    
    
    NSString * abdomenStr= nil;
    if ([[_initialDataArry objectAtIndex:17]isEqualToString:@"平腹"]) {
        abdomenStr = @"flat_belly";
        
    }
    else if ([[_initialDataArry objectAtIndex:17]isEqualToString:@"微腹"])
    {
        abdomenStr = @"micro_abdominal";
    }else if ([[_initialDataArry objectAtIndex:17]isEqualToString:@"大腹"])
    {
        abdomenStr = @"upper_abdomen";
    }else
    {
        abdomenStr = @"";
    }

    MemberModel * meber = [[MemberModel alloc]init];

    NSDictionary* dic11111 =@{@"height": [_initialDataArry objectAtIndex:0],//身高
                              @"weight": [_initialDataArry objectAtIndex:1],//体重
                              @"collar_opening": [_initialDataArry objectAtIndex:2],//领围
                              @"chest_width": [_initialDataArry objectAtIndex:3],//胸围
                              @"processed_chest_width": [_finishedArry objectAtIndex:3],
                              @"middle_waisted": [_initialDataArry objectAtIndex:4],//腰围
                              @"processed_middle_waisted": [_finishedArry objectAtIndex:4],
                              @"swing_around": [_initialDataArry objectAtIndex:5],//下摆
                              @"processed_swing_around": [_finishedArry objectAtIndex:5],
                              @"arm_width": [_initialDataArry objectAtIndex:6],//袖肥
                              @"processed_arm_width": [_finishedArry objectAtIndex:6],
                              @"left_wrist_width": [_initialDataArry objectAtIndex:7],//左袖口
                              @"processed_left_wrist_width": [_finishedArry objectAtIndex:7],
                              @"right_wrist_width": [_initialDataArry objectAtIndex:8],//右袖口
                              @"processed_right_wrist_width": [_finishedArry objectAtIndex:8],
                              @"should_width": [_initialDataArry objectAtIndex:9],//肩宽
                              @"left_sleeve": [_initialDataArry objectAtIndex:10],//左袖长
                              @"right_sleeve": [_finishedArry objectAtIndex:10],//右袖长
                              @"back_length": [_initialDataArry objectAtIndex:11],//后衣长
                              @"front_length": [_finishedArry  objectAtIndex:11],//前背宽
                              @"chest": [_initialDataArry objectAtIndex:12],//前胸
                              @"back": [_initialDataArry objectAtIndex:13],//后背
                              @"body_shape": body_shapestr,//体型
                              @"station_layout":station_layoutstr,//站姿
                              @"shoulder":shoulderstr,//肩部
                              @"abdomen":abdomenStr,//腹部
                              @"consignee_address":meber.consignee_address,//收货地址
                              @"name": meber.name,//名字
                              @"phone_number": meber.phone_number,//电话
                              @"note": [_initialDataArry objectAtIndex:18],//备注
                              @"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],
                              @"dressing_name":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminname"],
                              @"staff_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"adminID"]};
    
   
   
    NSMutableDictionary * mutdic = [[NSMutableDictionary alloc]init];
    
    
    for (int i = 0; i<[dic11111 allKeys].count; i++) {
        
        if ([[dic11111 objectForKey:[[dic11111 allKeys] objectAtIndex:i]]length]!=0)
        {
            [mutdic addEntriesFromDictionary:@{[[dic11111 allKeys]objectAtIndex:i]:[dic11111 objectForKey:[[dic11111 allKeys] objectAtIndex:i]]}];
        }
    
    }


 

    if ([_pushID isEqualToString:@"1"])
    {
        [mutdic addEntriesFromDictionary:@{@"member_id":meber.meberID}];
        [self getHttpAddMember:mutdic POST:memberUpdateUrl];
        
    }else
    {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);

        
        
        if (![[[NSUserDefaults standardUserDefaults]valueForKey:@"NetType"]isEqualToString:@"WIFI"]) {
            
            UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您当前为非WIFI网络环境,继续操作可能消耗大量流量,土豪点继续!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"保存本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                LYUIImageView * imageview = (LYUIImageView*)[self.view viewWithTag:100];
                LYUIImageView * imageview1 = (LYUIImageView*)[self.view viewWithTag:101];
                LYUIImageView * imageview2 = (LYUIImageView*)[self.view viewWithTag:102];
                
                NSMutableDictionary * datadic = [[NSMutableDictionary alloc]init];
                [datadic addEntriesFromDictionary:dic11111];
           
                
                if (imageview.iamgeShow)
                {
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_1",[datadic valueForKey:@"phone"]]];
                    [ UIImageJPEGRepresentation(imageview.image,0.2) writeToFile:filePath atomically:YES];
                    [datadic addEntriesFromDictionary:@{@"image1":[NSString stringWithFormat:@"%@_1",[datadic valueForKey:@"phone"]]}];
                }else
                {
                    [datadic addEntriesFromDictionary:@{@"image1":@""}];
                }
                
                if (imageview1.iamgeShow)
                {
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_2",[datadic valueForKey:@"phone"]]];
                    [ UIImageJPEGRepresentation(imageview1.image,0.2) writeToFile:filePath atomically:YES];
                    [datadic addEntriesFromDictionary:@{@"image2":[NSString stringWithFormat:@"%@_2",[datadic valueForKey:@"phone"]]}];
                }else
                {
                    [datadic addEntriesFromDictionary:@{@"image2":@""}];
                }

                
                if (imageview2.iamgeShow)
                {
                    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_3",[datadic valueForKey:@"phone"]]];
                    [ UIImageJPEGRepresentation(imageview2.image,0.2) writeToFile:filePath atomically:YES];
                    [datadic addEntriesFromDictionary:@{@"image3":[NSString stringWithFormat:@"%@_3",[datadic valueForKey:@"phone"]]}];
                }else
                {
                    [datadic addEntriesFromDictionary:@{@"image3":@""}];
                }

                
                NSLog(@"%@--输出保存本地的数据",datadic);
                
                
                
                if ([LYFmdbTool uplodMember:@[datadic] del:NO]) {
                    
                    
                    UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"重要提示" message:@"保存到本地成功,请继续下单！否则必须在客户数据同步服务器后方可下单!!!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }];
                    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                        
                 
                        [[NSUserDefaults standardUserDefaults]setObject:datadic forKey:@"DONEMEMBER"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        [self savedata:@""];
                        
                        
                        ClothingViewController * conview = [[ClothingViewController alloc]init];
                        conview.pushID = @"1";
                        
                        
                        NSMutableDictionary * imagedic = [[NSMutableDictionary alloc]init];
                        if (imageview.iamgeShow)
                        {
                            [imagedic addEntriesFromDictionary:@{@"image":imageview.image}];
                            
                        }
                        
                        if (imageview1.iamgeShow)
                        {
                            [imagedic addEntriesFromDictionary:@{@"image1":imageview1.image}];
                            
                        }
                        
                        if (imageview2.iamgeShow)
                        {
                            [imagedic addEntriesFromDictionary:@{@"image2":imageview2.image}];
                            
                        }
                        
                        conview.iamge_dic =imagedic;
                        [self.navigationController pushViewController:conview animated:YES];
                        
                        
                    }];
                    
                    [alertCtr addAction:firstAction];
                    [alertCtr addAction:secondAction];
                    [self presentViewController:alertCtr animated:YES completion:^{
                        
                    }];
    
                }
                
                
                
                
            }];
            UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"土豪继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                 [self getHttpAddMember:mutdic POST:memberAdd];
                
            }];
            
            
            [alertCtr addAction:firstAction];
            [alertCtr addAction:secondAction];
            
            [self presentViewController:alertCtr animated:YES completion:^{
                
            }];
        }else
        {
                 [self getHttpAddMember:mutdic POST:memberAdd];
        }
   
    }

}





-(void)getHttpAddMember:(NSMutableDictionary*)mutdic POST:(NSString*)postUrl
{
    [SVProgressHUD show];
    
    LYUIImageView * imageview = (LYUIImageView*)[self.view viewWithTag:100];
    LYUIImageView * imageview1 = (LYUIImageView*)[self.view viewWithTag:101];
    LYUIImageView * imageview2 = (LYUIImageView*)[self.view viewWithTag:102];
    
    NSDictionary * oderNameArry = [[NSUserDefaults standardUserDefaults]valueForKey:@"OderName"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:postUrl parameters:mutdic progress:^(NSProgress * _Nonnull uploadProgress) {



    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {



        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {



            if (![_pushID isEqualToString:@"1"])
            {

                [mutdic addEntriesFromDictionary:@{@"id": [responseObject valueForKey:@"data"]}];
                
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mutdic];
                
                [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"DONEMEMBER"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self savedata:[responseObject valueForKey:@"data"]];
                
                
                if ([LYFmdbTool insertMemberName:@[@{@"name":[mutdic objectForKey:@"name"],@"phone_number":[mutdic objectForKey:@"phone_number"],@"consignee_address":[mutdic objectForKey:@"consignee_address"]}]])
                {
                    
                    
                }
                
                if ([LYFmdbTool insertMember2:@[mutdic]])
                {
                    
                }

            }else
            {
                
                
                if ([LYFmdbTool insertMemberName:@[@{@"name":[mutdic objectForKey:@"name"],@"phone_number":[mutdic objectForKey:@"phone_number"],@"consignee_address":[mutdic objectForKey:@"consignee_address"]}]])
                {
                    
                    
                }
                [mutdic removeObjectForKey:@"member_id"];
                [mutdic removeObjectForKey:@"phone"];
                [mutdic addEntriesFromDictionary:@{@"phone_number":[_memberDic valueForKey:@"phone_number"]}];
                
                
                if ([LYFmdbTool insertMember2:@[mutdic]])
                {
                    
                }

            }
            

            if (imageview.iamgeShow) {
                
                
 
                
                    if ([_pushID isEqualToString:@"1"])
                    {
                          [self getHttpimage:@{@"name":[_memberDic valueForKey:@"name"],@"phone": [_memberDic valueForKey:@"phone_number"],@"member_id": [_memberDic valueForKey:@"id"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"1"} image:imageview.image];
                    }else
                    {
                        [self getHttpimage:@{@"name":[oderNameArry valueForKey:@"name"],@"phone": [oderNameArry valueForKey:@"phoneNum"],@"member_id": [responseObject valueForKey:@"data"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"1"}image:imageview.image];
                    }
                
                
            }
            
            if (imageview1.iamgeShow) {
                
                double delayInSeconds1 = 1.0;
                dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds1 * NSEC_PER_SEC);
                dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                    
                   
                    //执行事件
                    
                    if ([_pushID isEqualToString:@"1"])
                    {
                         [self getHttpimage:@{@"name":[_memberDic valueForKey:@"name"],@"phone": [_memberDic valueForKey:@"phone_number"],@"member_id": [_memberDic valueForKey:@"id"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"2"}image:imageview1.image];
                    }else
                    {
                        [self getHttpimage:@{@"name":[oderNameArry valueForKey:@"name"],@"phone": [oderNameArry valueForKey:@"phoneNum"],@"member_id": [responseObject valueForKey:@"data"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"2"}image:imageview1.image];

                    }
                    
                    
                    
                });
            }
            
            if (imageview2.iamgeShow) {
                double delayInSeconds2 = 1.0;
                dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds2 * NSEC_PER_SEC);
                dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
                    
                    
                    if ([_pushID isEqualToString:@"1"])
                    {
                        [self getHttpimage:@{@"name":[_memberDic valueForKey:@"name"],@"phone": [_memberDic valueForKey:@"phone_number"],@"member_id": [_memberDic valueForKey:@"id"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"3"}image:imageview2.image];
                    }else
                    {
                        [self getHttpimage:@{@"name":[oderNameArry valueForKey:@"name"],@"phone": [oderNameArry valueForKey:@"phoneNum"],@"member_id": [responseObject valueForKey:@"data"],@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"type":@"3"}image:imageview2.image];
                        
                    }
                    
                    //执行事件
                });
            }
            


            if (imageview.iamgeShow==NO&&imageview1.iamgeShow==NO&&imageview2.iamgeShow==NO) {
                
                
                if ([_pushID isEqualToString:@"1"]) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"修改客户数据成功"];
                    
                    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"LinShi"]isEqualToString:@"NO"]) {
                        
                        [[NSUserDefaults standardUserDefaults]setObject:@"Yes"forKey:@"LinShi"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                    
                    double delayInSeconds = 2.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        
                       
                        
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]
                                                              animated:YES];
                        //执行事件
                    });
                    
                }else
                {
                    
                    [SVProgressHUD dismiss];
                    [self getHttpDone];
                    
                }
                
                
            }

        }else
        {
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        NSString * str = [NSString stringWithFormat:@"%@",error];
        [SVProgressHUD showErrorWithStatus:str];
        
        
    }];

}


-(void)memberUpdateDone
{
    
}



-(void)savedata:(NSString * )str
{
    NSDictionary * dic = @{@"height": [_initialDataArry objectAtIndex:0],
                           @"weight": [_initialDataArry objectAtIndex:1],
                           @"lingwei": [_initialDataArry objectAtIndex:2],
                           @"xiongweilt": [_initialDataArry objectAtIndex:3],
                           @"xiongweicy": [_finishedArry objectAtIndex:3],
                           @"yaoweilt": [_initialDataArry objectAtIndex:4],
                           @"yaoweicy": [_finishedArry objectAtIndex:4],
                           @"xiabailt": [_initialDataArry objectAtIndex:5],
                           @"xiabaicy": [_finishedArry objectAtIndex:5],
                           @"xiufeilt": [_initialDataArry objectAtIndex:6],
                           @"xiufeicy": [_finishedArry objectAtIndex:6],
                           @"zuoxiukoult": [_initialDataArry objectAtIndex:7],
                           @"zuoxiukoucy": [_finishedArry objectAtIndex:7],
                           @"youxiukoult": [_initialDataArry objectAtIndex:8],
                           @"youxiukoucy": [_finishedArry objectAtIndex:8],
                           @"should_width": [_initialDataArry objectAtIndex:9],
                           @"zuoxiuc": [_initialDataArry objectAtIndex:10],
                           @"youxiuc": [_initialDataArry objectAtIndex:10],
                           @"houyic": [_initialDataArry objectAtIndex:11],
                           @"qianyic": [_finishedArry objectAtIndex:11],
                           @"qianxk": [_initialDataArry objectAtIndex:12],
                           @"houbeik": [_initialDataArry objectAtIndex:13],
                           @"body_shape": [_initialDataArry objectAtIndex:14],
                           @"zhanzi": [_initialDataArry objectAtIndex:15],
                           @"jianbu": [_initialDataArry objectAtIndex:16],
                           @"fubu": [_initialDataArry objectAtIndex:17],
                           @"id":[self Nallstring:str]};
    
    
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"liangyicc"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


-(void)getHttpimage:(NSDictionary *)dic image:(UIImage*)image
{
    
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:appUpload parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        
        NSData *data = UIImageJPEGRepresentation([self normalizedImage:image],0.2);
        [formData appendPartWithFileData:data name:@"upload" fileName:@"upload.png" mimeType:@"image/png"];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //                          [progressView setProgress:uploadProgress.fractionCompleted];
                          
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
                          
                      } else {
//                          NSLog(@"%@ %@", response, responseObject);
                          
                           NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];//转换数据格式
                          NSLog(@"%@", content);
                          
                          
                          if ([[content valueForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
                          {
                              if (_imageNameArry.count>0)
                              {
                                  NSFileManager* fileManager=[NSFileManager defaultManager];
                                  
                                  if ([[dic valueForKey:@"type"] isEqualToString:@"1"])
                                  {
                                      for (int i = 0; i<_imageNameArry.count; i++) {
                                          
                                          if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"1"])
                                          {
                                              
                                              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                                              NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                                              [fileManager removeItemAtPath:filePath error:nil];
                                          }
                                          
                                          
                                      }
                      
                                   
                                }
                                  
                                  if ([[dic valueForKey:@"type"] isEqualToString:@"2"]) {
                                      
                                      for (int i = 0; i<_imageNameArry.count; i++) {
                                          
                                          if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"1"])
                                          {
                                              
                                              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                                              NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                                              [fileManager removeItemAtPath:filePath error:nil];
                                          }
                                          
                                          
                                      }
                                  }
                                  
                                  if ([[dic valueForKey:@"type"] isEqualToString:@"3"]) {
                                      
                                      for (int i = 0; i<_imageNameArry.count; i++) {
                                          
                                          if ([[[_imageNameArry objectAtIndex:i]valueForKey:@"type"]isEqualToString:@"1"])
                                          {
                                              
                                              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                                              NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[_imageNameArry objectAtIndex:i]valueForKey:@"name"]];
                                              [fileManager removeItemAtPath:filePath error:nil];
                                          }
                                          
                                          
                                      }
                                      
                                  }
                              }
                              
                     
                              
                              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                              NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[content valueForKey:@"data"]valueForKey:@"file"]];   // 保存文件的名称
                              [UIImageJPEGRepresentation(image,0.2) writeToFile:filePath atomically:YES];
                              
                              NSLog(@"%@",filePath);
                              
         
                              if ([_pushID isEqualToString:@"1"])
                              {
                               
                                  
                                  
                                  
                                  if ([LYFmdbTool insertImageName2:@[@{@"id":@"",@"m_id":[dic valueForKey:@"member_id"],@"name":[[content valueForKey:@"data"]valueForKey:@"file"],@"type":[dic valueForKey:@"type"]}]del:NO] ) {
                                      
                                      
                                  }
                              }else
                              {
                                  
                                  
                                  if ([LYFmdbTool insertImageName:@[@{@"id":@"",@"m_id":[dic valueForKey:@"member_id"],@"name":[[content valueForKey:@"data"]valueForKey:@"file"],@"type":[dic valueForKey:@"type"]}]del:NO] ) {
                                      
                                  }
                              }
                              
                              
                              
                              if ([_pushID isEqualToString:@"1"]) {
                                  
                                  [SVProgressHUD showSuccessWithStatus:@"修改客户数据成功"];
                                  
                                  
                                  double delayInSeconds = 2.0;
                                  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                      
                                      [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:YES];
                                      //执行事件
                                  });
                                  
                              }else
                              {
                                  [SVProgressHUD dismiss];
                                  [self getHttpDone];
                                  
                                  
                                  
                              }
                          
                              
                          }
                      }
                  }];
    
    [uploadTask resume];
    
    

    
}



-(void)getHttpDone
{
    
    
    
    LYUIImageView * imageview = (LYUIImageView*)[self.view viewWithTag:100];
    LYUIImageView * imageview1 = (LYUIImageView*)[self.view viewWithTag:101];
    LYUIImageView * imageview2 = (LYUIImageView*)[self.view viewWithTag:102];
    
    
    UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已成功录入数据,是否开始下单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        
        ClothingViewController * conview = [[ClothingViewController alloc]init];
//        ClothingDetailsController* conview = [[ClothingDetailsController alloc]init];
        
        
        NSMutableDictionary * imagedic = [[NSMutableDictionary alloc]init];
        if (imageview.iamgeShow)
        {
            [imagedic addEntriesFromDictionary:@{@"image":imageview.image}];
            
        }
        
        if (imageview1.iamgeShow)
        {
            [imagedic addEntriesFromDictionary:@{@"image1":imageview1.image}];
            
        }
        
        if (imageview2.iamgeShow)
        {
            [imagedic addEntriesFromDictionary:@{@"image2":imageview2.image}];
            
        }
        
        conview.iamge_dic =imagedic;
        [self.navigationController pushViewController:conview animated:YES];
        
    }];
    
    [alertCtr addAction:firstAction];
    [alertCtr addAction:secondAction];
    
    
    [self presentViewController:alertCtr animated:YES completion:^{
        
    }];
    
}


///Layout 点击输入框方法代理/开始编辑状态
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (textField.tag ==70118) {
        
        return YES;
    }
    if (textField != _defaultTextField)
    {
        selectField = NO;
        
        _defaultTextField.layer.borderColor=[[UIColor grayColor]CGColor];
        _additionalTextField.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
        
        _defaultTextField.layer.borderWidth= 1.f;
        _additionalTextField.layer.borderWidth= 2.f;
    }else
    {
        _defaultTextField.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
        _additionalTextField.layer.borderColor=[[UIColor grayColor]CGColor];
        selectField = YES;
        _defaultTextField.layer.borderWidth= 2.f;
        _additionalTextField.layer.borderWidth= 1.f;
    }
    
    return NO;
}

#pragma mark -按钮方法

///键盘按钮方法
- (IBAction)numKeyBoard:(UIButton*)btn {

    if (_selectedButtonTag==70014||_selectedButtonTag==70015||_selectedButtonTag==70016||_selectedButtonTag==70017) {
        
        return;
    }
    
     UITextField  *textfield = [[UITextField alloc]init];
    if (selectField) {
        
        textfield =_defaultTextField; 
        
    }else{
        
        textfield =_additionalTextField;
    }

    if (selectField) {
        
        _defaultTextField.text =  [OrderButton inputContentRestriction:textfield btntag:btn.tag].text;
        
    }else{
        
        _additionalTextField.text = [OrderButton inputContentRestriction:textfield btntag:btn.tag].text;
    }

    
}
///参数按钮方法
- (IBAction)clothingParameters:(UIButton *)btn {
    if ([[_initialDataArry objectAtIndex:_selectedButtonTag - 70000] length]) {
        btn.selected = YES;
    }
    [self selectbutton:btn.tag];
}

///封装改变参数按钮状态方法 select:(BOOL)是否选择
-(void)clothingParametersBtnType:(NSInteger)btntag select:(BOOL)select{

    LYSelectButton * btn = (LYSelectButton*)[self.view viewWithTag:btntag];
    btn.selected = select;
}


///下一步切换按钮方法
- (IBAction)nextBtn:(id)sender {
    
    
    if (_selectedButtonTag==70019) {
        
        [self selectbutton:70000];
        return;
        
    }
    [self selectbutton:_selectedButtonTag+1];
    

}

///-按钮参数方法
- (void)selectbutton:(NSInteger)buttonTag {
    
    
    if (![self checkMessage]) {
        [SVProgressHUD showErrorWithStatus:@"量衣或成衣尺寸未填写"];
        return;
    }
    
    [_initialDataArry replaceObjectAtIndex:_selectedButtonTag-70000 withObject:_defaultTextField.text];
    [_finishedArry replaceObjectAtIndex:_selectedButtonTag-70000 withObject:_additionalTextField.text];
    selectField = YES;
     _additionalTextField.layer.borderWidth= 1.f;
    
    if ([[_initialDataArry objectAtIndex:_selectedButtonTag-70000] length]==0)
    {
        [self clothingParametersBtnType:_selectedButtonTag select:NO];
        
    }
    
    _selectedButtonTag=buttonTag;
//    if (buttonTag==70003||buttonTag==70004||buttonTag==70005||buttonTag==70006||buttonTag==70007||buttonTag==70008||buttonTag==70010||buttonTag==70011) {
//        if ([[_finishedArry objectAtIndex:_selectedButtonTag-70000] length]==0) {
//            [self clothingParametersBtnType:_selectedButtonTag select:NO];
//        }
//    }
//    else {
        [self clothingParametersBtnType:_selectedButtonTag select:YES];
//    }
    
    [self titleText:_selectedButtonTag];
    [self additionalTextfieldHidden:_selectedButtonTag];
    
    _defaultTextField.text = [_initialDataArry objectAtIndex:_selectedButtonTag-70000];
    _additionalTextField.text = [_finishedArry objectAtIndex:_selectedButtonTag-70000];
    
    if (buttonTag>=70014&&buttonTag<70018) {
        
        _defaultTextField.rightViewMode = UITextFieldViewModeAlways;
    }else
    {
        _defaultTextField.rightViewMode =UITextFieldViewModeNever;
    }
    if (buttonTag==70019) {
        
        _defaultTextField.hidden = YES;
        UIView * view = (UIView *)[self.view viewWithTag:1010101];
        view.hidden = NO;
    }else
    {
        _defaultTextField.hidden = NO;
        UIView * view = (UIView *)[self.view viewWithTag:1010101];
        view.hidden = YES;
    }
    
    _defaultTextField.tag = _selectedButtonTag+100;
    
}




-(void)titleText:(NSInteger)titletag
{
    _defaultTitle.text = [_defaultArry objectAtIndex:titletag-70000];
    _additionalTitle.text =[_additionalArry objectAtIndex:titletag-70000];
    _additionalTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    _defaultTextField.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];

}


-(void)additionalTextfieldHidden:(NSInteger)hiddentag
{
    
    if (hiddentag==70003||hiddentag==70004||hiddentag==70005||hiddentag==70006||hiddentag==70007||hiddentag==70008||hiddentag==70010||hiddentag==70011)
    {
        _additionalTextField.hidden = NO;
        _additionalTitle.hidden = NO;
        [self defaultTextFieldLayout:NO];
    }else
    {
        _additionalTextField.hidden = YES;
        _additionalTitle.hidden = YES;
        [self defaultTextFieldLayout:YES];
    }
    
    _defaultTextField.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
    _defaultTextField.layer.borderWidth= 2.f;


}
- (IBAction)imageTap:(UITapGestureRecognizer *)sender {
    
    

    _selectImageView = (LYUIImageView *)sender.view;
    
    if(_selectImageView.iamgeShow == NO){
    
        UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"" message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [self openCamera];
            
        }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self openPics];
            
        }];
        
        UIAlertAction *thridAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        
        
        
        [alertCtr addAction:firstAction];
        [alertCtr addAction:secondAction];
        [alertCtr addAction:thridAction];
        
        
        [self presentViewController:alertCtr animated:YES completion:^{
            
        }];
    }else
    {
        
        LYUIImageView * imageview = (LYUIImageView*)[self.view viewWithTag:100];
        LYUIImageView * imageview1 = (LYUIImageView*)[self.view viewWithTag:101];
        LYUIImageView * imageview2 = (LYUIImageView*)[self.view viewWithTag:102];
        
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        NSMutableArray *thumbs = [[NSMutableArray alloc] init];
        
        
        if (imageview.iamgeShow)
        {
            [photos addObject:[MWPhoto photoWithImage:imageview.image]];
        }
        if (imageview1.iamgeShow)
        {
            [photos addObject:[MWPhoto photoWithImage:imageview1.image]];
        }
        if (imageview2.iamgeShow)
        {
            [photos addObject:[MWPhoto photoWithImage:imageview2.image]];
        }
        self.photos = photos;
        self.thumbs = thumbs;
        
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
        [browser setCurrentPhotoIndex:0];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
        
    }

    

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_defaultTextField resignFirstResponder];
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

- (IBAction)longPressGes:(UILongPressGestureRecognizer *)sender {
    
    _selectImageView = (LYUIImageView *)sender.view;
    
    if (_selectImageView.iamgeShow)
    {
        
        
        
        UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"" message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [self openCamera];
            
        }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self openPics];
            
        }];
   
        UIAlertAction *thridAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction *thridAction2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
                        [_selectImageView setImage:[UIImage imageNamed:@"add5"]];
                        [_selectImageView setIamgeShow:NO];
        }];
        
        
        [alertCtr addAction:firstAction];
        [alertCtr addAction:secondAction];
        [alertCtr addAction:thridAction];
        [alertCtr addAction:thridAction2];
        
        [self presentViewController:alertCtr animated:YES completion:^{
            
        }];
    }
}


#pragma mark -约束

///Layout 约束
-(void)modifyConstant
{
    if (IS_IPHONE_5){
        
        _textFieldLayout.constant = 40;
        _doneBtnLayout.constant = 95;
        
    }else if (IS_IPHONE_6p){
        
        _doneBtnLayout.constant = 150;
    }
    
    
    _defaultTextField.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
    _defaultTextField.layer.borderWidth= 2.f;
    
    UIImageView  *imageView = (UIImageView *)[self.view viewWithTag:100];
    UIImageView  *imageView1 = (UIImageView *)[self.view viewWithTag:101];
    UIImageView  *imageView2 = (UIImageView *)[self.view viewWithTag:102];
    imageView.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
    imageView1.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
    imageView2.layer.borderColor=[[UIColor colorWithHex:@"6d87c3"]CGColor];
    imageView.layer.borderWidth= 1.f;
    imageView1.layer.borderWidth= 1.f;
    imageView2.layer.borderWidth= 1.f;

    
    [self titleText:_selectedButtonTag];
    [self additionalTextfieldHidden:_selectedButtonTag];
    
}



-(void)defaultTextFieldLayout:(BOOL)hidden
{
    
    if (hidden) {
        
        
        
        if (IS_IPHONE_5){
            
            _doneBtnLayout.constant = 55;
            _defaultTextFieldTopLayout.constant = 80;
            
        }else if (IS_IPHONE_6p){
            
            _doneBtnLayout.constant =100;
        _defaultTextFieldTopLayout.constant = 90;
            
        }else if(IS_IPHONE_6){
        
            _defaultTextFieldTopLayout.constant = 90;
            _doneBtnLayout.constant = 70;
            
        }
        
    }else
    {
        _defaultTextFieldTopLayout.constant = 40;

        
        
        if (IS_IPHONE_5){
            
            _doneBtnLayout.constant = 95;
            
        }else if (IS_IPHONE_6p){
            
            _doneBtnLayout.constant = 150;
        }else if (IS_IPHONE_6){
        
            _doneBtnLayout.constant = 120;
        }
        
    }
    
    
}

// 打开相机
- (void)openCamera {
    // UIImagePickerControllerCameraDeviceRear 后置摄像头
    // UIImagePickerControllerCameraDeviceFront 前置摄像头
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        return ;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    // 编辑模式
    imagePicker.allowsEditing = YES;
    
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
    
    
}


// 打开相册
- (void)openPics {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.navigationBar.tintColor = [UIColor colorWithHex:@"007aff"];
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
    
    
}


// 选中照片

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
 
    _selectImageView.clipsToBounds = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _selectImageView.image = image;
    _selectImageView.iamgeShow =YES;
    
    UIImageView *sds = (UIImageView *)[self.view viewWithTag:100];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp)
        
        return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
    
    
}

// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


//` 检验参数是否填写完整 （录入 胸围、腰围、下摆、袖肥、左袖口、右袖口、袖长、衣长时）
- (BOOL)checkMessage {
    if (NO == _additionalTextField.hidden) {
        BOOL defaultTest = [self checkConditionWithMessage:_defaultTextField.text];
        BOOL additionalTest = [self checkConditionWithMessage:_additionalTextField.text];
        
        return !(defaultTest ^ additionalTest);
    }
//    else {
//        BOOL defaultTest = [self checkConditionWithTextField:_defaultTextField];
//        return defaultTest;
//    }
    return true;
}

- (BOOL)checkConditionWithMessage:(NSString *)message {
    BOOL flag;
    BOOL isEmpty = false;
    BOOL isZero = false;
    isEmpty = ![message isEqualToString:@""];
    isZero = ![message isEqualToString:@"0"];
    
    flag = isEmpty && isZero;
    
    return flag;
}

#warning 需求有变，此处逻辑暂时放弃
//`需求有变，此处逻辑暂时放弃
//` 点击完成按钮时， check 所有的量体参数（除去备注和照片） 如果返回值为 999 ，则所有参数填写完整
- (NSInteger)checkAllMessage {
    for (NSInteger i = 0 ; i < ([_initialDataArry count] -  2); i++) {
        NSString *message = [_initialDataArry objectAtIndex:i];
        if (![self checkConditionWithMessage:message]) {
            return i;
        }
    }
    return 999;
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
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderEntryViewController"];
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
