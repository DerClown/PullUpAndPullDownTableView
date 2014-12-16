//
//  SectionHeadView.m
//  BaseTableViewDemo
//
//  Created by Dong on 11/1/14.
//  Copyright (c) 2014 liuxudong. All rights reserved.
//

#import "SectionHeaderView.h"

@interface SectionHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *disclosureBtn;

@end

@implementation SectionHeaderView

- (id)initWithFrame:(CGRect)frame sectionValueContent:(SectionHeaderViewValueContext *)sectionValueContent {
    if (self = [super initWithFrame:frame]) {
        _sectionTitle = sectionValueContent.title;
        _sectionIndex = sectionValueContent.sectionIndex;
        _isOpen = sectionValueContent.isOpen;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [tapGesture addTarget:self action:@selector(toggleAction:)];
        [self addGestureRecognizer:tapGesture];
        
        self.titleLabel.frame = CGRectMake(5, (frame.size.height - 15) / 2, frame.size.width, 18);
        self.titleLabel.text = _sectionTitle;
        
        self.disclosureBtn.frame = CGRectMake(frame.size.width - 8 - 30, (frame.size.height - 30) / 2, 30, 30);
        self.disclosureBtn.selected = _isOpen;
    }
    return self;
}

- (void)toggleAction:(id)tapGesture {
    self.disclosureBtn.selected = _isOpen;
    if (_isOpen) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:closedIndexSection:)]) {
            [self.delegate sectionHeaderView:self closedIndexSection:_sectionIndex];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:openIndexSection:)]) {
            [self.delegate sectionHeaderView:self openIndexSection:_sectionIndex];
        }
    }
    _isOpen = !_isOpen;
}

#pragma mark - Setter

- (UIButton *)disclosureBtn {
    if (!_disclosureBtn) {
        _disclosureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_disclosureBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_disclosureBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        
        [self addSubview:_disclosureBtn];
    }
    return _disclosureBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.textColor = [UIColor blackColor];
        
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
