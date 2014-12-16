//
//  ViewController.h
//  BaseTableViewDemo
//
//  Created by Dong on 11/3/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
#import "SectionHeaderView.h"

@interface ViewController : UIViewController<BaseTableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;

@end

