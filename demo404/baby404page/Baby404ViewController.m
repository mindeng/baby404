//
//  Baby404ViewController.m
//  demo404
//
//  Created by Min Deng on 14/11/27.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "Baby404ViewController.h"
#import "Baby404Page.h"
#include <stdlib.h>
#import <CoreLocation/CoreLocation.h>

static NSString *const BABY404_TOP5_URL = @"http://qzone.qq.com/gy/404/top5.js";

@interface Baby404ViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIImageView *landBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *landHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *landLabel1;
@property (weak, nonatomic) IBOutlet UILabel *landLabel2;

@property (strong, nonatomic) IBOutlet UIView *portraitView;
@property (strong, nonatomic) IBOutlet UIView *landscapeView;

@property (strong, nonatomic) UIView *currentView;
@property (strong, nonatomic) UIView *currentBgImageView;
@property (weak, nonatomic) UIImageView *currentHeadImageView;
@property (weak, nonatomic) UILabel *currentLabel1;
@property (weak, nonatomic) UILabel *currentLabel2;

- (IBAction)shareURL:(UIButton *)sender;
- (IBAction)onDismissView:(id)sender;
- (void) setupBabyPhoto;
- (void) setupLabels;

@property (strong, nonatomic) NSArray* babyInfoList;
@property (strong, nonatomic) NSDictionary* currentBabyInfo;
@property (strong, nonatomic) UIImage *currentBabyPhoto;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *province;

+ (void)processJsonArrayWithURLString:(NSString *)urlString andBlock:(void (^)(NSArray *jsonArray))processJsonArray;

// This takes in a string and imagedata object and returns imagedata processed on a background thread
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url;

@end

@implementation Baby404ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setUpViewForOrientation:self.orientation];
    
    [Baby404ViewController processJsonArrayWithURLString:BABY404_TOP5_URL andBlock:^(NSArray *jsonArray) {
        self.babyInfoList = jsonArray;
        int r = arc4random_uniform((unsigned int)[self.babyInfoList count]);
        self.currentBabyInfo = [self.babyInfoList objectAtIndex:r];
        
        [self setupLabels];

//        NSString *imgUrl = [@"http://qzone.qq.com/gy/upload/" stringByAppendingString:[self.currentBabyInfo valueForKey:@"child_pic"]];
        NSString *imgUrl = [self.currentBabyInfo valueForKey:@"child_pic"];
        [Baby404ViewController processImageDataWithURLString:imgUrl andBlock:^(NSData *imageData) {
            if (imageData) {
                self.currentBabyPhoto = [UIImage imageWithData:imageData];
                [self setupBabyPhoto];
            }
        }];
    }];
    
    [self locate];
}

