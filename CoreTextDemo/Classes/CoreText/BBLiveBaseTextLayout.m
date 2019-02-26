//
//  BBLiveBaseTextLayout.m
//  CoreTextDemo
//
//  Created by wxiubin on 2019/2/17.
//  Copyright © 2019 wxiubin. All rights reserved.
//

#import "BBLiveBaseTextLayout.h"
#import "BBLiveBaseAttachment+Private.h"

NSString *const BBLiveBaseAttachmentAttributeName = @"BBLiveBaseAttachment";

@interface BBLiveBaseTextLayout () {
@protected
    CTFrameRef _ctFrame;
    CGRect _rect;
    NSAttributedString *_attributedString;
    NSArray<__kindof BBLiveBaseAttachment *> *_attachments;
}

@end

@implementation BBLiveBaseTextLayout

- (instancetype)initWithAttributedString:(NSAttributedString *)string rect:(CGRect)rect {
    if (self = [super init]) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
        rect.size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, rect.size, nil);

        _ctFrame = [self createFrameWithFramesetter:framesetter rect:rect];
        _rect = rect;
        _attributedString = string.copy;

        CFRelease(framesetter);

        [self fetchAttachment];
    }
    return self;
}

- (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter rect:(CGRect)rect {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);

    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

- (void)dealloc {
    if (_ctFrame) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

- (void)fetchAttachment {

    NSArray *lines = (NSArray *)CTFrameGetLines(_ctFrame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), lineOrigins);

    int dataIndex = 0;

    NSMutableArray *attachments = [NSMutableArray array];

    for (int i = dataIndex; i < lineCount; ++i) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray * runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            BBLiveBaseAttachment *attachment = runAttributes[BBLiveBaseAttachmentAttributeName];
            if (!attachment) continue;

            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];

            BBLiveBaseTextRunDelegate * runDelegate = CTRunDelegateGetRefCon(delegate);
            if (![runDelegate isKindOfClass:[BBLiveBaseTextRunDelegate class]]) continue;

            CGRect runBounds = CGRectZero;
            CGFloat ascent = 0;
            CGFloat descent = 0;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;

            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y - descent;

            CGPathRef pathRef = CTFrameGetPath(_ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);

            attachment.rect = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);

            [attachments addObject:attachment];
        }
    }

    _attachments = attachments.count ? attachments : nil;
}

@end

@implementation BBLiveBaseTextLayout (Draw)

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGAffineTransform transform = CGContextGetCTM(context);
    if (transform.ty != 0) {
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
    }
    CTFrameDraw(_ctFrame, context);

    for (BBLiveBaseAttachment *attachment in _attachments) {
        [attachment drawRect:rect];
    }
}

@end

@implementation BBLiveBaseTextLayout (Event)

#pragma mark - public

- (nullable __kindof BBLiveBaseAttachment *)attachmentAtPoint:(CGPoint)point inView:(UIView *)view {
    if (!self.attachments) return nil;
    for (BBLiveBaseAttachment *attachment in self.attachments) {
        CGRect frame = [attachment transformCoordinateWithRect:view.bounds];
        if (!CGRectContainsPoint(frame, point)) continue;
        return attachment;
    }
    return nil;
}

- (nullable id)linkValueAtPoint:(CGPoint)point inView:(UIView *)view {
    CTRunRef run = [self runAtPoint:point rect:view.bounds];
    return [(NSDictionary *)CTRunGetAttributes(run) valueForKey:NSLinkAttributeName];
}

#pragma mark - private

- (CTRunRef)runAtPoint:(CGPoint)point rect:(CGRect)rect {

    CTFrameRef textFrame = self.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);

    if (!lines) return NULL;

    CFIndex count = CFArrayGetCount(lines);

    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);

    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, CGRectGetHeight(rect));
    transform = CGAffineTransformScale(transform, 1.f, -1.f);

    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);

        CGRect rect = CGRectApplyAffineTransform([self lineRect:line point:linePoint], transform);

        if (!CGRectContainsPoint(rect, point)) continue;

        CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                            point.y-CGRectGetMinY(rect));

        CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);

        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);

        for (int j = 0; j < runCount; j++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            CFRange runRange = CTRunGetStringRange(run);
            BOOL containIdx = runRange.location <= idx && idx <= runRange.length + runRange.location;
            if (containIdx) return run;
        }
    }
    return NULL;
}

- (CGRect)lineRect:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

@end

@implementation BBLiveBaseTextRunDelegate

static void deallocCallback(void *ref) {
    BBLiveBaseTextRunDelegate *self = (__bridge_transfer BBLiveBaseTextRunDelegate *)(ref);
    self = nil; // release
}

static CGFloat ascentCallback(void *ref){
    BBLiveBaseTextRunDelegate *delegate = (__bridge BBLiveBaseTextRunDelegate *)(ref);
    return delegate.ascent;
}

static CGFloat descentCallback(void *ref){
    BBLiveBaseTextRunDelegate *delegate = (__bridge BBLiveBaseTextRunDelegate *)(ref);
    return delegate.descent;
}

static CGFloat widthCallback(void* ref){
    BBLiveBaseTextRunDelegate *delegate = (__bridge BBLiveBaseTextRunDelegate *)(ref);
    return delegate.width;
}

- (nullable CTRunDelegateRef)CTRunDelegate CF_RETURNS_RETAINED {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    callbacks.dealloc = deallocCallback;
    return CTRunDelegateCreate(&callbacks, (__bridge_retained void *)(self));
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(_ascent) forKey:@"ascent"];
    [aCoder encodeObject:@(_descent) forKey:@"descent"];
    [aCoder encodeObject:@(_width) forKey:@"width"];
    [aCoder encodeObject:_userInfo forKey:@"userInfo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _ascent = ((NSNumber *)[aDecoder decodeObjectForKey:@"ascent"]).floatValue;
    _descent = ((NSNumber *)[aDecoder decodeObjectForKey:@"descent"]).floatValue;
    _width = ((NSNumber *)[aDecoder decodeObjectForKey:@"width"]).floatValue;
    _userInfo = [aDecoder decodeObjectForKey:@"userInfo"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) one = [self.class new];
    one.ascent = self.ascent;
    one.descent = self.descent;
    one.width = self.width;
    one.userInfo = self.userInfo;
    return one;
}

@end
