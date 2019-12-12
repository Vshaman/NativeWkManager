//
//  WebViewController.m
//  WKTest
//
//  Created by ox Ho on 2019/4/26.
//  Copyright © 2019年 oxho. All rights reserved.
//

#import "WebViewController.h"
#import <WebViewJavascriptBridge.h>
#import <WebKit/WebKit.h>
#import <SVProgressHUD.h>
#import "ZYSpreadButton.h"

#define TOOL_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WebViewJavascriptBridge *wjb;
@property (nonatomic,strong)ZYSpreadButton *spreadButton;//objc
@property (nonatomic,assign)BOOL isLightStatusBar;
@property (nonatomic,assign)BOOL isShowProgressView;
@property (nonatomic,strong)UIProgressView* progressView;
@property (nonatomic,assign)CGFloat topHeight;
@property (nonatomic,assign)CGFloat bottomHeight;
@property (nonatomic,assign)BOOL isHiddenStatusBar;
@property (nonatomic,assign)BOOL isSafeArea;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [SVProgressHUD showWithStatus:@""];
    [self setupUI];
}

- (void)setupUI{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    configuration.userContentController = wkUController;
    CGFloat Screen_Height = CGRectGetHeight(self.view.frame);
    CGFloat Screen_Width = CGRectGetWidth(self.view.frame);
#pragma mark - web页面UI自定义
    if (_configModel) {
        _isHiddenStatusBar = _configModel.isHiddenStatusBar;
        
        _isSafeArea = _configModel.isSafeArea;
        _isLightStatusBar = _configModel.isLightStatusBar;
        if (_configModel.backgroundColor) { [self setWebBackgroundColor:_configModel.backgroundColor];}
        
    }
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (_isSafeArea) {
        
        _topHeight = Screen_Height >= 812 ? 40 : 20;
        _bottomHeight = Screen_Height >= 812 ? 20 : 0;
        
    }
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, _topHeight, Screen_Width, Screen_Height-_topHeight-_bottomHeight) configuration:configuration];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
   
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    _isShowProgressView = YES;
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://zy.xiaomiqh.com/"]];
    [self.webView loadRequest:request];
    
    self.wjb = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    
    
    [self.wjb setWebViewDelegate:self];
    if (_configModel && [_configModel.iOS11ScrollView intValue]) {
        
    if (@available(iOS 11.0, *)) {
           self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
       }
        
    }
    
    __weak __typeof__(self) weakSelf = self;
#pragma mark - 首页
    [self.wjb registerHandler:@"jumpToHome" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf jumpToHome];
    }];
#pragma mark - 返回
    [self.wjb registerHandler:@"jumpToBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf jumpToBack];
    }];
#pragma mark - 刷新
    [self.wjb registerHandler:@"refreshThePage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf refreshThePage];
    }];
#pragma mark - 清除
    [self.wjb registerHandler:@"clearAllUIWebViewData" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf clearAllUIWebViewData];
    }];
#pragma mark - 跳转
    [self.wjb registerHandler:@"openWebPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf openWebPageWithUrlStr:(NSString *)data];
    }];
#pragma mark - 显示进度条
    [self.wjb registerHandler:@"showProgress" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSNumber * isSuspendBtnNum = data;
        weakSelf.isShowProgressView = [isSuspendBtnNum boolValue];
    }];
#pragma mark - 颜色
    [self.wjb registerHandler:@"statusBarColor" handler:^(id data, WVJBResponseCallback responseCallback) {
        //        [weakSelf openWebPageWithUrlStr:(NSString *)data];
        [weakSelf setStatusBarBackgroundColor:(NSString *)data];
    }];
    [self.wjb registerHandler:@"backgroundColor" handler:^(id data, WVJBResponseCallback responseCallback) {
        //        [weakSelf openWebPageWithUrlStr:(NSString *)data];
        [weakSelf setWebBackgroundColor:(NSString *)data];
    }];
    #pragma mark - 是否白色状态栏
    [self.wjb registerHandler:@"isLightStatusBar" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"~~~");
        NSNumber * isSuspendBtnNum = data;
        weakSelf.isLightStatusBar = [isSuspendBtnNum boolValue];
        [weakSelf setNeedsStatusBarAppearanceUpdate];
    }];
   
    
    
    #pragma mark - 是否隐藏状态栏
    [self.wjb registerHandler:@"isHiddenStatusBar" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSNumber * isHiddenStatusBar = data;
        weakSelf.isHiddenStatusBar = [isHiddenStatusBar boolValue];
        [weakSelf setNeedsStatusBarAppearanceUpdate];
        
    }];
    
    if (self.suspendBtn) {
        [self runWithObjcCode];
    }
    
}
#pragma mark -更新webViewframe
- (void)updateWebViewFrame{
    CGFloat Screen_Height = CGRectGetHeight(self.view.frame);
    CGFloat Screen_Width = CGRectGetWidth(self.view.frame);
    [self.webView setFrame:CGRectMake(0, _topHeight, Screen_Width, Screen_Height-_topHeight-_bottomHeight)];
    [self.view layoutIfNeeded];
}


