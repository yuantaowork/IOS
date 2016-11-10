//
//  LYFmdbTool.m
//  Tailorism
//
//  Created by LIZhenNing on 16/5/24.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "LYFmdbTool.h"
#import "FMDB.h"


#define LVSQLITE_NAME @"TailorismDB.sqlite"

@implementation LYFmdbTool

static FMDatabase *_fmdb;
static NSLock *_lock;//锁

+ (void)initialize {
    // 执行打开数据库和创建表操作
    
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    NSLog(@"数据库目录：%@",filePath);
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    //    [_fmdb open];
    
}

+(BOOL)insertMember:(NSArray *)arry del:(BOOL)del appdelegate:(BOOL)appdelegate
{
    
    
    BOOL success = NO;
    
    if ([_fmdb open]) {
        [_lock lock];
        
        
        FMResultSet *rs = [_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"t_member"];
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            NSLog(@"isTableOK %ld", (long)count);
            
            if (0 != count)
            {
                if (!appdelegate) {
                    if (del)
                    {
                        if ([_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"t_member"]) {
                            
                            [_fmdb executeUpdate:@"drop table t_member"];
                            
                        }
                    }
                    
                    [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_member(%@)",[LYFmdbTool caretasqlstr:arry]]];
                    NSMutableDictionary * datadic = nil;
                    
                    for (int i = 0; i<arry.count; i++)
                    {
                        datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
                        if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into t_member values(%@)",[LYFmdbTool insertsqlstr:arry]] withParameterDictionary:datadic]) {
                            
                            success = YES;
                        }else
                        {
                            success = NO;
                        }
                    }
                }
                
                
            }else
            {
                
                [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_member(%@)",[LYFmdbTool caretasqlstr:arry]]];
                NSMutableDictionary * datadic = nil;
                
                for (int i = 0; i<arry.count; i++)
                {
                    datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
                    if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into t_member values(%@)",[LYFmdbTool insertsqlstr:arry]] withParameterDictionary:datadic]) {
                        
                        success = YES;
                    }else
                    {
                        success = NO;
                    }
                }
            }
            
        }
    }
    [_fmdb close];
    [_lock unlock];
    return success;
}

+(BOOL)insertMember2:(NSArray *)arry
{
    
    
    BOOL success = NO;
    if ([_fmdb open]) {
        [_lock lock];
        
        FMResultSet *rs = [_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"t_member"];
        while ([rs next])
        {
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count)
            {
                [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_member(%@)",[LYFmdbTool caretasqlstr:arry]]];
            }
            
            
            for (int i = 0; i<arry.count; i++)
            {
                
                
                
                FMResultSet *rs2 = [_fmdb executeQuery:[NSString stringWithFormat:@"select count(*) as 'count' from t_member where phone_number = \"%@\"",[[arry objectAtIndex:i] valueForKey:@"phone_number"]]];
                while ([rs2 next])
                {
                    
                    NSInteger count1 = [rs2 intForColumn:@"count"];
                    
                    
                    if (0 == count1)
                    {
                        
                        
                        NSMutableString * sqlstr  = [[NSMutableString alloc]init];
                        
                        for (int j =0; j<[[[arry objectAtIndex:i]allKeys]count]; j++) {
                            
                            
                            [sqlstr appendFormat:@"%@,",[[[arry objectAtIndex:i]allKeys] objectAtIndex:j]];
                        }
                        
                        NSMutableString * sqlstr2  = [[NSMutableString alloc]init];
                        for (int k =0; k<[[[arry objectAtIndex:i]allKeys]count]; k++) {
                            
                            [sqlstr2 appendFormat:@"'%@',",[[arry objectAtIndex:i]valueForKey:[[[arry objectAtIndex:i]allKeys] objectAtIndex:k]]];
                        }
                        
                        
                        
                        NSString * str =[NSString stringWithFormat:@"(%@)",[sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)]];
                        NSString * str1 =[NSString stringWithFormat:@"(%@)",[sqlstr2 substringWithRange:NSMakeRange(0,sqlstr2.length-1)]];
                        
                        
                        if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into t_member %@ values %@",str,str1]]) {
                            
                            success = YES;
                        }else
                        {
                            success = NO;
                        }
                        
                    }else{
                        
                        NSMutableString * sqlstr  = [[NSMutableString alloc]init];
                        
                        
                        NSDictionary * dataDic = [[NSDictionary alloc]initWithDictionary:[arry objectAtIndex:i]];
                        NSArray * keysArry = [NSArray arrayWithArray:dataDic.allKeys];
                        
                        
                        for (int q=0; q<keysArry.count; q++) {
                            
                            [sqlstr appendFormat:@"%@=\"%@\",",[keysArry objectAtIndex:q],[dataDic valueForKey:[keysArry objectAtIndex:q]]];
                            
                        }
                        
                        //                        NSMutableDictionary * datadic1 = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
                        
                        if ([_fmdb executeUpdate:[NSString stringWithFormat:@"UPDATE t_member SET %@ where phone_number = \"%@\"",[sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)],[dataDic valueForKey:@"phone_number"]]]) {
                            
                            success = YES;
                        }else
                        {
                            success = NO;
                        }
                        
                    }
                    
                }
            }
        }
    }
    [_fmdb close];
    [_lock unlock];
    return success;
}



