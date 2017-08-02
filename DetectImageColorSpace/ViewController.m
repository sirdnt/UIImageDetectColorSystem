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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _testImages = @[@"bw.png",@"grayscale.png",@"normal.png"];
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

@end
