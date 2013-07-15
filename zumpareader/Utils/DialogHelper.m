//
//  DialogHelper.m
//  zumpareader
//
//  Created by Joe Scurab on 7/14/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "DialogHelper.h"
#import <QuartzCore/QuartzCore.h>


@implementation DialogHelper

//    [indicator removeFromSuperview]   
+(UIActivityIndicatorView*) showProgressDialog:(UIView*)parentView{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 10.0;
    indicator.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
    indicator.center = parentView.center;
    [indicator bringSubviewToFront:parentView];
    [indicator startAnimating];
    [parentView addSubview:indicator];
    return indicator;
}
@end