+(BOOL)insertMember3:(NSArray *)arry
{
    
    
    BOOL success = NO;
    
    if ([_fmdb open]) {
        [_lock lock];
        
        
        
        NSMutableString * sqlstr  = [[NSMutableString alloc]init];
        
        for (int i =0; i<[[[arry objectAtIndex:0]allKeys]count]; i++) {
            
            [sqlstr appendFormat:@"%@=\"%@\",",[[[arry objectAtIndex:0]allKeys] objectAtIndex:i],[[arry objectAtIndex:0]valueForKey:[[[arry objectAtIndex:0]allKeys] objectAtIndex:i]]];
        }
        
        
        
        NSMutableDictionary * datadic = nil;
        
        for (int i = 0; i<arry.count; i++)
        {
            datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
            if ([_fmdb executeUpdate:[NSString stringWithFormat:@"UPDATE t_member SET %@ where phone_number = \"%@\"",[sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)],[datadic valueForKey:@"phone_number"]]]) {
                
                success = YES;
            }else
            {
                success = NO;
            }
        }
    }
    [_fmdb close];
    [_lock unlock];
    return success;
}


+(BOOL)fabricListdb:(NSArray *)arry del:(BOOL)del
{
    BOOL success = NO;
    if ([_fmdb open]) {
        [_lock lock];
        
        if (del)
        {
            if ([_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"fabricListdb"]) {
                
                [_fmdb executeUpdate:@"drop table fabricListdb"];
                
                
            }
        }
        
        if (![_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS fabricListdb(%@)",[LYFmdbTool caretasqlstr:arry]]]) {
            
            [SVProgressHUD showErrorWithStatus:@"创建表失败"];
            return NO;
        }
        
        
        NSMutableDictionary * datadic = nil;
        
        for (int i = 0; i<arry.count; i++)
        {
            datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
            if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into fabricListdb values(%@)",[LYFmdbTool insertsqlstr:arry]] withParameterDictionary:datadic]) {
                
                success = YES;
            }else
            {
                success = NO;
            }
        }
    }
    [_fmdb close];
    [_lock unlock];
    return success;
    
    
}


+(BOOL)insertMemberName:(NSArray *)arry
{
    
    BOOL success = NO;
    if ([_fmdb open]) {
        
        [_lock lock];
        
        FMResultSet *rs =  [_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"t_member_name"];
        while ([rs next])
        {
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count)
            {
                [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_member_name(%@)",[LYFmdbTool caretasqlstr:arry]]];
            }
            
            for (int i = 0; i<arry.count; i++)
            {
                
                
                FMResultSet *rs2 =  [_fmdb executeQuery:[NSString stringWithFormat:@"select count(*) as 'count' from t_member_name where phone_number = \"%@\"", [[arry objectAtIndex:i]valueForKey:@"phone_number"]]];
                
                while ([rs2 next])
                {
                    
                    
                    NSInteger count = [rs2 intForColumn:@"count"];
                    
                    if (0 == count)
                    {
                        
                        NSMutableDictionary * datadic = nil;
                        
                        
                        datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
                        
                        if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into t_member_name values(%@)",[LYFmdbTool insertsqlstr:arry]] withParameterDictionary:datadic]) {
                            
                            success = YES;
                        }else
                        {
                            success = NO;
                        }
                        
                        
                        
                        
                    }else
                    {
                        
                        NSMutableString * sqlstr  = [[NSMutableString alloc]init];
                        
                        
                        NSDictionary * dataDic = [[NSDictionary alloc]initWithDictionary:[arry objectAtIndex:i]];
                        NSArray * keysArry = [NSArray arrayWithArray:dataDic.allKeys];
                        
                        
                        for (int q=0; q<keysArry.count; q++) {
                            
                            [sqlstr appendFormat:@"%@=\"%@\",",[keysArry objectAtIndex:q],[dataDic valueForKey:[keysArry objectAtIndex:q]]];
                            
                        }
                        
                        if ([_fmdb executeUpdate:[NSString stringWithFormat:@"UPDATE t_member_name SET %@ where phone_number = \"%@\"",[sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)],[dataDic valueForKey:@"phone_number"]]]) {
                            
                            success = YES;
                        }else
                        {
                            success = NO;
                        }
                        
                        
                        
                    }
                }
                
            }
            
            
            
        }
    }
    [_fmdb close];
    [_lock unlock];
    return success;
}

