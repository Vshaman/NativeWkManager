//
//  NetWorkTool.m
//  NativeOrWKManager
//
//  Created by ox Ho on 2019/6/22.
//  Copyright © 2019 ZhanTeng. All rights reserved.
//

#import "NetWorkTool.h"

@implementation NetWorkTool


//初始服务器
+(void)ROOTNetworkingWihtInterFace:(NSString*)interface WithrequestDictionary:(NSMutableDictionary *)requestDictionary  success:(void (^)(NSDictionary* responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    
    NSError *error = nil;
    NSString *jsonString = @"";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted  error:&error];
    if (jsonData) {
        
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }else{
        NSLog(@"JSON字符串转换失败: %@, error: %@", requestDictionary, error);}
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];


    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];

        [manager GET:[NSString stringWithFormat:@"%@%@",ROOT_IPSEVER,interface] parameters:requestDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1001) {
                [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
            }
            failure(error);
        }];
}


//项目服务器
+(void)PROJECTNetworkingWihtInterFace:(NSString*)interface WithrequestDictionary:(NSMutableDictionary *)requestDictionary  success:(void (^)(NSDictionary* responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    
    NSError *error = nil;
    NSString *jsonString = @"";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted  error:&error];
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{NSLog(@"JSON字符串转换失败: %@, error: %@", requestDictionary, error);}
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
    
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",PROJECT_IPSEVER,interface] parameters:requestDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
        }
        failure(error);
    }];
}


//备份服务器
+(void)STANDBYNetworkingWihtInterFace:(NSString*)interface WithrequestDictionary:(NSMutableDictionary *)requestDictionary  success:(void (^)(NSDictionary* responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    
    NSError *error = nil;
    NSString *jsonString = @"";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted  error:&error];
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{NSLog(@"JSON字符串转换失败: %@, error: %@", requestDictionary, error);}
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
    
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",STANDBY_IPSEVER,interface] parameters:requestDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
        }
        failure(error);
    }];
}



+(void)MOCKNetworkingWihtInterFace:(NSString *)interface WithrequestDictionary:(NSDictionary *)requestDictionary success:(void (^)(NSDictionary * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure{
    NSError *error = nil;
       NSString *jsonString = @"";
       NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted  error:&error];
       if (jsonData) {
           jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       }else{NSLog(@"JSON字符串转换失败: %@, error: %@", requestDictionary, error);}
       AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
       
       manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
       
       
       manager.requestSerializer = [AFHTTPRequestSerializer serializer];
       manager.responseSerializer = [AFJSONResponseSerializer serializer];
       
       manager.requestSerializer.timeoutInterval = 10;
       [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
       
       [manager GET:[NSString stringWithFormat:@"%@%@",MOCK_IPSEVER,interface] parameters:requestDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
           success(responseObject);
           
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           if (error.code == -1001) {
               [SVProgressHUD showErrorWithStatus:@"网络请求超时"];
           }
           failure(error);
       }];
}
@end
