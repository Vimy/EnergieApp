//
//  AppDelegate.m
//  EnergieApp
//
//  Created by Matthias Vermeulen on 20/01/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//


#import "AppDelegate.h"
#import "DataInputViewController.h"
@implementation AppDelegate
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSLog(@"%@", localNotification);
    if    (localNotification)
    {
        application.applicationIconBadgeNumber = 0;
        
        
    }
 
#
    
    //[[UITabBar appearance] setBarTintColor:UIColorFromRGB(0xC0272A)];
       [[UITabBar appearance] setBarTintColor:UIColorFromRGB(0xCE3C00)];
   self.window.tintColor = 	[UIColor whiteColor];
  //  [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xC0272A)];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xCE3C00)];

    //NavigationTitleBar style
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"HelveticaNeue-Medium" size:14], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
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
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
}



@end
