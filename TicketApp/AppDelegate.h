//
//  AppDelegate.h
//  TicketApp
//
//  Created by Laptev Sasha on 08/05/2018.
//  Copyright © 2018 Laptev Sasha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Controllers/TabBarController.h"
#import <CoreData/CoreData.h>
#import "DataManager/NotificationCenter.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

