//
//  BBLiveBaseAttachment+Private.h
//  CoreTextDemo
//
//  Created by wxiubin on 2019/2/17.
//  Copyright © 2019 wxiubin. All rights reserved.
//

#import "BBLiveBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@class BBLiveBaseTextLayout;

@interface BBLiveBaseAttachment ()

@property (nonatomic, assign) CGSize size;
// Cocoa 坐标系
@property (nonatomic, assign) CGRect rect;

@end


@interface BBLiveBaseBorderAttachment ()

// auto calculate when set text
@property (nonatomic, assign, readonly) CGSize textSize;
@property (nonatomic, assign, readonly) CGSize subTextSize;

@property (nonatomic, assign, readonly) CGRect textRect;
@property (nonatomic, assign, readonly) CGRect subTextRect;

@property (nonatomic, strong, readonly) UIImage *image;

@end

NS_ASSUME_NONNULL_END
