//
//  ViewController.m
//  DetectImageColorSpace
//
//  Created by Sir.DNT on 8/3/17.
//  Copyright © 2017 sir.dnt@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Detect.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray *testImages;
@property (weak, nonatomic) IBOutlet UIImageView *originImage;
@property (weak, nonatomic) IBOutlet UIImageView *convertedImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _testImages = @[@"bw.png",@"grayscale.png",@"normal.png"];
    self.originImage.image = [UIImage imageNamed:@"normal"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)testbw:(id)sender {
    for (NSString * imgName in _testImages) {
        UIImage * testImage = [UIImage imageNamed:imgName];
        BOOL isBW = [testImage isBW];
        NSLog(@"image named \"%@\" is %@B/W image",imgName,isBW?@"":@"not ");
    }
    NSLog(@"\n\n");
}

- (IBAction)btnGrayscale:(id)sender {
    for (NSString * imgName in _testImages) {
        UIImage * testImage = [UIImage imageNamed:imgName];
        BOOL isGrayScale = [testImage isGrayScale];
        NSLog(@"image named \"%@\" is %@grayscale image",imgName,isGrayScale?@"":@"not ");
    }
    NSLog(@"\n\n");
}

- (IBAction)testNormalImage:(id)sender {
    for (NSString * imgName in _testImages) {
        UIImage * testImage = [UIImage imageNamed:imgName];
        BOOL isNormal = ![testImage isGrayScale];
        NSLog(@"image named \"%@\" is %@color image",imgName,isNormal?@"":@"not ");
    }
    NSLog(@"\n\n");
}

- (IBAction)testAverage:(id)sender {
    UIImage * testImage = [UIImage imageNamed:@"gray_2x1"];
    UIImage * grayImage = [self convertToGreyscale:testImage];
    float average1 = [testImage averageGrayscale];
    float average2 = [grayImage averageGrayscale];
    NSLog(@"average gray scale 1 = %f",average1);
    NSLog(@"average gray scale 2 = %f",average2);
}

- (IBAction)testUI:(id)sender {
    self.convertedImage.image = [self convertToGreyscale:[UIImage imageNamed:@"normal"]];
}


//- (UIImage *)convertImageToGrayScale:(UIImage *)image {
//    
//    
//    // Create image rectangle with current image width/height
//    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
//    
//    // Grayscale color space
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    
//    // Create bitmap content with current image size and grayscale colorspace
//    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
//    
//    // Draw image into current context, with specified rectangle
//    // using previously defined context (with grayscale colorspace)
//    CGContextDrawImage(context, imageRect, [image CGImage]);
//    
//    // Create bitmap image info from pixel data in current context
//    CGImageRef imageRef = CGBitmapContextCreateImage(context);
//    
//    // Create a new UIImage object
//    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
//    
//    // Release colorspace, context and bitmap information
//    CGColorSpaceRelease(colorSpace);
//    CGContextRelease(context);
//    CFRelease(imageRef);
//    
//    // Return the new grayscale image
//    return newImage;
//}

- (UIImage *) convertToGreyscale:(UIImage *)i {
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen | kBlue | kRed;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        int val=m_imageData[i];
        result[i*4]=val;
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=255;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}

@end
