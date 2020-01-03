//
//  AVOSCloudManager.h
//  WheatStone
//
//  Created by 孟子弘 on 2019/3/12.
//  Copyright © 2019年 mzh. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <AVOSCloud/AVOSCloud.h>
#import "AVOSCloudManager.h"
#import "ProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVOSCloudManager : NSObject

+(void)registAVOS;
+(void)creatAVOS;
+(void)AVOSGetFetchResult:(void(^)(ProjectModel* _Nullable model,NSError * _Nullable error))result;
+(void)AVOSGetFetchUUID:(NSString*)uuid Result:(void (^)(ProjectModel * _Nullable model, NSError * _Nullable error))result;

@end

NS_ASSUME_NONNULL_END
