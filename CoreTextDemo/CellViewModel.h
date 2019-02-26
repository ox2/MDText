//
//  CellViewModel.h
//  CoreTextDemo
//
//  Created by wxiubin on 2019/1/10.
//  Copyright © 2019 wxiubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBLiveBaseTextLayoutBuilder.h"

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

NS_ASSUME_NONNULL_BEGIN


@interface CellViewModel : NSObject

@property (nonatomic, strong) BBLiveBaseTextLayout *textLayout;

@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
