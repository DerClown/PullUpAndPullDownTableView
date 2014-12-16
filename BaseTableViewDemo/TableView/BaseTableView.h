//
//  BaseTableView.h
//  BaseTableViewDemo
//
//  Created by Dong on 11/1/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

typedef enum {
    PullUpRefreshNormal = 0,
    PullUpRefreshLoading,
    PullUpRefreshLoadingAll,
}PullUpRefreshStatus;

@class BaseTableView;

@protocol BaseTableViewDelegate <NSObject>
@optional

- (void)baseTableViewStartPullDownLoading:(BaseTableView *)baseTableView;
- (void)baseTableViewStartPullUpLoading:(BaseTableView *)baseTableView;

@end

@interface BaseTableView : UITableView<UIScrollViewDelegate, EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _isPullDownLoading;
    BOOL _isPullUpLoading;
    
    UIView *_refreshFooterView;
    UILabel *_statusLabel;
    UIActivityIndicatorView *_indicatorView;
    
    PullUpRefreshStatus _status;
}

@property (nonatomic, assign) BOOL isShowRefreshHeaderView;
@property (nonatomic, assign) BOOL isShowRefreshFooterView;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, assign) id<BaseTableViewDelegate> aDelegate;



- (void)pullDownDidFinishLoading;

/**
 *  Setting load more status
 *
 *  @param status A status to judge pull up loding is finish current loading or finish loading all data
 */
- (void)pullUpDidFinishLoadingWithStatus:(PullUpRefreshStatus)status;

- (id)initWithFrame:(CGRect)frame delegate:(UIViewController *)delegate;

@end
