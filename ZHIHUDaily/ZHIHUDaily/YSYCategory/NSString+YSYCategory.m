//
//  NSString+YSYCategory.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/15.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "NSString+YSYCategory.h"
#import <CoreText/CoreText.h>

@implementation NSString (YSYCategory)

- (CGSize)ysy_sizeWithConstrainedToWidth:(CGFloat)width
                            fromFont:(UIFont *)font
                           lineSpace:(CGFloat)lineSpace {
    
    return [self ysy_sizeWithConstrainedToSize:CGSizeMake(width, CGFLOAT_MAX) fromFont:font lineSpace:lineSpace];

}
- (CGSize)ysy_sizeWithConstrainedToSize:(CGSize)size
                           fromFont:(UIFont *)font
                          lineSpace:(CGFloat)lineSpace {
    
    CGFloat minimumLineHeight = font.pointSize,maximumLineHeight = minimumLineHeight, linespace = lineSpace;
    CTFontRef mfont = CTFontCreateWithName((__bridge CFStringRef)font.fontName,font.pointSize,NULL);
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    //Apply paragraph settings
    CTTextAlignment alignment = kCTLeftTextAlignment;
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },6);
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)mfont,(NSString*)kCTFontAttributeName,(__bridge id)style,(NSString*)kCTParagraphStyleAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)string;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGSize result = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [string length]), NULL, size, NULL);
    CFRelease(framesetter);
    CFRelease(mfont);
    CFRelease(style);
    string = nil;
    attributes = nil;
    return result;
}


- (void)ysy_drawInContext:(CGContextRef)context
             position:(CGPoint)pos
                 font:(UIFont *)font
            textColor:(UIColor *)color
               height:(CGFloat)height {
    
    [self ysy_drawInContext:context position:pos font:font textColor:color height:height width:CGFLOAT_MAX];
}

- (void)ysy_drawInContext:(CGContextRef)context
             position:(CGPoint)pos
                 font:(UIFont *)font
            textColor:(UIColor *)color
               height:(CGFloat)height
                width:(CGFloat)width {
    
    CGSize size = CGSizeMake(width, font.pointSize+10);
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0,height);
    CGContextScaleCTM(context,1.0,-1.0);
    
    //Determine default text color
    UIColor* textColor = color;
    //Set line height, font, color and break mode
    CTFontRef font1 = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize,NULL);
    //Apply paragraph settings
    CGFloat minimumLineHeight = font.pointSize,maximumLineHeight = minimumLineHeight+10, linespace = 5;
    CTLineBreakMode lineBreakMode = kCTLineBreakByTruncatingTail;
    CTTextAlignment alignment = kCTLeftTextAlignment;
    //Apply paragraph settings
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },6);
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font1,(NSString*)kCTFontAttributeName,
                                textColor.CGColor,kCTForegroundColorAttributeName,
                                style,kCTParagraphStyleAttributeName,
                                nil];
    //Create path to work with a frame with applied margins
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path,NULL,CGRectMake(pos.x, height-pos.y-size.height,(size.width),(size.height)));
    
    //Create attributed string, with applied syntax highlighting
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)attributedStr;
    
    //Draw the frame
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0,CFAttributedStringGetLength(attributedString)),path,NULL);
    CTFrameDraw(ctframe,context);
    CGPathRelease(path);
    CFRelease(font1);
    CFRelease(framesetter);
    CFRelease(ctframe);
    [[attributedStr mutableString] setString:@""];
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0, height);
    CGContextScaleCTM(context,1.0,-1.0);
}

@end
