//
//  LYFmdbTool.h
//  Tailorism
//
//  Created by LIZhenNing on 16/5/24.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface LYFmdbTool : NSObject

+(BOOL)insertMember:(NSArray *)arry del:(BOOL)del appdelegate:(BOOL)appdelegate;
+(BOOL)insertMember2:(NSArray *)arry;
+(BOOL)insertMember3:(NSArray *)arry;
+(BOOL)fabricListdb:(NSArray *)arry del:(BOOL)del;
+(BOOL)insertMemberName:(NSArray *)arry;
+(BOOL)insertMemberName2:(NSArray *)arry;
+(BOOL)insertMemberName3:(NSArray *)arry;
+(BOOL)insertOrderList:(NSArray *)arry;


+(BOOL)insertImageName:(NSArray *)arry del:(BOOL)del;
+(BOOL)insertImageName2:(NSArray *)arry del:(BOOL)del;

+ (NSArray *)queryData:(NSString *)querySql;
+ (NSArray *)queryData2:(NSString *)querySql;
+ (NSArray *)queryData3:(NSString *)querySql;

+(BOOL)uplodMember:(NSArray *)arry del:(BOOL)del;
+(BOOL)uplodOrderList:(NSArray *)arry del:(BOOL)del;

+(BOOL)userList:(NSArray *)arry;

+(BOOL)deleteDB:(NSString*)sqlstr;
+(BOOL)dropDB:(NSString*)sqlstr;
@end
