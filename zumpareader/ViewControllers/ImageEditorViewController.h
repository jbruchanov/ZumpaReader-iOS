//
//  ImageEditorViewController.h
//  zumpareader
//
//  Created by Joe Scurab on 7/16/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageEditorViewControllerDelegate <NSObject>

-(void) didFinishEditing:(NSData*)result;

@end

@interface ImageEditorViewController : UIViewController
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<ImageEditorViewControllerDelegate> delegate;
@end
