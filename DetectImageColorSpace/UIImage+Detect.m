//
//  UIImage+Detect.m
//  DetectImageColorSpace
//
//  Created by Sir.DNT on 8/3/17.
//  Copyright © 2017 sir.dnt@gmail.com. All rights reserved.
//

#import "UIImage+Detect.h"

@implementation UIImage (Detect)

- (BOOL)isGrayScale {
    CGImageRef imageRef = [self CGImage];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelRGB) {
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        CFDataRef imageData = CGDataProviderCopyData(dataProvider);
        const UInt8 *rawData = CFDataGetBytePtr(imageData);
        
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        
        int byteIndex = 0;
        BOOL allPixelsGrayScale = YES;
        for(int ii = 0 ; ii <width*height; ++ii)
        {
            int r = rawData[byteIndex];
            int g = rawData[byteIndex+1];
            int b = rawData[byteIndex+2];
            if (!((r == g)&&(g == b))) {
                allPixelsGrayScale = NO;
                break;
            }
            byteIndex += 4;
        }
        CFRelease(imageData);
        CGColorSpaceRelease(colorSpace);
        return allPixelsGrayScale;
    } else if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelMonochrome){
        CGColorSpaceRelease(colorSpace); return YES;
    } else {
        CGColorSpaceRelease(colorSpace); return NO;
    }
}

- (BOOL)isBW {
    CGImageRef imageRef = [self CGImage];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelRGB) {
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        CFDataRef imageData = CGDataProviderCopyData(dataProvider);
        const UInt8 *rawData = CFDataGetBytePtr(imageData);
        
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        
        int byteIndex = 0;
        BOOL allPixelsBW = YES;
        for(int ii = 0 ; ii <width*height; ++ii)
        {
            int r = rawData[byteIndex];
            int g = rawData[byteIndex+1];
            int b = rawData[byteIndex+2];
            if (!(r==0||r==255) || !(g==0||g==255) || !(b==0||b==255)) {
                allPixelsBW = NO;
                break;
            }
            byteIndex += 4;
        }
        CFRelease(imageData);
        CGColorSpaceRelease(colorSpace);
        return allPixelsBW;
    } else if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelMonochrome){
        CGColorSpaceRelease(colorSpace); return NO;
    } else {
        CGColorSpaceRelease(colorSpace); return NO;
    }
}

- (float)averageGrayscale {
    CGImageRef imageRef = [self CGImage];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelRGB) {
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        CFDataRef imageData = CGDataProviderCopyData(dataProvider);
        const UInt8 *rawData = CFDataGetBytePtr(imageData);
        
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        
        int byteIndex = 0;
        long total = 0;
        long numberBytes = width*height;
        for(int ii = 0 ; ii < numberBytes; ++ii)
        {
            int r = rawData[byteIndex];
            int g = rawData[byteIndex+1];
            int b = rawData[byteIndex+2];
            int a = rawData[byteIndex+3];
            NSLog(@"r g b a= (%d, %d, %d, %d)",r,g,b,a);
            total += r;
            byteIndex += 4;
        }
        CFRelease(imageData);
        CGColorSpaceRelease(colorSpace);
        return (float)total/(numberBytes*255);
    } else if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelMonochrome){
        CGColorSpaceRelease(colorSpace); return 0;
    } else {
        CGColorSpaceRelease(colorSpace); return 0;
    }

}


@end