+(BOOL)insertMemberName2:(NSArray *)arry
{
    
    BOOL success = NO;
    if ([_fmdb open]) {
        [_lock lock];
        
        FMResultSet *rs = [_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"t_member"];
        while ([rs next])
        {
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count)
            {
                [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_member(%@)",[LYFmdbTool caretasqlstr:arry]]];
            }
            
            NSMutableDictionary * datadic = nil;
            
            for (int i = 0; i<arry.count; i++)
            {
                datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
                if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into t_member_name values(%@)",[LYFmdbTool insertsqlstr:arry]] withParameterDictionary:datadic]) {
                    
                    success = YES;
                }else
                {
                    success = NO;
                }
            }
        }
    }
    [_fmdb close];
    [_lock unlock];
    return success;
}

+(BOOL)insertMemberName3:(NSArray *)arry;
{
    
    BOOL success = NO;
    
    if ([_fmdb open]) {
        [_lock lock];
        
        NSMutableString * sqlstr  = [[NSMutableString alloc]init];
        
        for (int i =0; i<[[[arry objectAtIndex:0]allKeys]count]; i++) {
            
            [sqlstr appendFormat:@"%@=\"%@\",",[[[arry objectAtIndex:0]allKeys] objectAtIndex:i],[[arry objectAtIndex:0]valueForKey:[[[arry objectAtIndex:0]allKeys] objectAtIndex:i]]];
        }
        
        
        
        NSMutableDictionary * datadic = nil;
        
        for (int i = 0; i<arry.count; i++)
        {
            datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
            if ([_fmdb executeUpdate:[NSString stringWithFormat:@"UPDATE t_member_name SET %@ where phone_number = \"%@\"",[sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)],[datadic valueForKey:@"phone_number"]]]) {
                
                success = YES;
            }else
            {
                success = NO;
            }
        }
    }
    [_fmdb close];
    [_lock unlock];
    return success;
    
}



+(BOOL)insertOrderList:(NSArray *)arry
{
    [_fmdb open];
    BOOL success = NO;
    
    if ([_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"OrderList"]) {
        
        
        
    }
    [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS OrderList(%@)",[LYFmdbTool caretasqlstr:arry]]];
    NSMutableDictionary * datadic = nil;
    
    for (int i = 0; i<arry.count; i++)
    {
        datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
        if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into OrderList values(%@)",[LYFmdbTool insertsqlstr:arry]] withParameterDictionary:datadic]) {
            
            success = YES;
        }else
        {
            success = NO;
        }
    }
    
    [_fmdb close];
    [_lock unlock];
    return success;
    
    
}




+(BOOL)insertImageName:(NSArray *)arry del:(BOOL)del
{
    
    BOOL success = NO;
    if ([_fmdb open]) {
        [_lock lock];
        
        if (del)
        {
            if ([_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"ImageName"]) {
                
                [_fmdb executeUpdate:@"drop table ImageName"];
                
            }
        }
        
        [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ImageName(%@)",[LYFmdbTool caretasqlstr:arry]]];
        NSMutableDictionary * datadic = nil;
        [LYFmdbTool insertsqlstr:arry];
        
        
        for (int i = 0; i<arry.count; i++)
        {
            datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
            
            if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into ImageName values(%@)",[LYFmdbTool insertsqlstr:arry]] withParameterDictionary:datadic]) {
                
                success = YES;
            }else
            {
                success = NO;
            }
        }
    }
    [_fmdb close];
    [_lock unlock];
    return success;
}

