Memory leak stack：

```
[BBLiveBaseBorderAttachment _createBorderImage]

- (void)drawBorderRect:(CGRect)rect lineWidth:(CGFloat)lineWidth strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor
```

```

- (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter rect:(CGRect)rect {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);

    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}
```