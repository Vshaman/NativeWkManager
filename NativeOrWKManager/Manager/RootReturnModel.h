//
//  RootReturnModel.h
//  NativeOrWKManager
//
//  Created by ox Ho on 2019/6/22.
//  Copyright © 2019 ZhanTeng. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootReturnModel : JSONModel

@property(nonatomic,strong)NSString* code;//
@property(nonatomic,strong)NSString* msg;//返回消息
@property(nonatomic,strong)NSString* name;//app名字
@property(nonatomic,strong)NSString* uuid;//
@property(nonatomic,strong)NSString* version;//版本号

@property(nonatomic,assign)integer_t isLeanCloud;//是否直接走leanCloud

+(instancetype)initWithDictionary:(NSDictionary*)dicts;
@end

NS_ASSUME_NONNULL_END
