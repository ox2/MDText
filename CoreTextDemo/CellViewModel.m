//
//  CellViewModel.m
//  CoreTextDemo
//
//  Created by wxiubin on 2019/1/10.
//  Copyright © 2019 wxiubin. All rights reserved.
//

#import "CellViewModel.h"

#define CellViewModelBorderLineWidth ([UIScreen mainScreen].scale)

@interface CellViewModel ()

@property (nonatomic, strong) BBLiveBaseTextLayoutBuilder *builder;

@property (nonatomic, strong) UIColor *textbgcolor;
@property (nonatomic, strong) NSDictionary *attributes;

@end

@implementation CellViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

static int __index = 0;

- (void)initialize {

    NSString *name = @"哔哩哔哩:";
    NSString *text = [@"HXabj“钢之炼金厨师:ᘡAmy🌀晴天冠 ୨୧˙˳⋆ ԅ(¯﹃¯ԅ)”穿着、斩杀、饥渴、鬼化、以及生存最后斩碎世界！stringRange用于创建框架集的属性字符串的范围，在要装入框架的线条中进行排版。如果范围的长度部分设置为0，则框架设置继续添加线条，直到文本或空间用完为止。一个CGPath对象，指定框架的形状。在macOS 10.7或更高版本以及iOS 4.2或更高版本的版本中，路径可以是非矩形的。" stringByAppendingString:@(__index++).stringValue];
    if (__index % 3 == 0) {
        text = @"则框架设置继续添加线条，直到文本或空间用完为止";
    }

    self.attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};

    self.textbgcolor = [UIColor clearColor];

    self.builder = [BBLiveBaseTextLayoutBuilder new];

    [self appendMaster];
    [self appendEmpty];

    [self appendHost];
    [self appendEmpty];

    [self appendMedal];
    [self appendEmpty];

    [self appendZD];
    [self appendEmpty];

    [self appendVIP];
    [self appendEmpty];

    [self.builder appendText:name color:[UIColor redColor] font:[UIFont systemFontOfSize:14] attributes:@{NSLinkAttributeName:@"bilibili.name"}];
    [self.builder appendText:text color:[UIColor blackColor] font:[UIFont systemFontOfSize:14] attributes:nil];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [self.builder addAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.9, 100.);
    [self.builder buildWithRect:rect];

    self.textLayout = self.builder.textLayout;
    self.height = CGRectGetHeight(self.textLayout.rect) + 10;
}

- (void)appendMedal {

    NSString *s = __index % 2 == 0 ? @"啊啊啊" : @"啊HEXO";

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont systemFontOfSize:10],
                                 NSBackgroundColorAttributeName:self.textbgcolor
                                 };
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:s attributes:attributes];

    NSAttributedString *subText = [[NSAttributedString alloc] initWithString:@((int)MIN(12, __index)).stringValue attributes:@{NSForegroundColorAttributeName: HEXCOLOR(0xA068F1), NSFontAttributeName: [UIFont systemFontOfSize:10],NSParagraphStyleAttributeName: paragraphStyle,NSBackgroundColorAttributeName:self.textbgcolor}];
    BBLiveBaseBorderAttachment * attachment = [[BBLiveBaseBorderAttachment alloc] initWithText:text subText:subText offset:CGPointMake(4, 2) minSize:CGSizeMake(16, 16)];
    attachment.action = @"点击了勋章";
    attachment.fillColor = HEXCOLOR(0xA068F1);
    attachment.strokeColor = HEXCOLOR(0xA068F1);
    attachment.strokeWidth = CellViewModelBorderLineWidth;
    attachment.cornerRadius = 2;
    [self.builder appendAttachment:attachment];
}

- (void)appendEmpty {
    BBLiveBaseAttachment *empty = [[BBLiveBaseAttachment alloc] initWithSize:CGSizeMake(3, 1) action:@"点击了空白"];
    [self.builder appendAttachment:empty];
}

- (void)appendVIP {
    BBLiveBaseImageAttachment *attachment = [[BBLiveBaseImageAttachment alloc] initWithSize:CGSizeMake(16, 16) action:@"点击了礼物"];
    attachment.name = @"livebase_dan_month";
    [self.builder appendAttachment:attachment];
}

- (void)appendHost {
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"房管" attributes:@{NSForegroundColorAttributeName: HEXCOLOR(0xFEA249), NSFontAttributeName: [UIFont systemFontOfSize:10],NSBackgroundColorAttributeName:self.textbgcolor}];
    BBLiveBaseBorderAttachment * attachment = [[BBLiveBaseBorderAttachment alloc] initWithText:text subText:nil offset:CGPointMake(4, 2) minSize:CGSizeMake(16, 16)];
    attachment.action = @"点击了房管";
    attachment.strokeColor = HEXCOLOR(0xFEA249);
    attachment.strokeWidth = CellViewModelBorderLineWidth;
    attachment.cornerRadius = 2;
    [self.builder appendAttachment:attachment];
}

- (void)appendZD {
    BBLiveBaseImageAttachment *attachment = [[BBLiveBaseImageAttachment alloc] initWithSize:CGSizeMake(18, 18) action:@"点击了总督"];
    attachment.name = @"livebase_governor_ico";
    [self.builder appendAttachment:attachment];
}

- (void)appendMaster {
    BBLiveBaseImageAttachment *attachment = [[BBLiveBaseImageAttachment alloc] initWithSize:CGSizeMake(16, 16) action:@"点击了姥爷"];
    attachment.name = @"livebase_dan_month";
    [self.builder appendAttachment:attachment];
}

- (void)appendLink {
    [self.builder appendAttributedString:[[NSAttributedString alloc] initWithString:@"啊啊啊Link test 啊" attributes:@{
                                                                                                              NSLinkAttributeName: @"link 22333",NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                                                                              }]];
}

@end
