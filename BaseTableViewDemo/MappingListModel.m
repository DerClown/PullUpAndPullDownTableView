//
//  ListModel.m
//  BaseTableViewDemo
//
//  Created by Dong on 10/30/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import "MappingListModel.h"

@implementation MappingListModel

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@\r", [self class]];
    [description appendFormat:@"name: %@ \r", self.name];
    [description appendFormat:@"title: %@ \r", self.title];
    [description appendFormat:@"model: %@ \r", self.lists];
    
    return description;
}

@end
