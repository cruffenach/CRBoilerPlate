//
//  CRBoilerPlate.m
//  QuizUs
//
//  Created by Collin Ruffenach on 5/27/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import "CRHelpers.h"
#import <QuartzCore/QuartzCore.h>

NSString * NSStringFromCGRect(CGRect rect) {    
    return [NSString stringWithFormat:@"{%0.f,%0.f,%0.f,%0.f}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

CGRect horizonallyCenteredFrameInRect(CGRect frame, CGRect rect) { 
    frame.origin.x = floorf((rect.size.width-frame.size.width)/2.0);
    return frame;
}

CGRect verticallyCenteredFrameInRect(CGRect frame, CGRect rect) {
    frame.origin.y = floorf((rect.size.height-frame.size.height)/2.0);
    return frame;
}

CGRect centeredFrameInRect(CGRect frame, CGRect rect) {
    frame = verticallyCenteredFrameInRect(horizonallyCenteredFrameInRect(frame, rect), rect);
    return frame;
}

CGRect rectByReplacingX(CGRect rect, CGFloat x) {
    rect.origin.x = x;
    return rect;
}

CGRect rectByReplacingY(CGRect rect, CGFloat y) {
    rect.origin.y = y;
    return rect;
}

CGRect rectByReplacingWidth(CGRect rect, CGFloat width) {
    rect.size.width = width;
    return rect;
}

CGRect rectByReplacingHeight(CGRect rect, CGFloat height) {
    rect.size.height = height;
    return rect;
}

NSString * pathForFileInDocuments(NSString *subdirectory, NSString *fileName) {

    NSString *path;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths objectAtIndex:0];
        
    if(subdirectory) {
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:subdirectory];
        NSError *error;

        if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                           withIntermediateDirectories:YES
                                                            attributes:nil
                                                                 error:&error]) {
                DLog(@"Create directory error: %@", error);
            }
        }
	}
    
    path = [path stringByAppendingPathComponent:fileName];
    
    return path;
}

@implementation NSString (CR)

- (NSString*)stringByReplacingOccurancesOfCharactersInSet:(NSCharacterSet*)characterSet withString:(NSString*)string {
    return [[self componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:string];
}

- (NSString*)stringByRemovingOccurancesOfCharactersInSet:(NSCharacterSet*)characterSet {
    
    return [self stringByReplacingOccurancesOfCharactersInSet:characterSet withString:@""];
}

@end

@implementation UIView (CR)

- (UIImage*)viewAsImageWithSize:(CGSize)size {    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    return image;    
}

- (UIImage*)viewAsImage {    
    return [self viewAsImageWithSize:self.bounds.size];   
}

@end

@implementation UIColor (CR)

#define MIN3(x,y,z)  ((y) <= (z) ? ((x) <= (y) ? (x) : (y)) : ((x) <= (z) ? (x) : (z)))
#define MAX3(x,y,z)  ((y) >= (z) ? ((x) >= (y) ? (x) : (y)) : ((x) >= (z) ? (x) : (z)))

+ (UIColor *)colorWithString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	if (![scanner scanString:@"{" intoString:NULL]) return nil;
	const NSUInteger kMaxComponents = 4;
	CGFloat c[kMaxComponents];
	NSUInteger i = 0;
	if (![scanner scanFloat:&c[i++]]) return nil;
	while (1) {
		if ([scanner scanString:@"}" intoString:NULL]) break;
		if (i >= kMaxComponents) return nil;
		if ([scanner scanString:@"," intoString:NULL]) {
			if (![scanner scanFloat:&c[i++]]) return nil;
		} else {
			// either we're at the end of there's an unexpected character here
			// both cases are error conditions
			return nil;
		}
	}
	if (![scanner isAtEnd]) return nil;
	UIColor *color;
	switch (i) {
		case 2: // monochrome
			color = [UIColor colorWithWhite:c[0] alpha:c[1]];
			break;
		case 4: // RGB
			color = [UIColor colorWithRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
			break;
		default:
			color = nil;
	}
	return color;
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
    
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	return [UIColor colorWithRGBHex:hexNum];
}

void rgb2hsv(CGFloat r, CGFloat g, CGFloat b, CGFloat *h, CGFloat *s, CGFloat *v)
{
	*v = MAX3(r, g, b);
	if (*v == 0)
	{
		*h = 0;
		*s = 0;
		return;
	}
	
	r /= *v;
	g /= *v;
	b /= *v;
	
	*s = 1.0 - MIN3(r, g, b);
	if (*s == 0)
	{
		*h = 0;
		return;
	}
	
	if (r >= g && r >= b)
	{
		*h = 0.16666666667 * (g - b);
		if (*h < 0.0)
		{
			*h += 1.0;
		}
	}
	else if (g >= r && g >= b)
	{
		*h = 0.33333333333 + 0.16666666667 * (b - r);
	}
	else
	{
		*h = 0.66666666667 + 0.16666666667 * (r - g);
	}
}

void hsv2rgb(CGFloat h, CGFloat s, CGFloat v, CGFloat *r, CGFloat *g, CGFloat *b)
{
	if (s == 0.0)
	{
		*r = v;
		*g = v;
		*b = v;
	}
	else
	{
		CGFloat segment, offset, low, falling, rising;
		
		h = fmod(h, 1) * 6;
		
		segment = floor(h);
		offset = h - segment;
        
		low = v * (1 - s);
		falling = v * (1 - s * offset);
		rising = v * (1 - s * (1 - offset));
        
		if (segment == 0)
		{
			*r = v;
			*g = rising;
			*b = low;
		}
		else if (segment == 1)
		{
			*r = falling;
			*g = v;
			*b = low;
		}
		else if (segment == 2)
		{
			*r = low;
			*g = v;
			*b = rising;
		}
		else if (segment == 3)
		{
			*r = low;
			*g = falling;
			*b = v;
		}
		else if (segment == 4)
		{
			*r = rising;
			*g = low;
			*b = v;
		}
		else if (segment == 5)
		{
			*r = v;
			*g = low;
			*b = falling;
		}
    }
}

@end

@implementation UIImage (CR)

-(UIImage*)scaleToSize:(CGSize)size
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);

    // Draw the scaled image in the current context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];

    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    // Pop the current context from the stack
    UIGraphicsEndImageContext();

    // Return our new scaled image
    return scaledImage;
}

@end