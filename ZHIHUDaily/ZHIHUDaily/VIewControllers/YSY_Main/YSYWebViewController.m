//
//  YSYWebViewController.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/25.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYWebViewController.h"

@interface YSYWebViewController ()<UIWebViewDelegate>
{
    UIWebView *mShowWeb;
}
@end

@implementation YSYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mShowWeb = [[UIWebView alloc]init];
    mShowWeb.delegate = self;
    mShowWeb.userInteractionEnabled = YES;
    mShowWeb.scalesPageToFit = YES;
    mShowWeb.backgroundColor = [UIColor ysy_convertHexToRGB:@"e6e6e6"];
    NSURL *url = [NSURL URLWithString:@"http://m.guijj.com/mulu/5181.html"];//http://m.guijj.com/?app
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:40.0];
    [mShowWeb loadRequest:request];
    [self.view addSubview:mShowWeb];
    [mShowWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(0);
        make.bottom.mas_equalTo(self.view).with.offset(0);
        make.left.mas_equalTo(self.view).with.offset(0);
        make.right.mas_equalTo(self.view).with.offset(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    //NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    /*
     NSString *js_result = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('q')[0].value='侯文富专栏';"];
     NSString *js_result2 = [webView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit(); "];
     
     [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function myFunction() { "
     "var field = document.getElementsByName('q')[0];"
     "field.value='侯文富的专栏';"
     "document.forms[0].submit();"
     "}
     \";"
     "document.getElementsByTagName('head')[0].appendChild(script);
     "];
     [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"
     ];
     */
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlstr = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    // 广告点击跳转 http://m.baidu.com/cpro.php
    // 广告点击跳转 http://m.baidu.com/mobads.php
    // 广告内容：http://pos.baidu.com/ecom
    // 不知明：http://pos.baidu.com/wh/o.htm?ltr=
    if ([urlstr rangeOfString:@"http://m.baidu.com/cpro.php"].location != NSNotFound ||
        [urlstr rangeOfString:@"http://m.baidu.com/mobads.php"].location != NSNotFound) {
        return NO;
    }
    // 获取
    if ([urlstr rangeOfString:@".baidu.com/"].location != NSNotFound) {
        return NO;
    }
    NSLog(@"shouldStart：%@",urlstr);
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //NSString *currUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    //NSLog(@"DidStart：%@",currUrl);
}

@end
