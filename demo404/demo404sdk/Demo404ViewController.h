//
//  Demo404ViewController.h
//  demo404
//
//  Created by Min Deng on 14/11/23.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Demo404ViewDismissCallback <NSObject>

- (void) onDismissDemo404View;

@end

@interface Demo404ViewController : UIViewController

@property NSURLConnection *urlConnection;
@property NSMutableData *receivedData;
@property NSString *jsonString;
@property NSArray *allData;
@property NSDictionary *currentData;
@property UIImage *currentHeadImage;

@property (weak, nonatomic) id<Demo404ViewDismissCallback> dismissCallback;

- (void)hideMyself;

- (NSArray*) parseJsonString:(NSString*)s;

// This takes in a string and imagedata object and returns imagedata processed on a background thread
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;


- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url;

@end
