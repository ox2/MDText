//
//  TableViewCell.m
//  CoreTextDemo
//
//  Created by wxiubin on 2019/1/10.
//  Copyright © 2019 wxiubin. All rights reserved.
//

#import "TableViewCell.h"

@interface BBLiveBaseDanmakuDisplayView : UIView

@property (nonatomic, strong, nullable) BBLiveBaseTextLayout *textLayout;

@end

@implementation BBLiveBaseDanmakuDisplayView

- (void)setTextLayout:(BBLiveBaseTextLayout *)textLayout {
    if (_textLayout != textLayout) {
        _textLayout = textLayout;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (!self.textLayout) return;

    [self.textLayout drawRect:rect];
}

@end

@interface TableViewCell ()

@property (nonatomic, strong) BBLiveBaseDanmakuDisplayView *displayView;

@end

@implementation TableViewCell

- (void)setViewModel:(CellViewModel *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
        self.displayView.textLayout = viewModel.textLayout;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        self.displayView = [[BBLiveBaseDanmakuDisplayView alloc] init];
        self.displayView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.displayView];

        self.displayView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_userTapGestureDetected:)];
        [self.displayView addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.displayView.frame = CGRectMake(5, 5, self.bounds.size.width - 10, self.viewModel.height - 10);
}

- (void)_userTapGestureDetected:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    BBLiveBaseAttachment *attachment = [self.viewModel.textLayout attachmentAtPoint:point inView:self];
    if (attachment.action) {
        return NSLog(@"%@", attachment.action);
    }
    id linkValue = [self.viewModel.textLayout linkValueAtPoint:point inView:self];
    if (linkValue) {
        return NSLog(@"linkValue: %@", linkValue);
    }
}

@end
