//
//  NetWorkRequest.h
//  oc-AFN
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 wangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RequestMethod)
{
    put,
    get,
    post,
    patch,
    Detele,
    
};

@class AFHTTPRequestOperation;
@protocol NetWorkRequestDelegate;



@interface NetWorkRequest : NSObject

+(void)netWorkRequestData:(RequestMethod)requestMethod url:(NSString *)url parameters:(NSMutableDictionary *)postInfo requestName:(NSString*)getRequestName delegate:(id)getDelegate;

+ (void)uploadPhoto:(RequestMethod)requestMethod url:(NSString *)url image:(UIImage *)image name:(NSString *)name imageName:(NSString *)imageName requestName:(NSString*)getRequestName delegate:(id)getDelegate;

+(void)successResponseDatas:(id)responseData Delegate:(id)postDelegate requestName:(NSString *)getRequestName parameters:(NSDictionary *)getparameters statusCode:(NSInteger)statusCode;

+ (void)failedResponseDatas:(id)postDelegate Error:(NSError *)error requestName:(NSString *)getRequestName task:(NSURLSessionDataTask *)task parameters:(NSDictionary *)getparameters;

@end



@protocol NetWorkRequestDelegate <NSObject>

-(void)netWorkRequestSuccess:(id)data requestName:(NSString *)getRequestName parameters:(NSDictionary *)getparameters statusCode:(NSInteger)statusCode;
-(void)netWorkRequestFailed:(NSError*)error requestName:(NSString *)getRequestName parameters:(NSDictionary *)getparameters statusCode:(NSInteger)statusCode;

@optional


@end