+(BOOL)insertImageName2:(NSArray *)arry del:(BOOL)del
{
    
    
    
    BOOL success = NO;
    if ([_fmdb open]) {
        [_lock lock];
        
        
        
        FMResultSet * rsq =[_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"ImageName"];
        while ([rsq next]) {
            NSInteger count = [rsq intForColumn:@"count"];
            if (count==0)
            {
                
                [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ImageName(%@)",[LYFmdbTool caretasqlstr:arry]]];
                NSMutableDictionary * datadic = nil;
                [LYFmdbTool insertsqlstr:arry];
                
                
                for (int i = 0; i<arry.count; i++)
                {
                    datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
                    
                    if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into ImageName values(%@)",[LYFmdbTool insertsqlstr:arry]] withParameterDictionary:datadic]) {
                        
                        success = YES;
                    }else
                    {
                        success = NO;
                    }
                }
                
                
            }else
            {
                if ([_fmdb open]) {
                    [_lock lock];
                    
                    
                    
                    FMResultSet * rs = [_fmdb executeQuery:[NSString stringWithFormat:@"select count(*) as 'count' from ImageName WHERE m_id = \"%@\" AND type = \"%@\"",[[arry objectAtIndex:0]valueForKey:@"m_id"],[[arry objectAtIndex:0]valueForKey:@"type"]]];
                    
                    while ([rs next]) {
                        
                        
                        
                        NSInteger count = [rs intForColumn:@"count"];
                        NSLog(@"isTableOK %ld", (long)count);
                        
                        if (0 != count)
                        {
                            
                            for (int z = 0; z<arry.count; z++)
                            {
                                
                                NSMutableString * sqlstr  = [[NSMutableString alloc]init];
                                for (int i =0; i<[[[arry objectAtIndex:z]allKeys]count]; i++) {
                                    
                                    [sqlstr appendFormat:@"%@=\"%@\",",[[[arry objectAtIndex:z]allKeys] objectAtIndex:i],[[arry objectAtIndex:z]valueForKey:[[[arry objectAtIndex:z]allKeys] objectAtIndex:i]]];
                                }
                                
                                
                                if ([_fmdb executeUpdate:[NSString stringWithFormat:@"UPDATE ImageName SET %@ WHERE m_id = \"%@\" AND type = \"%@\"",[sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)],[[arry objectAtIndex:z]valueForKey:@"m_id"],[[arry objectAtIndex:z]valueForKey:@"type"]]]) {
                                    
                                    success = YES;
                                }else
                                {
                                    success = NO;
                                }
                            }
                            
                        }else
                        {
                            
                            
                            for (int i = 0; i<arry.count; i++)
                            {
                                NSMutableString * sqlstr  = [[NSMutableString alloc]init];
                                
                                for (int j =0; j<[[[arry objectAtIndex:i]allKeys]count]; j++) {
                                    
                                    
                                    [sqlstr appendFormat:@"%@,",[[[arry objectAtIndex:i]allKeys] objectAtIndex:j]];
                                }
                                
                                NSMutableString * sqlstr2  = [[NSMutableString alloc]init];
                                for (int k =0; k<[[[arry objectAtIndex:i]allKeys]count]; k++) {
                                    //
                                    [sqlstr2 appendFormat:@"'%@',",[[arry objectAtIndex:i]valueForKey:[[[arry objectAtIndex:i]allKeys] objectAtIndex:k]]];
                                }
                                
                                NSString * str =[NSString stringWithFormat:@"(%@)",[sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)]];
                                NSString * str1 =[NSString stringWithFormat:@"(%@)",[sqlstr2 substringWithRange:NSMakeRange(0,sqlstr2.length-1)]];
                                
                                
                                if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into ImageName %@ values %@",str,str1]]) {
                                    
                                    success = YES;
                                }else
                                {
                                    success = NO;
                                }
                            }
                            
                        }
                    }
                    
                }
                
            }
        }
        
    }
    
    
    [_fmdb close];
    [_lock unlock];
    return success;
    
    
    
}




