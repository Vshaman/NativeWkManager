//
//  RootReturnModel.m
//  NativeOrWKManager
//
//  Created by ox Ho on 2019/6/22.
//  Copyright © 2019 ZhanTeng. All rights reserved.
//

#import "RootReturnModel.h"

@implementation RootReturnModel

+(instancetype)initWithDictionary:(NSDictionary*)dicts{
    
    RootReturnModel* respModel = [[RootReturnModel alloc] initWithDictionary:dicts error:nil];
    
    return respModel;
}

@end
