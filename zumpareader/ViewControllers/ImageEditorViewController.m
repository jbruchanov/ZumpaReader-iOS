//
//  ImageEditorViewController.m
//  zumpareader
//
//  Created by Joe Scurab on 7/16/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ImageEditorViewController.h"

@interface ImageEditorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *originalResolution;
@property (weak, nonatomic) IBOutlet UILabel *originalSize;
@property (weak, nonatomic) IBOutlet UILabel *updatedResolution;
@property (weak, nonatomic) IBOutlet UILabel *updatedSize;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImage *updatedImage;

@property int currentRotation;

@end

@implementation ImageEditorViewController

@synthesize image = _image, updatedImage = _updatedImage, currentRotation = _currentRotation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = self.image;
    self.updatedImage = self.image;
    [self updateStats];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

int rotation;
- (IBAction)rotateDidClick:(id)sender {    
    self.updatedImage = [[UIImage alloc] initWithCGImage: self.updatedImage.CGImage
                                                   scale: 1.0
                                             orientation: rotation++];
    
    self.imageView.image = self.updatedImage;
    [self updateStats];
}

-(void)updateStats{
    
    NSString *res = [NSString stringWithFormat:@"%dx%d", (int)self.image.size.width, (int)self.image.size.height];
    NSString *size = [NSString stringWithFormat:@"%d KiB", -1];
    self.originalResolution.text = res;
    self.originalSize.text = size;
    
    if(self.updatedImage){
        NSString *res = [NSString stringWithFormat:@"%dx%d", (int)self.updatedImage.size.width, (int)self.updatedImage.size.height];
        NSString *size = [NSString stringWithFormat:@"%d KiB", -1];
        self.updatedResolution.text = res;
        self.updatedSize.text = size;
    }else{
        self.updatedResolution.text = @"";
        self.updatedSize.text = @"";
    }
    
    
}

- (IBAction)resizeDidClick:(UISegmentedControl *)sender {
    float scale = 1;
    switch (sender.selectedSegmentIndex) {
        default:
        case 0:
            scale = 1;
            break;
        case 1:
            scale = 2;
            break;
        case 2:
            scale = 4;
            break;
        case 3:
            scale = 8;
            break;
    }
    
    self.updatedImage = [[UIImage alloc] initWithCGImage: self.image.CGImage
                                                   scale: scale
                                             orientation: rotation];
    
    self.imageView.image = self.updatedImage;
    [self updateStats];

}

@end
