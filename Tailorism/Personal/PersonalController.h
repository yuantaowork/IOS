//
//  PersonalController.h
//  Tailorism
//
//  Created by LIZhenNing on 16/5/23.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HTTPSuccess)(BOOL httpSuccess);

@interface PersonalController : UITableViewController

- (void)getHttpMeberList:(NSString *)pagestr AndPageSize:(NSString *)pageSize success:(void(^)(BOOL Success))httpSuccess;
//-(void)getHttpMeberList:(NSString *)pagestr success:(void(^)(BOOL Success))httpSuccess;
@end
