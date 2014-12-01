//
//  Demo404ViewController.h
//  demo404
//
//  Created by Min Deng on 14/11/23.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Demo404ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
- (IBAction)shareURL:(UIButton *)sender;
- (IBAction)dismiss404View:(id)sender;
@end
