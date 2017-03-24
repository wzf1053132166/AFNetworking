//
//  NetWorkRequest.m
//  oc-AFN
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 wangzhifei. All rights reserved.
//

#import "NetWorkRequest.h"
#import "AFNetworking.h"

#define NetworkTimeoutTime 10

@implementation NetWorkRequest

#pragma mark - For Server

#pragma mark -- 服务器请求
+(void)netWorkRequestData:(RequestMethod)requestMethod url:(NSString *)url parameters:(NSMutableDictionary *)postInfo requestName:(NSString*)getRequestName delegate:(id)getDelegate{
    
    NSString *getUrl = nil;
    
    getUrl = url;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //配置双向https 会用到，(自建证书)
//    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    //配置头token 多点登录会用到
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", "服务器返回的给的token"] forHTTPHeaderField:@"Authorization"];
    
    //注意：默认的Response为json数据
//    [manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
    
    //使用这个将得到的是NSData
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //使用这个将得到的是JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //注意：此行不加也可以
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/plain",@"text/javascript", nil];
    
    manager.requestSerializer.timeoutInterval = NetworkTimeoutTime;
    
    switch (requestMethod) {
        case post:
        {
            [manager POST:url parameters:postInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
                [self successResponseDatas:responseObject Delegate:getDelegate requestName:getRequestName parameters:postInfo statusCode:responses.statusCode];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                [self failedResponseDatas:getDelegate Error:error requestName:getRequestName task:task parameters:postInfo];
             
            }];
        }
            break;
        case get:
        {
            [manager GET:url parameters:postInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
                [self successResponseDatas:responseObject Delegate:getDelegate requestName:getRequestName parameters:postInfo statusCode:responses.statusCode];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self failedResponseDatas:getDelegate Error:error requestName:getRequestName task:task parameters:postInfo];
            }];
        }
            break;
        case put:
        {
            [manager PUT:url parameters:postInfo success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
                [self successResponseDatas:responseObject Delegate:getDelegate requestName:getRequestName parameters:postInfo statusCode:responses.statusCode];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self failedResponseDatas:getDelegate Error:error requestName:getRequestName task:task parameters:postInfo];
            }];
        }
            break;
        case patch:
        {
            [manager PATCH:url parameters:postInfo success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
                [self successResponseDatas:responseObject Delegate:getDelegate requestName:getRequestName parameters:postInfo statusCode:responses.statusCode];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self failedResponseDatas:getDelegate Error:error requestName:getRequestName task:task parameters:postInfo];
            }];
        }
            break;
        case Detele:
        {
            [manager DELETE:url parameters:postInfo success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
                [self successResponseDatas:responseObject Delegate:getDelegate requestName:getRequestName parameters:postInfo statusCode:responses.statusCode];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self failedResponseDatas:getDelegate Error:error requestName:getRequestName task:task parameters:postInfo];
            }];
        }
            break;
       
        default:
            break;
    }
    
    
   

}

#pragma mark - 单个图片文件上传
//url 服务器地址,image图片，name要上传的服务器图片字段，imageName图片名字
+ (void)uploadPhoto:(RequestMethod)requestMethod url:(NSString *)url image:(UIImage *)image name:(NSString *)name imageName:(NSString *)imageName requestName:(NSString*)getRequestName delegate:(id)getDelegate{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = NetworkTimeoutTime;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);

    switch (requestMethod) {
        case post:
        {
            [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                [formData appendPartWithFileData:imageData name:name fileName:imageName mimeType:@"image/jpeg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
                {
                    [self successResponseDatas:responseObject Delegate:getDelegate requestName:getRequestName parameters:nil statusCode:responses.statusCode];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self failedResponseDatas:getDelegate Error:error requestName:getRequestName task:task parameters:nil];
            }];
        }
            
            break;
            
        case patch:
        {
//            如果特殊需求，只使用patch上传图片文件，需要进入AFN源文件将post多点上传那份代码复制一份才可以使用，AFN默认只有post上传
        }
            break;
        default:
            break;
    }
    
    
}


#pragma mark - 代理

+(void)successResponseDatas:(id)responseData Delegate:(id)postDelegate requestName:(NSString *)getRequestName parameters:(NSDictionary *)getparameters statusCode:(NSInteger)statusCode
{
    @try
    {
//        注意
        //这里可根据服务器返回statusCode来修改，正常情况默认200为成功，如果有特殊情况，401，201,所以暂时改为默认200为成功
        
        if (statusCode == 200) {
            
            if(postDelegate && [postDelegate respondsToSelector:@selector(netWorkRequestSuccess:requestName:parameters:statusCode:)])
            {
                [postDelegate netWorkRequestSuccess:responseData requestName:getRequestName parameters:getparameters statusCode:statusCode];
            }
        }
        else
        {
            if(postDelegate && [postDelegate respondsToSelector:@selector(netWorkRequestFailed:requestName:parameters:statusCode:)])
            {
                [postDelegate netWorkRequestFailed:responseData requestName:getRequestName parameters:getparameters statusCode:statusCode];
            }
        }
        
    }
    @catch (NSException *e)
    {
        
    }
}

+ (void)failedResponseDatas:(id)postDelegate Error:(NSError *)error requestName:(NSString *)getRequestName task:(NSURLSessionDataTask *)task parameters:(NSDictionary *)getparameters
{
    NSLog(@"请求失败 请求名字为:%@ 错误原因:%@ %@",getRequestName,error ,task.currentRequest.URL.absoluteString);
    NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;

    
    if(postDelegate && [postDelegate respondsToSelector:@selector(netWorkRequestFailed:requestName:parameters:statusCode:)])
    {
        [postDelegate netWorkRequestFailed:error requestName:getRequestName parameters:getparameters statusCode:responses.statusCode];
    }
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    /**** SSL Pinning ****/
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ser" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setPinnedCertificates:[NSSet setWithArray:@[certData]]];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    //    securityPolicy.validatesCertificateChain = NO;
    
    return securityPolicy;
}


@end
