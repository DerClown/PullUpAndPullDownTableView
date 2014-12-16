//
//  SectionHeaderViewValueContent.h
//  BaseTableViewDemo
//
//  Created by Dong on 11/3/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionHeaderViewValueContext : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger sectionIndex;

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) NSMutableArray *valueContents;

@property (nonatomic, strong) NSMutableArray *indexPathValueContents;

- (BOOL)valueContentsIsEmpty;

@end
