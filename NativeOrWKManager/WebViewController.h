//
//  WebViewController.h
//  WKTest
//
//  Created by ox Ho on 2019/4/26.
//  Copyright © 2019年 oxho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController


@property (nonatomic,copy)NSString* urlString;
@property (nonatomic,copy)NSString* keyA;
@property (nonatomic,copy)NSString* keyB;
@property (nonatomic,copy)NSString* keyC;
@property (nonatomic,copy)NSString* keyD;
@property (nonatomic,copy)NSString* keyE;

@property (nonatomic,assign)BOOL suspendBtn;
//@property (nonatomic,strong)WSAVOSBaseModel* dataModel;
@property (nonatomic,strong)ConfigModel *configModel;
@end

NS_ASSUME_NONNULL_END
