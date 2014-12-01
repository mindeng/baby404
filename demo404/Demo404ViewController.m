//
//  Demo404ViewController.m
//  demo404
//
//  Created by Min Deng on 14/11/23.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import "Demo404ViewController.h"
#import <stdlib.h>
#import "SDWebImage/UIImageView+WebCache.h"

@interface Demo404ViewController () <NSURLConnectionDelegate, UIWebViewDelegate>
@property NSURLConnection *urlConnection;
@property NSMutableData *receivedData;
@property NSString *jsonString;
@property NSArray *allData;
@property NSDictionary *currentData;

- (NSArray*) parseJsonString:(NSString*)s;
@end

@implementation Demo404ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.receivedData = [NSMutableData dataWithCapacity:0];
    
//    UIImage *shareClickedImg = [UIImage imageNamed:@"share_gray.png"];
//    [self.shareButton setImage:shareClickedImg forState:UIControlStateSelected];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://qzone.qq.com/gy/404/data.js"]];
//    self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"data" ofType: @"json"];
    self.jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.allData = [self parseJsonString:self.jsonString];
    
    int idx = arc4random_uniform([self.allData count]);
    self.currentData = [self.allData objectAtIndex:idx];
    
    [self.label2 setText:[self.currentData valueForKey:@"name"]];
    
    if (!self.urlConnection) {
        // Release the receivedData object.
        self.receivedData = nil;
        
        // TODO: Inform the user that the connection failed.
    }
    

}

- (NSArray *)parseJsonString:(NSString *)s {
    NSArray *all = [[NSArray alloc]init];
    NSData* data = [s dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error)
        NSLog(@"JSONObjectWithData error: %@", error);

    all = [dict valueForKey:@"data"];
    

    return all;
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


- (void)hideMyself {
    [self viewWillDisappear:NO];
    [self.view removeFromSuperview];
    [self viewDidDisappear:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSSet *set = [event touchesForView:self.bgImageView];
//    
//    if ([set count] == 0) {
//        [self hideMyself];
//    }
    
    UITouch *touch = [touches anyObject];
CGPoint location =     [touch locationInView:touch.view];
    if(CGRectContainsPoint(self.bgImageView.frame, location)){
        // Nothing to do.
    }
    else {
        [self hideMyself];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)shareURL:(UIButton *)sender {
    [self shareText:@"Hello" andImage:nil andUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
}

- (IBAction)dismiss404View:(id)sender {
    [self hideMyself];
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
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"Succeeded! Received %d bytes of data", (unsigned int)[self.receivedData length]);
    
    NSString *recvStr = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];

    NSLog(@"recevied string: %@", recvStr);
    NSString *jsFunc = [NSString stringWithFormat:@"function getAll() {%@; return jsondata;}", recvStr];
//    NSLog(@"jsFunc:%@", jsFunc);
    
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
//    [webView loadHTMLString:jsFunc baseURL:nil];
    NSString *url=@"http://qzone.qq.com/gy/404/data.js";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
       [self.view addSubview:webView];
    webView.delegate = self;

//    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"JSON.stringify(jsondata);"];
    
//    NSLog(@"result: %@", result);
    
//    NSRange range = [recvStr rangeOfString:@"{"];
//    
//    NSString *jsonString = [recvStr substringFromIndex:range.location];
//        NSLog(@"json string: %@", jsonString);
    
//    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

//    NSError *error = nil;
//    NSDictionary *all = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//    if (error)
//        NSLog(@"JSONObjectWithData error: %@", error);

    
    
    self.urlConnection = nil;
    self.receivedData = nil;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"JSON.stringify(jsondata);"];
    NSLog(@"result: %@", result);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    self.urlConnection = nil;
    self.receivedData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
@end
