//
//  RootModel.h
//  NativeOrWKManager
//
//  Created by ox Ho on 2019/6/22.
//  Copyright © 2019 ZhanTeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface RootModel : JSONModel

@property(nonatomic,strong)NSString* uuid;//验证码

@end

NS_ASSUME_NONNULL_END
