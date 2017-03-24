//
//  ViewController.m
//  oc-AFN
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 wangzhifei. All rights reserved.
//

#import "ViewController.h"
#import "NetWorkRequest.h"

#define GetLoginKey @"GetLoginKey"
#define GetOutKey @"GetOutKey"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self accessToServerForGetGetLogin];
}

#pragma mark -- 网络请求
-(void)accessToServerForGetGetLogin
{
    
    NSString *url = @"http://apis.haoservice.com/lifeservice/cook/query?";
    NSMutableDictionary *postInfo = [NSMutableDictionary dictionary];
    postInfo[@"menu"] = @"土豆";
    postInfo[@"pn"] = @1;
    postInfo[@"rn"] = @"10";
    postInfo[@"key"] = @"2ba215a3f83b4b898d0f6fdca4e16c7c";
    [NetWorkRequest netWorkRequestData:get url:url parameters:postInfo requestName:GetLoginKey delegate:self];
    
    [NetWorkRequest netWorkRequestData:post url:url parameters:postInfo requestName:GetOutKey delegate:self];
    
//  如果特殊需求，只使用patch上传图片文件，需要进入AFN源文件将post多点上传那份代码复制一份才可以使用，AFN默认只有post上传
//    [NetWorkRequest uploadPhoto:post url:@"" image:nil name:@"服务器字段" imageName:@"图片名字" requestName:@"自己写的返回代理时的名字" delegate:self];
    
}


-(void)netWorkRequestSuccess:(id)data requestName:(NSString *)getRequestName parameters:(NSDictionary *)getparameters statusCode:(NSInteger)statusCode{
    NSDictionary *dicR = (NSDictionary *)data;
    if ([getRequestName isEqualToString:GetLoginKey]) {
        
        NSLog(@"%@",dicR);
        
    }else if ([getRequestName isEqualToString:GetOutKey]){
        
        NSLog(@"%@",dicR);
    }
}

-(void)netWorkRequestFailed:(NSError*)error requestName:(NSString *)getRequestName parameters:(NSDictionary *)getparameters statusCode:(NSInteger)statusCode{
    //服务器连接失败请重试
    NSLog(@"%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
