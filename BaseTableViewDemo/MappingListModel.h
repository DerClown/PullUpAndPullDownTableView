//
//  ListModel.h
//  BaseTableViewDemo
//
//  Created by Dong on 10/30/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MappingListModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *lists;

@end
