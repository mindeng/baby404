//
//  ViewController.m
//  demo404
//
//  Created by Min Deng on 14/11/23.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "Baby404Page.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *showButton;
- (IBAction)show404Demo:(UIButton *)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)show404Page {
    [[Baby404Page sharedInstance] show404Page:self.view atController:self];
}

- (IBAction)show404Demo:(UIButton *)sender {
    [self show404Page];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [[Baby404Page sharedInstance]updateOrientation:toInterfaceOrientation];
}

@end
