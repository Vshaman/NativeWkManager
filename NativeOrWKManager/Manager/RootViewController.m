//
//  RootViewController.m
//  NativeOrWKManager
//
//  Created by ox Ho on 2019/6/22.
//  Copyright © 2019 ZhanTeng. All rights reserved.
//

#import "RootViewController.h"
#import "NetWorkTool.h"
#import "RootModel.h"
#import <JSONModel.h>
#import "NSString+Hash.h"
#import "RootReturnModel.h"
#import "AppDelegate.h"
#import "NativeVC.h"
#import "WebViewController.h"
#import "ProjectModel.h"
#import "AVOSCloudManager.h"
#import <SafariServices/SafariServices.h>

@interface RootViewController ()<SFSafariViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *reConnect;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *lauchImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    lauchImage.contentMode = UIViewContentModeScaleAspectFill;
    if ([UIImage imageNamed:@"1242_2688"]) {
        [lauchImage setImage:[UIImage imageNamed:@"1242_2688"]];
    }
    
    [self.view insertSubview:lauchImage atIndex:0];
    [self.reConnect addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
   
//    [self ROOTNetwork];
    [self STANDBYNetwork];
//     [self PROJECTNetwork];
//    [self AVOSCloud];
//    [self AppStoreNetworkMock];
//    [self AppStoreNetworkMock];
//    [self AppStoreNetworkLeanCloud];
}


/**
//初始服务器
- (void)ROOTNetwork{
    
    RootModel* rootModel = [RootModel new];
    rootModel.uuid = [PROJECT_ID sha1String];
    [NetWorkTool ROOTNetworkingWihtInterFace:ROOTNETWORK WithrequestDictionary:[[rootModel toDictionary] mutableCopy] success:^(NSDictionary * _Nonnull responseObject) {
        RootReturnModel* respModel = [RootReturnModel initWithDictionary:responseObject];
        NSLog(@"PROJECT_VERSION = %@",PROJECT_VERSION);
        switch ([responseObject[@"code"] intValue]) {
            case 200:
            {
                if (respModel.isLeanCloud) {
                    
                    [self AppStoreNetworkLeanCloud];
                    
                } else {
                    
                    if ([respModel.version isEqualToString:PROJECT_VERSION]) {
                        NSLog(@"走项目");
                        [self PROJECTNetwork];
                        
                    } else {
                        NSLog(@"走B");
                        [self showNative];
                        
                    }
                    
                }
            }
                break;
            case 500:
            {
                [self AppStoreNetwork];
            }
                break;
                
            default:
            {
                [self AppStoreNetwork];
            }
                break;
        }
        
    } failure:^(NSError * _Nonnull error) {
        //初始服务器请求失败
        [self AppStoreNetwork];
    }];
}
 */
/**
//项目服务器
- (void)PROJECTNetwork{
    
    RootModel* rootModel = [RootModel new];
    rootModel.uuid = [PROJECT_ID sha1String];
    [NetWorkTool PROJECTNetworkingWihtInterFace:PROJECTNETWORK WithrequestDictionary:[[rootModel toDictionary] mutableCopy] success:^(NSDictionary * _Nonnull responseObject) {
        ProjectModel* projectModel = [ProjectModel initWithData:responseObject];
        //初始服务器请求成功
        if ([projectModel.code isEqualToString:@"200"]) {
            [self showAVCWithModel:projectModel.config];
        }else{//走备份
            [self AVOSCloud];
        }
    } failure:^(NSError * _Nonnull error) {
        //走备份
         [self AVOSCloud];
    }];
}
- (void)AVOSCloud{
    [AVOSCloudManager registAVOS];
    [AVOSCloudManager AVOSGetFetchUUID:[PROJECT_ID sha1String] Result:^(ProjectModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            if (model.config.isAppStore) {
                [self showNative];
            } else {
                [self showAVCWithModel:model.config];
            }
        } else {
            [self AppStoreNetworkMock];
        }
    }];
}
//MOCK
- (void)MOCKRequest{
    
    [NetWorkTool MOCKNetworkingWihtInterFace:MOCKNETWORK WithrequestDictionary:@{} success:^(NSDictionary * _Nonnull responseObject) {
        ConfigModel* configModel = [ConfigModel initWithData:responseObject];
        if (configModel) {
            [self showAVCWithModel:configModel];
        } else {
            [self STANDBYNetwork];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self STANDBYNetwork];
    }];
}
 */
