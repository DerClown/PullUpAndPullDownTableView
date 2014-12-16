//
//  SectionHeadView.h
//  BaseTableViewDemo
//
//  Created by Dong on 11/1/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderViewValueContext.h"

@class SectionHeaderView;

@protocol SectionHeaderViewDelegate <NSObject>

- (void)sectionHeaderView:(SectionHeaderView *)headView closedIndexSection:(NSInteger)indexSection;
- (void)sectionHeaderView:(SectionHeaderView *)headView openIndexSection:(NSInteger)indexSection;

@end

@interface SectionHeaderView : UIView {
    NSInteger _sectionIndex;
    NSString *_sectionTitle;
    
    BOOL _isOpen;
}

@property (nonatomic, assign) id<SectionHeaderViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame sectionValueContent:(SectionHeaderViewValueContext *)sectionValueContent;

@end
