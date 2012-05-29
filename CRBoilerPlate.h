//
//  CRBoilerPlate.h
//  QuizUs
//
//  Created by Collin Ruffenach on 5/27/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Degrees To Radians

#define degreesToRadians(x) (M_PI * x / 180.0)

#pragma mark - Debug Logs

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#pragma mark - CGRect Enhancements

NSString * NSStringFromCGRect(CGRect rect);
CGRect centeredFrameInRect(CGRect frame, CGRect rect);
CGRect horizonallyCenteredFrameInRect(CGRect frame, CGRect rect);
CGRect verticallyCenteredFrameInRect(CGRect frame, CGRect rect);

CGRect rectByReplacingX(CGRect rect, CGFloat x);
CGRect rectByReplacingY(CGRect rect, CGFloat y);
CGRect rectByReplacingWidth(CGRect rect, CGFloat width);
CGRect rectByReplacingHeight(CGRect rect, CGFloat height);

#pragma mark - File Path Construction

NSString * pathForFileInDocuments(NSString *subdirectory, NSString *fileName);

#pragma mark - NSString Enhancements

@interface NSString (CR)

- (NSString*)stringByReplacingOccurancesOfCharactersInSet:(NSCharacterSet*)characterSet withString:(NSString*)string;
- (NSString*)stringByRemovingOccurancesOfCharactersInSet:(NSCharacterSet*)characterSet;

@end
 
#pragma mark - UIView Enhancements

@interface UIView (CR)

- (UIImage*)viewAsImage;

@end

#pragma mark - UIColor Enhancements

@interface UIColor (CR)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

void rgb2hsv(CGFloat r, CGFloat g, CGFloat b, CGFloat *h, CGFloat *s, CGFloat *v);
void hsv2rgb(CGFloat h, CGFloat s, CGFloat v, CGFloat *r, CGFloat *g, CGFloat *b);

@end

#pragma mark - UIImage Enhancements

@interface UIImage (CR)

-(UIImage*)scaleToSize:(CGSize)size;

@end