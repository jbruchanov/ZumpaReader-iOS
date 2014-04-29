//
//  AppDelegate.m
//  zumpareader
//
//  Created by Joe Scurab on 7/10/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "AppDelegate.h"
#import "Settings.h"
#import "ZumpaHelper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *userInfo = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSString *threadId = [userInfo objectForKey:@"threadId"];
    if (threadId) {
        [[NSUserDefaults standardUserDefaults] setValue:threadId forKey:THREAD_ID_TO_OPEN];
    }

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
            (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:PUSH_TOKEN];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:PUSH_TOKEN];
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"%@",@"XXX:didReceiveRemoteNotification");
//    NSString *threadId = [userInfo valueForKey:@"threadId"];
//    if (threadId) {
//        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//        localNotif.fireDate = [NSDate date];  // date after 10 sec from now
//        localNotif.timeZone = [NSTimeZone defaultTimeZone];
//        localNotif.alertBody = @"Žumpoviny si tě žádají"; // text of you that you have fetched
//        localNotif.soundName = UILocalNotificationDefaultSoundName;
//
//        localNotif.userInfo = @{@"threadId" : threadId, @"time" : @([[NSDate date] timeIntervalSince1970])};
//        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
//    }
//}
//
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    NSLog(@"%@",@"XXX:didReceiveLocalNotification");
//    if (UIApplicationStateActive != application.applicationState) {//stupid click detection event
//        double now = [[NSDate date] timeIntervalSince1970];
//        double fired = [[notification.userInfo objectForKey:@"time"] doubleValue];
//        double diff = now - fired;
//        int threadId = [[notification.userInfo objectForKey:@"threadId"] intValue];
//        if (diff > 1 && threadId > 0) {
//            [application cancelLocalNotification:notification];
//            [(UINavigationController *) self.window.rootViewController pushViewController:[ZumpaHelper controllerForZumpaSubItemById:threadId] animated:YES];
//        }
//    }
//}

@end
