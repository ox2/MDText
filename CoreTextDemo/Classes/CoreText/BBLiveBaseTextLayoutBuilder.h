//
//  BBLiveBaseTextLayoutBuilder.h
//  CoreTextDemo
//
//  Created by wxiubin on 2019/2/17.
//  Copyright © 2019 wxiubin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBLiveBaseTextLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBLiveBaseTextLayoutBuilder : NSObject

@property (nonatomic, strong, readonly, nullable) BBLiveBaseTextLayout *textLayout;

- (void)appendText:(NSString *)text color:(nullable UIColor *)color font:(nullable UIFont *)font attributes:(nullable NSDictionary *)attributes;

- (void)appendAttributedString:(NSAttributedString *)attrString;

- (void)appendAttachment:(BBLiveBaseAttachment *)attachment;

- (void)addAttribute:(NSAttributedStringKey)name value:(id)value;

- (void)addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range;

- (void)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs range:(NSRange)range;

- (void)removeAttribute:(NSAttributedStringKey)name range:(NSRange)range;

- (nullable BBLiveBaseTextLayout *)buildWithRect:(CGRect)rect;

+ (NSAttributedString *)emptyAttributedStringWithWidth:(CGFloat)width
                                                ascent:(CGFloat)ascent
                                               descent:(CGFloat)descent
                                            attributes:(nullable NSDictionary *)attributes;

@end

NS_ASSUME_NONNULL_END
