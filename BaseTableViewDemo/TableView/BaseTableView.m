//
//  BaseTableView.m
//  BaseTableViewDemo
//
//  Created by Dong on 11/1/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import "BaseTableView.h"
#import "MappingListModel.h"
#import "SectionHeaderView.h"
#import "EmptyCell.h"
#import "SectionHeaderViewValueContext.h"

@interface BaseTableView ()<UITableViewDataSource, UITableViewDelegate,SectionHeaderViewDelegate>

@property (nonatomic, strong) UIView *footerRefreshView;
@property (nonatomic, strong) UILabel *statusTitleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *aIndicatorView;
@property (nonatomic, assign) PullUpRefreshStatus aStatus;

@end

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame delegate:(UIViewController *)delegate {
    if (self = [super initWithFrame:frame]) {
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
        self.scrollIndicatorInsets = UIEdgeInsetsZero;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)pullDownDidFinishLoading {
    _isPullDownLoading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

- (void)pullUpDidFinishLoadingWithStatus:(PullUpRefreshStatus)status {
    _isPullUpLoading = NO;
    [self setAStatus:status];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SectionHeaderViewValueContext *valueContent = (SectionHeaderViewValueContext *)self.data[section];
    if (valueContent.isOpen) {
        if (valueContent.valueContentsIsEmpty) {
            return 1;
        }
        
        return valueContent.valueContents.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    SectionHeaderViewValueContext *content = self.data[indexPath.section];
    if (content.valueContentsIsEmpty) {
        EmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"enpty"];
        if (!emptyCell) {
            emptyCell = [[EmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"enpty"];
        }
        return emptyCell;
    } else {
        MappingListModel *model = content.valueContents[indexPath.row];
        cell.textLabel.text = model.title;
        return cell;
    }
}

#pragma mark - UITableView Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeaderViewValueContext *content = self.data[section];
    SectionHeaderView *sectionHeaderView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 45) sectionValueContent:content];
    sectionHeaderView.delegate = self;
    sectionHeaderView.backgroundColor = [UIColor redColor];
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[EmptyCell class]]) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SectionHeaderViewValueContext *valueContext = self.data[indexPath.section];
        MappingListModel *model = valueContext.valueContents[indexPath.row];
        [valueContext.valueContents removeObject:model];
        
        if (valueContext.valueContentsIsEmpty) {
            [self reloadData];
        } else {
            [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(SectionHeaderView *)headView closedIndexSection:(NSInteger)indexSection {
    SectionHeaderViewValueContext *content = self.data[indexSection];
    content.isOpen = NO;
    
    if (content.valueContents.count > 0) {
        [content.indexPathValueContents removeAllObjects];
        //[self.tableView deleteRowsAtIndexPaths:content.indexPathValueContents withRowAnimation:UITableViewRowAnimationTop];
        [self reloadSections:[NSIndexSet indexSetWithIndex:content.sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:indexSection]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)sectionHeaderView:(SectionHeaderView *)headView openIndexSection:(NSInteger)indexSection {
    SectionHeaderViewValueContext *content = self.data[indexSection];
    SectionHeaderViewValueContext *openContent;
    for (SectionHeaderViewValueContext *candidateContent in self.data) {
        if (candidateContent.isOpen) {
            openContent = candidateContent;
            openContent.isOpen = NO;
        }
        if (candidateContent != content) {
            candidateContent.isOpen = NO;
        }
    }
    content.isOpen = YES;
    if (!content.valueContentsIsEmpty) {
        for (int i = 0; i < content.valueContents.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:indexSection];
            [content.indexPathValueContents addObject:indexPath];
        }
    }
    
    [self beginUpdates];
    //    if (content.indexPathValueContents.count > 0) {
    //        [self.tableView insertRowsAtIndexPaths:content.indexPathValueContents withRowAnimation:UITableViewRowAnimationMiddle];
    //    } else {
    //        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:content.sectionIndex]] withRowAnimation:UITableViewRowAnimationMiddle];
    //    }
    //    [self.tableView deleteRowsAtIndexPaths:openContent.indexPathValueContents withRowAnimation:UITableViewRowAnimationTop];
    [self reloadSections:[NSIndexSet indexSetWithIndex:content.sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
    if (openContent) {
        [openContent.indexPathValueContents removeAllObjects];
        [self reloadSections:[NSIndexSet indexSetWithIndex:openContent.sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self endUpdates];
    //[self.tableView reloadData];
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (!_isPullUpLoading && _status != PullUpRefreshLoadingAll) {
        if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height + 25)) {
            if (self.aDelegate && [self.aDelegate respondsToSelector:@selector(baseTableViewStartPullUpLoading:)]) {
                [self.aDelegate baseTableViewStartPullUpLoading:self];
            }
            [self setAStatus:PullUpRefreshLoading];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    _isPullDownLoading = YES;
    if (self.aDelegate && [self.aDelegate respondsToSelector:@selector(baseTableViewStartPullDownLoading:)]) {
        [self.aDelegate baseTableViewStartPullDownLoading:self];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _isPullDownLoading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}

#pragma mark - BaseTableView Privates

- (void)createRefreshHeaderView {
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    _refreshHeaderView.delegate = self;
    [self addSubview:_refreshHeaderView];
}

- (void)createRefreshFooterView {
    self.footerRefreshView.frame = CGRectMake(0, 0, self.frame.size.width, 100);
    _refreshFooterView = _footerRefreshView;
    self.tableFooterView = _refreshFooterView;
    
    self.statusTitleLabel.frame = CGRectMake(0, 12, self.frame.size.width, 22);
    _statusLabel = _statusTitleLabel;
    
    self.aIndicatorView.frame = CGRectMake(0, 0, 30, 30);
    _indicatorView = _aIndicatorView;
}

#pragma mark - Setter

- (UIView *)footerRefreshView {
    if (!_footerRefreshView) {
        _footerRefreshView = [[UIView alloc] init];
        _footerRefreshView.backgroundColor = [UIColor whiteColor];
    }
    return _footerRefreshView;
}

- (UILabel *)statusTitleLabel {
    if (!_statusTitleLabel) {
        _statusTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusTitleLabel.backgroundColor = [UIColor clearColor];
        _statusTitleLabel.textColor = [UIColor grayColor];
        _statusTitleLabel.textAlignment = NSTextAlignmentCenter;
        _statusTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        
        [_footerRefreshView addSubview:_statusTitleLabel];
    }
    
    return _statusTitleLabel;
}

- (UIActivityIndicatorView *)aIndicatorView {
    if (!_aIndicatorView) {
        _aIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _aIndicatorView.backgroundColor = [UIColor clearColor];
        
        [_footerRefreshView addSubview:_aIndicatorView];
    }
    
    return _aIndicatorView;
}

- (void)setIsShowRefreshHeaderView:(BOOL)isShowRefreshHeaderView {
    if (isShowRefreshHeaderView) {
        if (!_refreshHeaderView) {
            [self createRefreshHeaderView];
        }
        [_refreshHeaderView refreshLastUpdatedDate];
    } else {
        if (_refreshHeaderView) {
            [_refreshHeaderView removeFromSuperview];
            _refreshHeaderView = nil;
        }
    }
}

- (void)setIsShowRefreshFooterView:(BOOL)isShowRefreshFooterView {
    if (isShowRefreshFooterView) {
        if (!_refreshFooterView) {
            [self createRefreshFooterView];
            [self setAStatus:PullUpRefreshNormal];
        }
    } else {
        self.tableFooterView = nil;
        [_refreshFooterView removeFromSuperview];
        _refreshFooterView = nil;
    }
}

- (void)setAStatus:(PullUpRefreshStatus)aStatus {
    switch (aStatus) {
        case PullUpRefreshNormal:
            _statusLabel.text = @"加载更多";
            [_indicatorView stopAnimating];
            self.scrollIndicatorInsets = UIEdgeInsetsZero;
            break;
        case PullUpRefreshLoading:
            _statusLabel.text = @"加载中，请稍后...";
            CGSize size = [_statusLabel.text sizeWithFont:_statusLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 22)];
            _indicatorView.frame = CGRectMake((self.frame.size.width - size.width) / 2 - 10 - 30, 11, 25, 25);
            [_indicatorView startAnimating];
            break;
        case PullUpRefreshLoadingAll:
            _statusLabel.text = @"已全部加载完成";
            [_refreshFooterView removeFromSuperview];
            _refreshFooterView = nil;
            self.tableFooterView = nil;
            break;
        default:
            break;
    }
    
    _status = aStatus;
}

@end