+ (NSArray *)queryData:(NSString *)querySql {
    
    NSMutableArray * arry = [[NSMutableArray alloc]init];
    if ([_fmdb open]) {
        [_lock lock];
        
        FMResultSet * rsq =[_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", querySql];
        
        while ([rsq next]) {
            
            NSInteger count = [rsq intForColumn:@"count"];
            if (count==0)
            {
                return nil;
            }else
            {
                
                FMResultSet * rs = [_fmdb executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",querySql]];
                while ([rs next]) {
                    
                    [arry addObject:[rs resultDictionary]];
                }
            }
        }
    }
    
    [_fmdb close];
    [_lock unlock];
    
    return arry;
}
+ (NSArray *)queryData2:(NSString *)querySql{
    
    NSMutableArray * arry = [[NSMutableArray alloc]init];
    
    if ([_fmdb open]) {
        [_lock lock];
        
        FMResultSet * rs = [_fmdb executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@",querySql]];
        while ([rs next]) {
            
            [arry addObject:[rs resultDictionary]];
        }
    }
    [_fmdb close];
    [_lock unlock];
    
    return arry;
    
}


+ (NSArray *)queryData3:(NSString *)querySql{
    
    NSMutableArray * arry = [[NSMutableArray alloc]init];
    
    if ([_fmdb open]) {
        [_lock lock];
        
        FMResultSet * rs = [_fmdb executeQuery:[NSString stringWithFormat:@"%@",querySql]];
        while ([rs next]) {
            
            [arry addObject:[rs resultDictionary]];
        }
    }
    [_fmdb close];
    [_lock unlock];
    
    return arry;
    
}


+(NSString *)caretasqlstr:(NSArray*)arry
{
    if (arry.count == 0)
    {
        return @"";
    }
    NSMutableString * sqlstr  = [[NSMutableString alloc]init];
    for (int i = 0; i<[[arry objectAtIndex:0]allKeys].count; i++)
    {
        [sqlstr appendFormat:@"'%@',",[[[arry objectAtIndex:0]allKeys] objectAtIndex:i]];
    }
    
    return [sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)];
}

+(NSString *)insertsqlstr:(NSArray*)arry
{
    NSMutableString * sqlstr  = [[NSMutableString alloc]init];
    for (int i = 0; i<[[arry objectAtIndex:0]allKeys].count; i++)
    {
        [sqlstr appendFormat:@":%@,",[[[arry objectAtIndex:0]allKeys] objectAtIndex:i]];
    }
    
    return [sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)];
}


+(NSString *)updatesqlstr:(NSArray*)arry
{
    //    NSMutableString * sqlstr  = [[NSMutableString alloc]init];
    //    for (int i = 0; i<[[arry objectAtIndex:0]allKeys].count; i++)
    //    {
    //        [sqlstr appendFormat:@"%@=:%@,",[[[arry objectAtIndex:0]allKeys] objectAtIndex:i],[[[arry objectAtIndex:0]allKeys] objectAtIndex:i]];
    //    }
    //
    //    return [sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)];
    
    
    NSMutableString * sqlstr  = [[NSMutableString alloc]init];
    for (int i = 0; i<[[arry objectAtIndex:0]allKeys].count; i++)
    {
        [sqlstr appendFormat:@"'%@'= ?,",[[[arry objectAtIndex:0]allKeys] objectAtIndex:i]];
    }
    
    return [sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)];
}











#pragma mark - 本地上传

+(BOOL)uplodMember:(NSArray *)arry del:(BOOL)del
{
    
    BOOL success = NO;
    if ([_fmdb open]) {
        [_lock lock];
        FMResultSet * rsq =[_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"upload_t_member"];
        while ([rsq next]) {
            NSInteger count = [rsq intForColumn:@"count"];
            if (count==0)
            {
                [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS upload_t_member(%@)",[LYFmdbTool caretasqlstr:arry]]];
                
            }
            
        }
        
        
        
        for (int i = 0; i<arry.count; i++)
        {
            
            
            
            NSMutableString * sqlstr  = [[NSMutableString alloc]init];
            
            for (int j =0; j<[[[arry objectAtIndex:i]allKeys]count]; j++) {
                
                
                [sqlstr appendFormat:@"%@,",[[[arry objectAtIndex:i]allKeys] objectAtIndex:j]];
            }
            
            NSMutableString * sqlstr2  = [[NSMutableString alloc]init];
            for (int k =0; k<[[[arry objectAtIndex:i]allKeys]count]; k++) {
                //
                [sqlstr2 appendFormat:@"'%@',",[[arry objectAtIndex:i]valueForKey:[[[arry objectAtIndex:i]allKeys] objectAtIndex:k]]];
            }
            
            NSString * str =[NSString stringWithFormat:@"(%@)",[sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)]];
            NSString * str1 =[NSString stringWithFormat:@"(%@)",[sqlstr2 substringWithRange:NSMakeRange(0,sqlstr2.length-1)]];
            if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into upload_t_member %@ values %@",str,str1]]) {
                
                success = YES;
            }else
            {
                success = NO;
            }
        }
    }
    [_fmdb close];
    [_lock unlock];
    return success;
    
    
}


