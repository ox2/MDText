//
//  BBLiveBaseTextLayout.h
//  CoreTextDemo
//
//  Created by wxiubin on 2019/2/17.
//  Copyright © 2019 wxiubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "BBLiveBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const BBLiveBaseAttachmentAttributeName;

@interface BBLiveBaseTextLayout : NSObject

@property (nonatomic, assign, readonly) CTFrameRef ctFrame;

@property (nonatomic, assign, readonly) CGRect rect;

@property (nonatomic, copy, readonly) NSAttributedString *attributedString;

@property (nonatomic, copy, readonly, nullable) NSArray<__kindof BBLiveBaseAttachment *> *attachments;

- (instancetype)initWithAttributedString:(NSAttributedString *)string rect:(CGRect)rect;

@end


@interface BBLiveBaseTextLayout (Event)

- (nullable id)linkValueAtPoint:(CGPoint)point inView:(UIView *)view;

- (nullable __kindof BBLiveBaseAttachment *)attachmentAtPoint:(CGPoint)point inView:(UIView *)view;

@end

@interface BBLiveBaseTextLayout (Draw) <BBLiveBaseDrawAble>

@end

NS_ASSUME_NONNULL_END
