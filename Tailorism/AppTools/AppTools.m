//
//  AppTools.m
//  Tailorism
//
//  Created by 袁Sir on 16/11/9.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "AppTools.h"

@implementation AppTools

+ (void)postDataWithHttp:(NSString *)url WithPara:(NSDictionary *)para andSuccessBlock:(Success)success andErrorBlock:(Fail)fail {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
        
    }];
}

+ (NSString *)isNallString:(id)str {
    if ([str isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([str isEqualToString:@"<null>"]) {
        return @"";
    }
    else if ([str isEqual:@"0.0"]) {
        return @"";
    }
    else {
        return str;
    }
}

@end
