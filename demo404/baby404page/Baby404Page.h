//
//  Baby404Page.h
//  demo404
//
//  Created by Min Deng on 14/11/27.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Baby404Page : NSObject

+ (Baby404Page *)sharedInstance;

- (void)show404Page:(UIView *)superView atController:(UIViewController *)parentController;
- (void)updateOrientation:(UIInterfaceOrientation)orientation;

- (void)dismissBaby404Page;

@end