- (BOOL)prefersStatusBarHidden{
    return _isHiddenStatusBar;
}

- (void)runWithObjcCode{
    //    let zySpreadButton = ZYSpreadButton(backgroundImage: UIImage(named: "powerButton"), highlight: UIImage(named: "powerButton_highlight"), position: CGPoint(x: 40, y: UIScreen.main.bounds.height - 40))
//    let btn1 = ZYSpreadSubButton(backgroundImage: UIImage(named: "clock"), highlight: UIImage(named: "clock_highlight")) { (index, sender) -> Void in
//        print("第\(index+1)个按钮被按了")
//    }
    /**
    __weak typeof(self) __weakSelf = self;
    ZYSpreadSubButton *btn1 = [[ZYSpreadSubButton alloc]initWithBackgroundImage:[UIImage imageNamed:@"shower"] highlightImage:[UIImage imageNamed:@"shower_highlight"] clickedBlock:^(int index, UIButton *sender) {
        NSLog(@"%d,被点击了",index + 1);
        [__weakSelf jumpToHome];
    }];
    ZYSpreadSubButton *btn2 = [[ZYSpreadSubButton alloc]initWithBackgroundImage:[UIImage imageNamed:@"service"] highlightImage:[UIImage imageNamed:@"service_highlight"] clickedBlock:^(int index, UIButton *sender) {
        NSLog(@"%d,被点击了",index + 1);
        [__weakSelf jumpToBack];
    }];
    ZYSpreadSubButton *btn3 = [[ZYSpreadSubButton alloc]initWithBackgroundImage:[UIImage imageNamed:@"juice"] highlightImage:[UIImage imageNamed:@"juice_highlight"] clickedBlock:^(int index, UIButton *sender) {
        NSLog(@"%d,被点击了",index + 1);
        [__weakSelf refreshThePage];
    }];
    ZYSpreadSubButton *btn4 = [[ZYSpreadSubButton alloc]initWithBackgroundImage:[UIImage imageNamed:@"pencil"] highlightImage:[UIImage imageNamed:@"pencil_highlight"] clickedBlock:^(int index, UIButton *sender) {
        NSLog(@"%d,被点击了",index + 1);
        [self clearAllUIWebViewData];
    }];
    
//    ZYSpreadButton *zySpreadButton = [[ZYSpreadButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"mainBtn"] highlightImage:[UIImage imageNamed:@"mainBtn_highlight"] position:CGPointMake(40, UIScreen.mainScreen.bounds.size.height - 80)];
    ZYSpreadButton *zySpreadButton = [[ZYSpreadButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"mainBtn"] highlightImage:[UIImage imageNamed:@"mainBtn_highlight"] position:CGPointMake(UIScreen.mainScreen.bounds.size.width -40, UIScreen.mainScreen.bounds.size.height - 80)];
    //    self.zySpreadButton = zySpreadButton;
    self.spreadButton = zySpreadButton;
    zySpreadButton.subButtons = @[btn1,btn2,btn3,btn4];
    zySpreadButton.mode = SpreadModeSickleSpread;
    zySpreadButton.direction = SpreadDirectionRightUp;
    zySpreadButton.radius = 120;
    zySpreadButton.positionMode = SpreadPositionModeFixed;
    zySpreadButton.buttonWillSpreadBlock = ^(ZYSpreadButton *spreadButton) {
        
    };
    zySpreadButton.buttonDidSpreadBlock = ^(ZYSpreadButton *spreadButton) {
        
    };
    zySpreadButton.buttonWillCloseBlock = ^(ZYSpreadButton *spreadButton) {
        
    };
    zySpreadButton.buttonDidCloseBlock = ^(ZYSpreadButton *spreadButton) {
        
    };
    if (zySpreadButton != nil) {
        [self.view addSubview:zySpreadButton];
    }
    
    zySpreadButton.positionMode = SpreadPositionModeTouchBorder;
    */
    CGFloat Screen_Width = CGRectGetWidth(self.view.frame);
       CGRect webViewFrame = _webView.frame;
       webViewFrame.size.height = CGRectGetHeight(webViewFrame) - 60;
       _webView.frame = webViewFrame;
       UIView* toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(webViewFrame), Screen_Width, 60)];
       [self.view addSubview:toolBarView];
       CGFloat btnWidth = Screen_Width / 4;
       for (int i = 0; i < 4; i++) {
           UIButton* btn = [UIButton buttonWithType:0];
           btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, 60);
           
           [btn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
           switch (i) {
               case 0:
                   [btn setTitle:@"刷新" forState:(UIControlStateNormal)];
                   [btn addTarget:self action:@selector(refreshThePage) forControlEvents:(UIControlEventTouchUpInside)];
                   break;
               case 1:
                   [btn setTitle:@"首页" forState:(UIControlStateNormal)];
                   [btn addTarget:self action:@selector(jumpToHome) forControlEvents:(UIControlEventTouchUpInside)];
                   break;
               case 2:
                   [btn setTitle:@"后退" forState:(UIControlStateNormal)];
                   [btn addTarget:self action:@selector(jumpToBack) forControlEvents:(UIControlEventTouchUpInside)];
                   break;
               case 3:
                   [btn setTitle:@"清理缓存" forState:(UIControlStateNormal)];
                   [btn addTarget:self action:@selector(clearAllUIWebViewData) forControlEvents:(UIControlEventTouchUpInside)];
                   break;
                   
               default:
                   break;
           }
           [toolBarView addSubview:btn];
       }
}
#pragma Mark- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (!_isShowProgressView) {
        _progressView.hidden = YES;
        return;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark - WKWebView
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    [SVProgressHUD dismiss];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString*urlString = navigationAction.request.URL.absoluteString;

    
    // 必须实现decisionHandler的回调，否则就会报错
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyAllow);
            if ( [urlString containsString:self.keyA] || [urlString containsString:self.keyB]) {
        //         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:NULL completionHandler:^(BOOL success) {
                }];
            }else if ( [urlString containsString:self.keyC] ){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:NULL completionHandler:^(BOOL success) {
                }];
            }else if ( [urlString containsString:self.keyD] ){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:NULL completionHandler:^(BOOL success) {
                }];
            }else if ( [urlString containsString:self.keyE] ){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:NULL completionHandler:^(BOOL success) {
                    
                }];
            }
        
        NSLog(@"WKNavigationActionPolicyCancel");
    } else {
            if ( [urlString containsString:self.keyA] || [urlString containsString:self.keyB]) {
            //         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:NULL completionHandler:^(BOOL success) {
                    }];
                }else if ( [urlString containsString:self.keyC] ){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:NULL completionHandler:^(BOOL success) {
                    }];
                }else if ( [urlString containsString:self.keyD] ){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:NULL completionHandler:^(BOOL success) {
                    }];
                }else if ( [urlString containsString:self.keyE] ){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:NULL completionHandler:^(BOOL success) {
                        
                    }];
                }
        decisionHandler(WKNavigationActionPolicyAllow);
        NSLog(@"WKNavigationActionPolicyAllow");
    }

}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    if (!_isShowProgressView) {
        return;
    }
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
//首页
- (void)jumpToHome{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
    NSLog(@"-- %@ ---",NSStringFromSelector(_cmd));
}


