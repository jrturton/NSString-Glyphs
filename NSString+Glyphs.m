//
//  NSString+Glyphs.m
//  counting-toy
//
//  Created by Richard Turton on 06/06/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import "NSString+Glyphs.h"
#import <CoreText/CoreText.h>

@implementation NSString (Glyphs)

-(UIBezierPath*)bezierPathWithFont:(UIFont*)font
{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.familyName, font.pointSize, NULL);
    NSAttributedString *attributed = [[NSAttributedString alloc] initWithString:self attributes:[NSDictionary dictionaryWithObject:(__bridge id)ctFont forKey:(__bridge NSString*)kCTFontAttributeName]];
    CFRelease(ctFont);
    
    CGMutablePathRef letters = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributed);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    CGRect boundingBox = CGPathGetBoundingBox(letters);
    CGPathRelease(letters);
    CFRelease(line);
    
    // The path is upside down (CG coordinate system)
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    return path;
}

@end
