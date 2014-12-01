//
//  Demo404LandscapeViewController.m
//  demo404
//
//  Created by Min Deng on 14/11/24.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "Demo404LandscapeViewController.h"

@interface Demo404LandscapeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


- (IBAction)shareURL:(UIButton *)sender;
- (IBAction)dismiss404View:(id)sender;


- (void) setupHeadImage:(NSData*)imageData;
- (void) setupLabels;

@end

@implementation Demo404LandscapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupHeadImage:(NSData *)imageData {
    if (self.view.window) {
        UIImage *image = [UIImage imageWithData:imageData];
        
        self.headImageView.contentMode = UIViewContentModeScaleToFill;
        self.headImageView.image = image;
        
        self.currentHeadImage = image;
    }
}

- (void)setupLabels {
    NSString *child_feature = [self.currentData valueForKey:@"child_feature"];
    NSString *text = [NSString stringWithFormat:@"姓名：%@\n性别：%@\n出生日期：%@\n失踪日期：%@\n失踪地点：%@\n特征描述：%@",
                      [self.currentData valueForKey:@"name"],
                      [self.currentData valueForKey:@"sex"],
                      [self.currentData valueForKey:@"birth_time"],
                      [self.currentData valueForKey:@"lost_time"],
                      [self.currentData valueForKey:@"lost_place"],
                      child_feature];
    
    [self.label2 setText:text];
    
}


- (IBAction)shareURL:(UIButton *)sender {
    NSString *url = [self.currentData valueForKey:@"url"];
    
    [self shareText:url andImage:self.currentHeadImage andUrl: [NSURL URLWithString: url]];
}

- (IBAction)dismiss404View:(id)sender {
    [self hideMyself];
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