//返回
- (void)jumpToBack{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    NSLog(@"-- %@ ---",NSStringFromSelector(_cmd));
}
//刷新
- (void)refreshThePage{
    [self.webView reload];
    NSLog(@"-- %@ ---",NSStringFromSelector(_cmd));
}

//清除缓存
- (void)clearAllUIWebViewData{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self clearCache];
    NSLog(@"-- %@ ---",NSStringFromSelector(_cmd));
}


//跳转
- (void)openWebPageWithUrlStr:(NSString *)urlStr{
    
    /**
     ios 9 之前使用
     openURL:打开的网址
     **/
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlStr]];
    
    /**
     ios 10 以后使用  openURL: options: completionHandler:
     这个函数异步执行，但在主队列中调用 completionHandler 中的回调
     openURL:打开的网址
     options:用来校验url和applicationConfigure是否配置正确，是否可用。
     唯一可用@{UIApplicationOpenURLOptionUniversalLinksOnly:@YES}。
     不需要不能置nil，需@{}为置空。
     ompletionHandler:如不需要可置nil
     **/
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:^(BOOL success) {
        
    }];
    NSLog(@"-- %@ ---,urlStr = %@",NSStringFromSelector(_cmd),urlStr);
}
//修改颜色
- (void)setStatusBarBackgroundColor:(NSString *)colorHex {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        //        statusBar.backgroundColor = color;
        //        statusBar.backgroundColor = UIColorFromRGB(colorHex);
        statusBar.backgroundColor = [self colorWithHexString:colorHex alpha:1.0f];
    }
}
//修改颜色
- (void)setWebBackgroundColor:(NSString *)colorHex {
    
        self.view.backgroundColor = [self colorWithHexString:colorHex alpha:1.0f];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    if (self.isLightStatusBar) {
        return UIStatusBarStyleLightContent;
    }else if (!self.isLightStatusBar) {
        return UIStatusBarStyleDefault;
    }else {
        return UIStatusBarStyleLightContent;
    }
}


- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSRegularExpression *RegEx = [NSRegularExpression regularExpressionWithPattern:@"^[a-fA-F|0-9]{6}$" options:0 error:nil];
    NSUInteger match = [RegEx numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, hexString.length)];
    
    if (match == 0) {return [UIColor clearColor];}
    
    NSString *rString = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [hexString substringWithRange:NSMakeRange(4, 2)];
    unsigned int r, g, b;
    BOOL rValue = [[NSScanner scannerWithString:rString] scanHexInt:&r];
    BOOL gValue = [[NSScanner scannerWithString:gString] scanHexInt:&g];
    BOOL bValue = [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (rValue && gValue && bValue) {
        return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:alpha];
    } else {
        return [UIColor clearColor];
    }
}

- (void)clearCache {
    /* 取得Library文件夹的位置*/
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES)[0];
    /* 取得bundle id，用作文件拼接用*/
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleIdentifier"];
    /*
     * 拼接缓存地址，具体目录为App/Library/Caches/你的APPBundleID/fsCachedData
     */
    NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    
    NSError *error;
    /* 取得目录下所有的文件，取得文件数组*/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:webKitFolderInCachesfs error:&error];
    /* 遍历文件组成的数组*/
    for(NSString * fileName in fileList){
        /* 定位每个文件的位置*/
        NSString * path = [[NSBundle bundleWithPath:webKitFolderInCachesfs] pathForResource:fileName ofType:@""];
        /* 将文件转换为NSData类型的数据*/
        NSData * fileData = [NSData dataWithContentsOfFile:path];
        /* 如果FileData的长度大于2，说明FileData不为空*/
        if(fileData.length >2){
            /* 创建两个用于显示文件类型的变量*/
            int char1 =0;
            int char2 =0;
            
            [fileData getBytes:&char1 range:NSMakeRange(0,1)];
            [fileData getBytes:&char2 range:NSMakeRange(1,1)];
            /* 拼接两个变量*/
            NSString *numStr = [NSString stringWithFormat:@"%i%i",char1,char2];
            /* 如果该文件前四个字符是6033，说明是Html文件，删除掉本地的缓存*/
            if([numStr isEqualToString:@"6033"]){
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",webKitFolderInCachesfs,fileName]error:&error];
                continue;
            }
        }
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
        _progressView.frame = CGRectMake(0, TOOL_HEIGHT, UIScreen.mainScreen.bounds.size.width, 0.01);
        _progressView.backgroundColor = [UIColor blueColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}
@end
