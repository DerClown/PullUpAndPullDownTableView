//
//  SectionHeaderViewValueContent.m
//  BaseTableViewDemo
//
//  Created by Dong on 11/3/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import "SectionHeaderViewValueContext.h"

@implementation SectionHeaderViewValueContext

- (BOOL)valueContentsIsEmpty {
    return self.valueContents.count > 0 ? NO : YES;
}

@end
