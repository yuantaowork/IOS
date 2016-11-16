//
//  ScanningViewController.m
//  CXScanning
//
//  Created by artifeng on 16/1/7.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "ScanningViewController.h"
#import "AFNetworking.h"
#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
#define XCenter self.view.center.x
#define YCenter self.view.center.y

#define SHeight 20

#define SWidth (XCenter+30)


@interface ScanningViewController ()
{
    UIImageView * imageView;
}

@end

@implementation ScanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码收款";
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
                                         initWithTitle:@"取消"
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(getPopViewController)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(0,100,CGRectGetWidth(self.view.frame), 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor blueColor];
    labIntroudction.text=@"将条码二维码放入框中就能自动扫描";
    [self.view addSubview:labIntroudction];
    
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width-SWidth)/2,(Height-SWidth)/2,SWidth,SWidth)];
    imageView.image = [UIImage imageNamed:@"scanscanBg.png"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5, SWidth-10,1)];
    _line.image = [UIImage imageNamed:@"scanLine@2x.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}
-(void)viewWillDisappear:(BOOL)animated
{
   
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
       
        if (num ==(int)(( SWidth-10)/2)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame =CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
        
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _output.rectOfInterest =[self rectOfInterestByScanViewRect:imageView.frame];//CGRectMake(0.1, 0, 0.9, 1);//
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    

    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame =self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.view bringSubviewToFront:imageView];

    [self setOverView];
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        /**
         *  获取扫描结果
         */
        stringValue = metadataObject.stringValue;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"扫描成功!扫描结果：%@", stringValue] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_session startRunning];
        
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_session startRunning];
        
        [SVProgressHUD showSuccessWithStatus:@"扫描成功!正常处理收款请等待..."];
        [self getHttpMeberList:stringValue];
        
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
    
    
    [_session stopRunning];
//    [self dismissViewControllerAnimated:YES completion:^
//     {
//         [timer invalidate];
//    
//     }];
}


-(void)getHttpMeberList:(NSString *)authCodeStr
{
    
    
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"auth_code":authCodeStr,@"order_id":_order_ID};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST: weixinMicropay parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            
            [SVProgressHUD showSuccessWithStatus:@"订单成功收款"];
            [self performSelector:@selector(getPopViewController) withObject:nil afterDelay:2.f];
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        
    }];
}

-(void)getPopViewController {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
   
    return CGRectMake(x, y, w, h);
}

#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = CGRectGetMinX(imageView.frame);
    CGFloat y = CGRectGetMinY(imageView.frame);
    CGFloat w = CGRectGetWidth(imageView.frame);
    CGFloat h = CGRectGetHeight(imageView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor grayColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
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

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
