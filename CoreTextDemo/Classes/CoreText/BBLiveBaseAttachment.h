//
//  BBLiveBaseAttachment.h
//  CoreTextDemo
//
//  Created by wxiubin on 2019/2/17.
//  Copyright © 2019 wxiubin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBLiveBaseAttachment : NSObject

@property (nonatomic, assign, readonly) CGSize size;
// Cocoa 坐标系
@property (nonatomic, assign, readonly) CGRect rect;

@property (nonatomic, assign) CGFloat descent;

@property (nonatomic, assign) NSUInteger position;

@property (nonatomic, copy, nullable) NSString *action;

- (instancetype)initWithSize:(CGSize)size action:(nullable NSString *)action;

@end

@interface BBLiveBaseImageAttachment : BBLiveBaseAttachment

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *URLString;

@end

@interface BBLiveBaseBorderAttachment : BBLiveBaseAttachment

@property (nonatomic, assign) CGFloat strokeWidth;

@property (nonatomic, strong, nullable) UIColor *strokeColor;

@property (nonatomic, strong, nullable) UIColor *fillColor;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign, readonly) CGPoint offset;

@property (nonatomic, copy, readonly, nullable) NSAttributedString *text;
@property (nonatomic, copy, readonly, nullable) NSAttributedString *subText;

- (instancetype)initWithText:(nullable NSAttributedString *)text
                     subText:(nullable NSAttributedString *)subText
                      offset:(CGPoint)offset
                     minSize:(CGSize)minSize;

@end

@protocol BBLiveBaseDrawAble <NSObject>

- (void)drawRect:(CGRect)rect;

@end

@interface BBLiveBaseAttachment (Extension) <BBLiveBaseDrawAble>

/**
 转换 Cocoa 坐标 至 CocoaTouch

 @param rect 翻转区域
 @return CocoaTouch 坐标
 */
- (CGRect)transformCoordinateWithRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
