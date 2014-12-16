//
//  ViewController.m
//  BaseTableViewDemo
//
//  Created by Dong on 11/3/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import "ViewController.h"
#import "MappingListModel.h"
#import "SectionHeaderView.h"
#import "EmptyCell.h"
#import "SectionHeaderViewValueContext.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *valueContents;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[BaseTableView alloc] initWithFrame:self.view.bounds delegate:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.aDelegate = self;
    self.tableView.isShowRefreshHeaderView = YES;
    self.tableView.isShowRefreshFooterView = YES;
    [self.view addSubview:self.tableView];
    _valueContents = [NSMutableArray new];
    //这里的i表示第几个section
    for (int i = 0; i < 10; i ++) {
        SectionHeaderViewValueContext *sectionContent = [SectionHeaderViewValueContext new];
        sectionContent.valueContents = [NSMutableArray array];
        sectionContent.indexPathValueContents = [NSMutableArray array];
        sectionContent.title = [NSString stringWithFormat:@"第%d组", i];
        int sectionCounts = random()%4;
        if (i == 0) {
            sectionContent.isOpen = YES;
        }
        sectionContent.sectionIndex = i;
        if (sectionCounts > 0) {
            for (int k = 0; k < sectionCounts; k++) {
                MappingListModel *listModel = [MappingListModel new];
                listModel.title = @"这是一个测试";
                listModel.name = @"测试name";
                [sectionContent.valueContents addObject:listModel];
                if (!sectionContent.isOpen) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:k inSection:i];
                    [sectionContent.indexPathValueContents addObject:indexPath];
                }
            }
        }
        
        [_valueContents addObject:sectionContent];
    }
    
    self.tableView.data = _valueContents;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  下拉协议
 */
- (void)baseTableViewStartPullUpLoading:(BaseTableView *)baseTableView {
    [self performSelector:@selector(loadData) withObject:nil afterDelay:5];
}

- (void)loadData {
    /**
     *  下拉完成以后设置下拉的装袋为
     */
    [self.tableView pullUpDidFinishLoadingWithStatus:PullUpRefreshNormal];
}

@end
