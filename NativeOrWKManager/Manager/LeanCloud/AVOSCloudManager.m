//
//  AVOSCloudManager.m
//  WheatStone
//
//  Created by 孟子弘 on 2019/3/12.
//  Copyright © 2019年 mzh. All rights reserved.
//

//LeanCloudAppkey
#define AVOSCloud_AppKey @"8Alg8VyuyvVh3f95WbaEnyal"
//#define AVOSCloud_AppKey @"K3asD6hSH7ABSIb7K003D7ic"
//LeanCloudAppId
#define AVOSCloud_AppId @"SNNS2EAd4yugttJJuGvAh8t0-MdYXbMMI"
//#define AVOSCloud_AppId @"0cGIaNBRm6s75CDB0s5B8djM-MdYXbMMI"
//LeanCloudObject_IdI
#define AVOSCloud_Object_Id @"5da96e2042e7620009fdc113"
//#define AVOSCloud_Object_Id @"5dad450f42e762000901a728"

//LeanCloudClassName
#define AVOSCloud_ClassName @"iOS_Project"



#import "AVOSCloudManager.h"
#import <YYModel/YYModel.h>


@interface AVOSCloudManager()

//@property (nonatomic,assign) BOOL isTest;
//@property (nonatomic,copy) WSAVOSBaseModel* model;


@end

@implementation AVOSCloudManager
static NSString *baseUrl;
static ProjectModel *model;
static AVObject * _Nullable objectt;
//step1 注册Cloud
+(void)registAVOS{
     [AVOSCloud setApplicationId:AVOSCloud_AppId clientKey:AVOSCloud_AppKey];
}





/*step2
 通过表名（ClassName） 对应ID，获取数据，
 **/
+(void)AVOSGetFetchResult:(void(^)(ProjectModel* _Nullable model,NSError * _Nullable error))result{
    AVObject *objc = [AVObject objectWithClassName:AVOSCloud_ClassName objectId:AVOSCloud_Object_Id];
    
    [objc fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (object && !error) {
            
            model = [ProjectModel initWithDictionary:[object dictionaryForObject]];
            model.config = [ConfigModel initWithString:object[@"config"]];
            
            
        }
        if (!result) {return;}
        result(model,error);

    }];


}

+(void)AVOSGetFetchUUID:(NSString *)uuid Result:(void (^)(ProjectModel * _Nullable model, NSError * _Nullable error))result{
    AVQuery *query = [AVQuery queryWithClassName:AVOSCloud_ClassName];
    [query whereKey:@"uuid" equalTo:uuid];
   
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (object && !error) {
            
            model = [ProjectModel initWithData:[object dictionaryForObject]];
            
            if (object[@"config"]) { model.config = [ConfigModel initWithData:object[@"config"]];}
            
        }
        if (!result) {return;}
        result(model,error);
    }];
}
@end