- (void)locate
{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 1000.0f;
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"定位不成功 ,请确认开启定位"
                                                          delegate:nil
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 开始定位
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
         if (array.count > 0) {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //将获得的所有信息显示到label上
             NSLog(@"%@", placemark.name);
             //获取省份
             self.province = placemark.administrativeArea;
         } else if (error == nil && [array count] == 0) {
             NSLog(@"No results were returned.");
         } else if (error != nil) {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
}

- (void) setupBabyPhoto {
    if (self.view.window && self.currentBabyPhoto) {
        self.currentHeadImageView.image = self.currentBabyPhoto;
        self.currentHeadImageView.contentMode = UIViewContentModeScaleAspectFit;
        NSLog(@"%s %d imageView = %@", __FUNCTION__, __LINE__, self.currentHeadImageView);
        NSLog(@"%s %d %d", __FUNCTION__, __LINE__, (int)self.currentBabyPhoto.size.width);
    }
}

- (void)setupLabels {
    if (self.view.window && self.currentBabyInfo) {
        //    NSString *child_feature = [self.currentData valueForKey:@"child_feature"];
        NSString *text = [NSString stringWithFormat:@"姓名：%@\n性别：%@\n出生日期：%@\n失踪日期：%@\n失踪地点：%@",
                          [self.currentBabyInfo valueForKey:@"name"],
                          ([[self.currentBabyInfo valueForKey:@"sex"]  isEqual: @"1"]) ? @"男" : @"女",
                          [self.currentBabyInfo valueForKey:@"birth_time"],
                          [self.currentBabyInfo valueForKey:@"lost_time"],
                          [self.currentBabyInfo valueForKey:@"lost_place"]];
        
        [self.currentLabel2 setText:text];
    }
    
}

- (IBAction)shareURL:(UIButton *)sender {
    if (!self.currentBabyInfo) {
        return;
    }
    NSString *url = [self.currentBabyInfo valueForKey:@"url"];
    
    [self shareText:url andImage:self.currentBabyPhoto andUrl: [NSURL URLWithString: url]];
}

- (IBAction)onDismissView:(id)sender {
    [[Baby404Page sharedInstance]dismissBaby404Page];
}

- (CGRect)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation {
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    //implicitly in Portrait orientation.
    if(orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        
        if(!statusBarHidden){
            CGFloat statusBarHeight = 20;//Needs a better solution, FYI statusBarFrame reports wrong in some cases..
            fullScreenRect.size.height += statusBarHeight;
            int height = fullScreenRect.size.width;
            fullScreenRect.size.width = fullScreenRect.size.height;
            fullScreenRect.size.height = height;
        }

    }
    else {
        int width = MIN(fullScreenRect.size.width, fullScreenRect.size.height);
        int height = MAX(fullScreenRect.size.width, fullScreenRect.size.height);

        fullScreenRect.size.width = width;
        fullScreenRect.size.height = height;
    }

    return fullScreenRect;
}

-(void)setUpViewForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect screenRect = [self getScreenFrameForOrientation:orientation];
    
    [self.currentView removeFromSuperview];
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        // fix for full screen mode, without this line touch event will go wrong.
        //self.view.frame = screenRect;
        
        [self.view addSubview:self.landscapeView];
        self.currentView = self.landscapeView;
        
        self.currentView.center = CGPointMake(screenRect.size.width/2.0, screenRect.size.height/2.0);

        self.currentBgImageView= self.landBgImageView;
        self.currentHeadImageView = self.landHeadImageView;
        self.currentLabel1 = self.landLabel1;
        self.currentLabel2 = self.landLabel2;
    }
    else
    {
        [self.view addSubview:self.portraitView];
        self.currentView = self.portraitView;
        
        self.currentBgImageView= self.bgImageView;
        self.currentHeadImageView = self.headImageView;
        self.currentLabel1 = self.label1;
        self.currentLabel2 = self.label2;
    }
    
    self.currentView.center = CGPointMake(screenRect.size.width/2.0, screenRect.size.height/2.0);
    self.currentView.opaque = YES;
    self.currentView.backgroundColor = [UIColor clearColor];
    
    [self setupLabels];
    [self setupBabyPhoto];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setUpViewForOrientation:toInterfaceOrientation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    if(CGRectContainsPoint(self.currentBgImageView.frame, location)){
        // In bg, open url
        NSString *url = [self.currentBabyInfo valueForKey:@"url"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else {
        [[Baby404Page sharedInstance]dismissBaby404Page];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t callerQueue = dispatch_get_main_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.tencent.baby404page.processsimagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
}


+ (void)processJsonArrayWithURLString:(NSString *)urlString andBlock:(void (^)(NSArray *jsonArray))processJsonArray
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t callerQueue = dispatch_get_main_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.tencent.baby404page.processsjsonqueue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        if (!jsonData) {
            // can't fetch json data, maybe network is disconnected
            return ;
        }
        NSError *error;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error)
            NSLog(@"JSONObjectWithData error: %@", error);
        
        dispatch_async(callerQueue, ^{
            processJsonArray(jsonArray);
        });
    });
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
