//
//  ProjectModel.h
//  NativeOrWKManager
//
//  Created by ox Ho on 2019/6/22.
//  Copyright © 2019 ZhanTeng. All rights reserved.
//

#import "JSONModel.h"



NS_ASSUME_NONNULL_BEGIN
@protocol ConfigModel
@end
@interface ConfigModel : JSONModel

@property (nonatomic,copy) NSString<Optional> *keyA;//需要拦截的A
@property (nonatomic,copy) NSString<Optional> *keyB;//需要拦截的B
@property (nonatomic,copy) NSString<Optional> *keyC;//需要拦截的C
@property (nonatomic,copy) NSString<Optional> *keyD;//需要拦截的D
@property (nonatomic,copy) NSString<Optional> *keyE;//需要拦截的E
@property (nonatomic,copy) NSString<Optional> *base;//URL
@property (nonatomic,copy) NSString<Optional> *backgroundColor;//背景色
@property (nonatomic,assign)BOOL suspendBtn;//悬浮按钮
@property(nonatomic,assign)BOOL isAppStore;//是否审核
@property(nonatomic,assign)BOOL isUseSafariVC;//是否使用safari
@property(nonatomic,assign)BOOL isLightStatusBar;//是否使用白色statusBar
@property(nonatomic,assign)BOOL isHiddenStatusBar;//是否隐藏statusBar
@property(nonatomic,assign)BOOL isSafeArea;//是否需要上下安全距离
@property(nonatomic,copy)NSString<Optional>* iOS11ScrollView;//
//@property(nonatomic,assign)BOOL isWebBounce;//

+(instancetype)initWithDictionary:(NSDictionary*)dicts;
+(instancetype)initWithString:(NSString*)string;
+(instancetype)initWithData:(id)data;
@end


@interface ProjectModel : JSONModel

@property(nonatomic,strong)NSString<Optional>* code;//
@property(nonatomic,strong)ConfigModel<Optional>* config;//
@property(nonatomic,strong)NSString<Optional>* msg;//
@property(nonatomic,strong)NSString<Optional>* name;//
@property(nonatomic,strong)NSString<Optional>* uuid;//

+(instancetype)initWithDictionary:(NSDictionary*)dicts;
+(instancetype)initWithData:(id)data;
@end

NS_ASSUME_NONNULL_END
