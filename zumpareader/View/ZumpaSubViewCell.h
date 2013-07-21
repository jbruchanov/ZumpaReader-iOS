//
//  ZumpaSubViewCell.h
//  ZumpaReader
//
//  Created by Joe Scurab on 7/8/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZumpaSubItem.h"
#import "UISurvey.h"

@interface ZumpaSubViewCell : UITableViewCell

@property (nonatomic, readonly) int surveyHeight;

@property (nonatomic, readonly) int height;

@property (strong, nonatomic) UISurvey *survey;

-(void)setItem:(ZumpaSubItem*)item withSurvey:(BOOL) createSurvey;
-(UIFont*) fontForMeasurement;

@end
