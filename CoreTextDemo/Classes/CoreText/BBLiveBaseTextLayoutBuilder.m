//
//  BBLiveBaseTextLayoutBuilder.m
//  CoreTextDemo
//
//  Created by wxiubin on 2019/2/17.
//  Copyright © 2019 wxiubin. All rights reserved.
//

#import "BBLiveBaseTextLayoutBuilder.h"

@interface BBLiveBaseTextLayoutBuilder ()

@property (nonatomic, strong, nullable) NSMutableAttributedString *attributedString;

@end

@implementation BBLiveBaseTextLayoutBuilder

- (void)appendText:(NSString *)text color:(UIColor *)color font:(UIFont *)font attributes:(NSDictionary *)attributes {
    if (!text) return;
    NSMutableDictionary *mutableAttributes = attributes ? [attributes mutableCopy] : [NSMutableDictionary dictionary];
    if (color) {
        mutableAttributes[NSForegroundColorAttributeName] = (id)color.CGColor;
    }
    if (font) {
        mutableAttributes[NSFontAttributeName] = font;
    }
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:mutableAttributes]];
}

- (void)appendAttributedString:(NSAttributedString *)attrString {
    [self.attributedString appendAttributedString:attrString];
}

- (void)appendAttachment:(BBLiveBaseAttachment *)attachment {
    if (!attachment) return;

    NSDictionary *attributes = @{BBLiveBaseAttachmentAttributeName: attachment};

    CGFloat descent = attachment.descent;
    [self.attributedString appendAttributedString:[self.class emptyAttributedStringWithWidth:attachment.size.width ascent:attachment.size.height - descent descent:descent attributes:attributes]];
}

- (void)addAttribute:(NSAttributedStringKey)name value:(id)value {
    [self addAttribute:name value:value range:NSMakeRange(0, self.attributedString.length)];
}

- (void)addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range {
    [self.attributedString addAttribute:name value:value range:range];
}

- (void)addAttributes:(NSDictionary<NSAttributedStringKey, id> *)attrs range:(NSRange)range {
    [self.attributedString addAttributes:attrs range:range];
}

- (void)removeAttribute:(NSAttributedStringKey)name range:(NSRange)range {
    [self.attributedString removeAttribute:name range:range];
}

- (BBLiveBaseTextLayout *)buildWithRect:(CGRect)rect {
    if (!_attributedString) return nil;

    _textLayout = [[BBLiveBaseTextLayout alloc] initWithAttributedString:_attributedString rect:rect];
    return _textLayout;
}

- (NSMutableAttributedString *)attributedString {
    if (!_attributedString) {
        _attributedString = [[NSMutableAttributedString alloc] init];
    }
    return _attributedString;
}

+ (NSAttributedString *)emptyAttributedStringWithWidth:(CGFloat)width
                                                ascent:(CGFloat)ascent
                                               descent:(CGFloat)descent
                                            attributes:(NSDictionary *)attributes {
    BBLiveBaseTextRunDelegate *delegate = [[BBLiveBaseTextRunDelegate alloc] init];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = width;
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;

    unichar objectReplacementChar = 0xFFFC; // 占位符
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegateRef);
    CFRelease(delegateRef);
    return space;
}

@end
