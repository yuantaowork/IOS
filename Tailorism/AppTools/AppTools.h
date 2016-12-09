//
//  AppTools.h
//  Tailorism
//
//  Created by 袁Sir on 16/11/9.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(id result);
typedef void(^Fail)(id result);

@interface AppTools : NSObject

+ (void)postDataWithHttp:(NSString *)url WithPara:(NSDictionary *)para andSuccessBlock:(Success)success andErrorBlock:(Fail)fail;

+ (NSString *)isNallString:(id)str;

@end
