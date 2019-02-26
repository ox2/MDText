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

static CGFloat ascentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"ascent"] floatValue];
}

static CGFloat descentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"descent"] floatValue];
}

static CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

+ (NSAttributedString *)emptyAttributedStringWithWidth:(CGFloat)width
                                                ascent:(CGFloat)ascent
                                               descent:(CGFloat)descent
                                            attributes:(NSDictionary *)attributes {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    NSDictionary *dict = @{
                           @"ascent": @(ascent),
                           @"descent": @(descent),
                           @"width": @(width),
                           };
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge_retained void *)(dict));

    unichar objectReplacementChar = 0xFFFC; // 占位符
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

@end
