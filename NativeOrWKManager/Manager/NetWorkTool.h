//
//  NetWorkTool.h
//  NativeOrWKManager
//
//  Created by ox Ho on 2019/6/22.
//  Copyright © 2019 ZhanTeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <SVProgressHUD.h>
NS_ASSUME_NONNULL_BEGIN

#define PROJECT_ID [[NSBundle mainBundle]bundleIdentifier]//获取bundleID
#define PROJECT_VERSION [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]//获取版本号

#define ROOT_IPSEVER @"http://34.97.212.169"//初始
//#define ROOT_IPSEVER @"http://192.168.1.66:"//秦先生
#define PROJECT_IPSEVER @"http://116.62.154.14"//项目
#define STANDBY_IPSEVER @"http://35.221.195.212"//备份

#define MOCK_IPSEVER @"http://mock-api.com/7gPXRVgl.mock/"//MOCK
//初始请求
#define ROOTNETWORK @":3000/latestNews"


//项目请求
#define PROJECTNETWORK @":3000/latestNews"

//备份请求
#define STANDBYNETWORK @":3000/latestNews"

//终极备份请求
#define ULTIMATESTANDBYNETWORK @":3000/latestNews"
//MOCK请求
#define MOCKNETWORK @"getLeanCloud"
@interface NetWorkTool : NSObject

//初始服务器
+(void)ROOTNetworkingWihtInterFace:(NSString*)interface WithrequestDictionary:(NSMutableDictionary *)requestDictionary  success:(void (^)(NSDictionary* responseObject))success
                         failure:(void (^)(NSError *error))failure;

//项目服务器
+(void)PROJECTNetworkingWihtInterFace:(NSString*)interface WithrequestDictionary:(NSMutableDictionary *)requestDictionary  success:(void (^)(NSDictionary* responseObject))success
                           failure:(void (^)(NSError *error))failure;


//备份服务器
+(void)STANDBYNetworkingWihtInterFace:(NSString*)interface WithrequestDictionary:(NSMutableDictionary *)requestDictionary  success:(void (^)(NSDictionary* responseObject))success
                              failure:(void (^)(NSError *error))failure;


//MOCK
+(void)MOCKNetworkingWihtInterFace:(NSString*)interface WithrequestDictionary:(NSDictionary *)requestDictionary  success:(void (^)(NSDictionary* responseObject))success
failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
