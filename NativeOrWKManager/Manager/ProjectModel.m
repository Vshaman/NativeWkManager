//
//  ProjectModel.m
//  NativeOrWKManager
//
//  Created by ox Ho on 2019/6/22.
//  Copyright © 2019 ZhanTeng. All rights reserved.
//

#import "ProjectModel.h"
#import "NetWorkTool.h"
#import "NSString+Hash.h"

@implementation ConfigModel
+(instancetype)initWithString:(NSString*)string{
    ConfigModel* chrildModel = [[ConfigModel alloc] initWithString:string usingEncoding:NSUTF8StringEncoding error:nil];
    return chrildModel;
}
+(instancetype)initWithDictionary:(NSDictionary*)dicts{
    ConfigModel* chrildModel = [[ConfigModel alloc] initWithDictionary:dicts error:nil];
    return chrildModel;
}
+(instancetype)initWithData:(id)data{
    ConfigModel*configModel;
    if ([data isKindOfClass:[NSString class]]) {
        configModel = [[ConfigModel alloc] initWithString:(NSString*)data error:nil];
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        configModel = [[ConfigModel alloc] initWithDictionary:(NSDictionary*)data error:nil];
    } else if ([data isKindOfClass:[NSData class]]) {
        configModel = [[ConfigModel alloc] initWithData:(NSData*)data error:nil];
    }
    return configModel;
}
@end

@implementation ProjectModel
+(instancetype)creatForAVOS{
    ConfigModel* model = [ConfigModel new];
    model.backgroundColor = @"#ffffff";
    model.iOS11ScrollView = @"0";
    model.base = @"";
    model.isAppStore = YES;
    model.isSafeArea = YES;
    model.isUseSafariVC = YES;
    model.isLightStatusBar = YES;
    model.isHiddenStatusBar = YES;
    model.suspendBtn = YES;
    model.keyA = @"";
    model.keyB = @"";
    model.keyC = @"";
    model.keyD = @"";
    model.keyE = @"";
    
    ProjectModel* pModel = [ProjectModel new];
    pModel.code = @"200";
    pModel.msg = @"Success";
    pModel.name = PROJECT_NAME;
    pModel.uuid = [PROJECT_ID sha1String];
    pModel.config = model;

    
    return pModel;
}
+(instancetype)initWithDictionary:(NSDictionary*)dicts{
    
    ProjectModel* respModel = [[ProjectModel alloc] initWithDictionary:dicts error:nil];
    
    return respModel;
}
+(instancetype)initWithData:(id)data{
    ProjectModel*projectModel;
    if ([data isKindOfClass:[NSString class]]) {
        projectModel = [[ProjectModel alloc] initWithString:(NSString*)data error:nil];
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        projectModel = [[ProjectModel alloc] initWithDictionary:(NSDictionary*)data error:nil];
    } else if ([data isKindOfClass:[NSData class]]) {
        projectModel = [[ProjectModel alloc] initWithData:(NSData*)data error:nil];
    }
    return projectModel;
}
@end