//备份服务器
- (void)STANDBYNetwork{
    
    RootModel* rootModel = [RootModel new];
    rootModel.uuid = [PROJECT_ID sha1String];
    [NetWorkTool STANDBYNetworkingWihtInterFace:STANDBYNETWORK WithrequestDictionary:[[rootModel toDictionary] mutableCopy] success:^(NSDictionary * _Nonnull responseObject) {
        
        ProjectModel* projectModel = [ProjectModel initWithData:responseObject];
        //备份服务器请求成功
        if ([projectModel.code isEqualToString:@"200"]) {
            [self showAVCWithModel:projectModel.config];
        }else{//走最终
            self.reConnect.hidden = NO;
            self.activityView.hidden = YES;
        }
    } failure:^(NSError * _Nonnull error) {
        //走最终失败显示按钮
        self.reConnect.hidden = NO;
        self.activityView.hidden = YES;
    }];
}



//是否正在审核
- (void)AppStoreNetwork{
    
    RootModel* rootModel = [RootModel new];
    rootModel.uuid = [PROJECT_ID sha1String];
    [NetWorkTool PROJECTNetworkingWihtInterFace:PROJECTNETWORK WithrequestDictionary:[[rootModel toDictionary] mutableCopy] success:^(NSDictionary * _Nonnull responseObject) {
        ProjectModel* projectModel = [ProjectModel initWithData:responseObject];
        //是否在审核
       switch (projectModel.code.intValue) {
        case 200://返回200-由项目服务器控制开关以及域名
        {
            if (projectModel.config.isAppStore) {
                          
                          [self showNative];
                          
                      } else {
                       
                          [self showAVCWithModel:projectModel.config];
                      }
        }
            break;
        case 500://返回500-由leanCloud控制开关以及域名
        {
              [self STANDBYNetwork];
        }
            break;
           default://其他情况显示重新加载按钮
        {
            [self STANDBYNetwork];
        }
            break;
       }
    } failure:^(NSError * _Nonnull error) {
        //走备份
       [self STANDBYNetwork];
    }];
}


//是否正在审核
- (void)AppStoreNetworkLeanCloud{
    
    [AVOSCloudManager registAVOS];
#ifdef DEBUG
    [AVOSCloudManager creatAVOS];
#endif
    [AVOSCloudManager AVOSGetFetchUUID:[PROJECT_ID sha1String] Result:^(ProjectModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            if (model.config.isAppStore) {
                [self showNative];
            } else {
                [self showAVCWithModel:model.config];
            }
        } else {
            [self AppStoreNetworkMock];
        }
    }];
}
//是否正在审核
- (void)AppStoreNetworkMock{
    

    [NetWorkTool MOCKNetworkingWihtInterFace:MOCKNETWORK WithrequestDictionary:@{} success:^(NSDictionary * _Nonnull responseObject) {
        ConfigModel* configModel = [ConfigModel initWithData:responseObject];
        
        if (configModel) {
            if (configModel.isAppStore) {
                 [self showNative];
            } else {
                [self showAVCWithModel:configModel];
            }
        } else {
            
            [self AppStoreNetwork];
            
        }
    } failure:^(NSError * _Nonnull error) {
        [self AppStoreNetwork];
    }];
}
//B原生
- (void)showNative{
    
    NativeVC* vc = [NativeVC new];
    
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = vc;
    [delegate.window makeKeyWindow];
    self.reConnect.hidden = NO;
    self.activityView.hidden = YES;
}

//AWeb
- (void)showAVCWithModel:(ConfigModel*)model{
    if (model.isUseSafariVC) {
        
    SFSafariViewController*safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:model.base]];
    safariVC.delegate = self;
    
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = safariVC;
    [delegate.window makeKeyWindow];
        
    } else {
        
    WebViewController*webVC = [[WebViewController alloc]init];
    webVC.urlString = model.base;
    webVC.keyA = model.keyA;
    webVC.keyB = model.keyB;
    webVC.keyC = model.keyC;
    webVC.keyD = model.keyD;
    webVC.keyE = model.keyE;
    webVC.suspendBtn = model.suspendBtn;
    webVC.configModel = model;
    AppDelegate * delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = webVC;
    [delegate.window makeKeyWindow];
        
    }
}
//点击重试，走项目
- (void)retryBtnClick:(UIButton *)sender{
    sender.hidden = YES;
    self.activityView.hidden = NO;
    [self AppStoreNetworkLeanCloud];
}
#pragma Mark -SFSafariViewControllerDelegate


@end
