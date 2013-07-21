//
//  ImageEditorViewController.m
//  zumpareader
//
//  Created by Joe Scurab on 7/16/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "ImageEditorViewController.h"

#define JPEG_QUALITY 80
#define Q3_SIZE_LIMIT 3000

@interface ImageEditorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *originalResolution;
@property (weak, nonatomic) IBOutlet UILabel *originalSize;
@property (weak, nonatomic) IBOutlet UILabel *updatedResolution;
@property (weak, nonatomic) IBOutlet UILabel *updatedSize;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImage *updatedImage;
@property (strong, nonatomic) NSData *updatedImageData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneKey;

@property int currentRotation;

@end

@implementation ImageEditorViewController

@synthesize image = _image, updatedImage = _updatedImage, currentRotation = _currentRotation, delegate = _delegate;

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

UIImageOrientation rotation = UIImageOrientationUp;

- (IBAction)rotateDidClick:(id)sender {
    rotation = [self nextRotation:rotation];
    self.updatedImage = [[UIImage alloc] initWithCGImage: self.updatedImage.CGImage
                                                   scale: 1.0
                                             orientation: rotation];
    
    self.imageView.image = self.updatedImage;
    [self updateStats];
}

-(UIImageOrientation) nextRotation:(UIImageOrientation) current{
    switch(current){
        default:
        case UIImageOrientationUp:
            return UIImageOrientationRight;
        case UIImageOrientationRight:
            return UIImageOrientationDown;
        case UIImageOrientationDown:
            return UIImageOrientationLeft;
        case UIImageOrientationLeft:
            return UIImageOrientationUp;
    }
}

-(void)updateStats{
    
    NSString *res = [NSString stringWithFormat:@"%dx%d", (int)self.image.size.width, (int)self.image.size.height];
    NSData* imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.image, JPEG_QUALITY)];
    NSString *size = [NSString stringWithFormat:@"%d KiB", ([imageData length] / 1000)];
    self.originalResolution.text = res;
    self.originalSize.text = size;
    
    if(self.updatedImage){
        NSString *res = [NSString stringWithFormat:@"%dx%d", (int)self.updatedImage.size.width, (int)self.updatedImage.size.height];
        self.updatedImageData = [NSData dataWithData:UIImageJPEGRepresentation(self.updatedImage, JPEG_QUALITY)];
        int kibs = ([self.updatedImageData length] / 1000);
        NSString *size = [NSString stringWithFormat:@"%d KiB", kibs];
        self.updatedResolution.text = res;
        self.updatedSize.text = size;
        self.updatedSize.textColor = kibs >= Q3_SIZE_LIMIT ? [UIColor redColor] : [UIColor blackColor];
        [self.doneKey setEnabled:kibs < Q3_SIZE_LIMIT];
    }else{
        self.updatedResolution.text = @"";
        self.updatedSize.text = @"";
    }
}

- (IBAction)resizeDidClick:(UISegmentedControl *)sender {
    float scale = 1 << sender.selectedSegmentIndex;
    if(scale == 1){
        self.updatedImage = self.image;
        rotation = UIImageOrientationUp;
    }else{
        self.updatedImage = [self imageWithImage:self.image scaleRatio: 1 / scale];
    }
    
    self.imageView.image = self.updatedImage;
    [self updateStats];
}

- (UIImage*)imageWithImage:(UIImage*)image
                scaleRatio:(float)ratio
{
    CGSize origSize = image.size;
    CGSize newSize = CGSizeMake(origSize.width * ratio, origSize.height * ratio);
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)cancelDidClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate didFinishEditing:nil];
}

- (IBAction)doneDidClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate didFinishEditing:self.updatedImageData];
}

@end
