//
//  Baby404Page.m
//  demo404
//
//  Created by Min Deng on 14/11/27.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "Baby404Page.h"
#import "Baby404ViewController.h"

static NSString *const BABY404_TOP5_URL = @"http://qzone.qq.com/gy/404/top5.js";

@interface Baby404Page () <NSURLConnectionDelegate>

@property (strong, nonatomic) NSArray* babyInfoList;

@property (strong, nonatomic)  NSURLConnection *urlConnection;
@property (strong, nonatomic)  NSMutableData *receivedData;

@property (strong, nonatomic) Baby404ViewController *baby404ViewController;

// 更新404页面数据
- (void)updatePageData;

- (void)show404Page:(UIView *)superView withOrientation:(UIInterfaceOrientation)orientation;

@end

@implementation Baby404Page

+ (Baby404Page *)sharedInstance
{
    static Baby404Page *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Baby404Page alloc] init];
        // initialize the single instance
    });
    return sharedInstance;
}

- (void)show404Page:(UIView *)superView {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self show404Page:superView withOrientation:orientation];
}

- (void)show404Page:(UIView *)superView withOrientation:(UIInterfaceOrientation)orientation {
    [self dismissBaby404Page];
    
    self.baby404ViewController = [[Baby404ViewController alloc] initWithNibName:[NSString stringWithFormat:@"Baby404ViewController"] bundle:nil];
    self.baby404ViewController.orientation = orientation;
    [superView addSubview:self.baby404ViewController.view];
    [self.baby404ViewController viewDidAppear:NO];
}

- (void) dismissBaby404Page {
    if (self.baby404ViewController) {
        [self.baby404ViewController viewWillDisappear:NO];
        [self.baby404ViewController.view removeFromSuperview];
        [self.baby404ViewController viewDidDisappear:NO];
        self.baby404ViewController = nil;
    }
}

-(void)updateOrientation:(UIInterfaceOrientation)orientation {
//    [self.baby404ViewController setUpViewForOrientation:orientation];
    if (self.baby404ViewController) {
        [self show404Page:self.baby404ViewController.view.superview withOrientation:orientation];
    }
}

- (void)updatePageData {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:BABY404_TOP5_URL]];
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!self.urlConnection) {
        // TODO: Inform the user that the connection failed.
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    [self.receivedData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.receivedData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"Succeeded! Received %d bytes of data", (unsigned int)[self.receivedData length]);
    
    NSString *recvStr = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"recevied string: %@", recvStr);
    
    NSError *error = nil;
    self.babyInfoList = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:&error];
    if (error)
        NSLog(@"JSONObjectWithData error: %@", error);
    
    self.urlConnection = nil;
    self.receivedData = nil;
}

@end
