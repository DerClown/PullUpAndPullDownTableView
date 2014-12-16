//
//  EmptyCell.m
//  BaseTableViewDemo
//
//  Created by Dong on 11/3/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import "EmptyCell.h"

@implementation EmptyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"没有数据";
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:tipLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
