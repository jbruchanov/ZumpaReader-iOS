//
// Created by Joe Scurab on 27/04/14.
// Copyright (c) 2014 Jiri Bruchanov. All rights reserved.
//

#import "ZumpaHelper.h"


@implementation ZumpaHelper {

}

+ (DetailViewController *)controllerForZumpaSubItem {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    DetailViewController *dc = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];

    dc.zumpa = [[ZumpaAsyncWrapper alloc] initWithWebService:[[ZumpaWSClient alloc] init]];
    ZumpaItem *zi = [[ZumpaItem alloc] init];
    zi.subject = @"Zumpicka";//[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    dc.settings = [NSUserDefaults standardUserDefaults];
    dc.item = zi;
    return dc;
}

+ (DetailViewController *)controllerForZumpaSubItemById:(int)threadId {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    DetailViewController *dc = [ZumpaHelper controllerForZumpaSubItem];
    dc.item.ID = threadId;
    dc.item.itemsUrl = [NSString stringWithFormat:@"http://portal2.dkm.cz/phorum/read.php?f=2&i=%d&t=%d", threadId, threadId];
    return dc;
}


+ (DetailViewController *)controllerForZumpaSubItemByLink:(NSString *)link {
    DetailViewController *dc = [ZumpaHelper controllerForZumpaSubItem];
    dc.item.ID = [[link substringFromIndex:[link rangeOfString:@"&t="].location + 3] intValue];
    dc.item.itemsUrl = link;
    if (dc.item.ID == 0) {
        //something is wrong, need ID
        NSURL *url = [NSURL URLWithString:link];
        [[UIApplication sharedApplication] openURL:url];
        return nil;
    }
    return dc;
}


@end