+(BOOL)uplodOrderList:(NSArray *)arry del:(BOOL)del
{
    
    BOOL success = NO;
    if ([_fmdb open]) {
        [_lock lock];
        
        FMResultSet * rsq =[_fmdb executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"upload_Order"];
        while ([rsq next]) {
            NSInteger count = [rsq intForColumn:@"count"];
            if (count==0)
            {
                [_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS upload_Order(%@)",[LYFmdbTool caretasqlstr:arry]]];
                
            }
            
        }
        
        
        
        
        for (int i = 0; i<arry.count; i++)
        {
            NSMutableString * sqlstr  = [[NSMutableString alloc]init];
            
            for (int j =0; j<[[[arry objectAtIndex:i]allKeys]count]; j++) {
                
                
                [sqlstr appendFormat:@"%@,",[[[arry objectAtIndex:i]allKeys] objectAtIndex:j]];
            }
            
            NSMutableString * sqlstr2  = [[NSMutableString alloc]init];
            for (int k =0; k<[[[arry objectAtIndex:i]allKeys]count]; k++) {
                //
                [sqlstr2 appendFormat:@"'%@',",[[arry objectAtIndex:i]valueForKey:[[[arry objectAtIndex:i]allKeys] objectAtIndex:k]]];
            }
            
            NSString * str =[NSString stringWithFormat:@"(%@)",[sqlstr substringWithRange:NSMakeRange(0,sqlstr.length-1)]];
            NSString * str1 =[NSString stringWithFormat:@"(%@)",[sqlstr2 substringWithRange:NSMakeRange(0,sqlstr2.length-1)]];
            
            if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into upload_Order %@ values %@",str,str1]]) {
                
                success = YES;
            }else
            {
                success = NO;
            }
        }
        
    }
    [_fmdb close];
    [_lock unlock];
    return success;
    
}


+(BOOL)deleteDB:(NSString*)sqlstr{
    
    
    BOOL success = NO;
    if ([_fmdb open]) {
        
        [_lock lock];
        NSString * str = [NSString stringWithFormat:@"delete from %@",sqlstr];
        
        if ([_fmdb executeUpdate:str])
        {
            
            success = YES;
        }else
        {
            success = NO;
        }
        
        
    }
    
    [_fmdb close];
    [_lock unlock];
    return success;
}

+(BOOL)dropDB:(NSString*)sqlstr;
{
    
    BOOL success = NO;
    if ([_fmdb open]) {
        
        [_lock lock];
        NSString * str = [NSString stringWithFormat:@"drop table %@",sqlstr];
        
        if ([_fmdb executeUpdate:str])
        {
            
            success = YES;
        }else
        {
            success = NO;
        }
        
        
    }
    
    [_fmdb close];
    [_lock unlock];
    return success;}



+(BOOL)userList:(NSArray *)arry {

    BOOL success = NO;
    if ([_fmdb open]) {
        [_lock lock];
        
        
        
        if (![_fmdb executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UserList(%@)",[LYFmdbTool caretasqlstr:arry]]]) {
            
            [SVProgressHUD showErrorWithStatus:@"创建表失败"];
            return NO;
        }
        
        
        NSMutableDictionary * datadic = nil;
        
        for (int i = 0; i<arry.count; i++)
        {
            datadic = [NSMutableDictionary dictionaryWithDictionary:[arry objectAtIndex:i]];
            if ([_fmdb executeUpdate:[NSString stringWithFormat:@"insert into UserList values(%@)",[LYFmdbTool insertsqlstr:arry]] withParameterDictionary:datadic]) {
                
                success = YES;
            }else
            {
                success = NO;
            }
        }
    }
    [_fmdb close];
    [_lock unlock];
    return success;
}

@end
