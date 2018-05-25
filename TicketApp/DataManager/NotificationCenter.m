#import "NotificationCenter.h"

@interface NotificationCenter()<UNUserNotificationCenterDelegate>

@end

@implementation NotificationCenter
+(instancetype) sharedInstance{
    static NotificationCenter* dm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dm = [[NotificationCenter alloc]init];
    });
    return dm;
}


-(void)registerService{
    if (@available(iOS 10.0,*)){
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error){
                NSLog(@"request authrization succeeded");
            }
        }];
    }
}

-(void) sendNotification:(Notification)notification{
    
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc]init];
    content.title = notification.title;
    content.body = notification.body;
    content.sound = [UNNotificationSound defaultSound];
    if (notification.imageUrl){
        UNNotificationAttachment *attachment = [ UNNotificationAttachment attachmentWithIdentifier : @"image" URL:notification.imageUrl options: nil error: nil ];
        if (attachment) {
            content. attachments = @[attachment];
        }
    }
    
    NSCalendar* calender = [NSCalendar calendarWithIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calender componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate: notification.date];
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calender;
    newComponents.timeZone = [NSTimeZone defaultTimeZone];
    newComponents.month = components.month ;
    newComponents.day = components.day ;
    newComponents.hour = components.hour ;
    newComponents.minute = components.minute;
    
    UNCalendarNotificationTrigger* triger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:NO];
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"notification" content:content trigger:triger];
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

Notification NotificationMake( NSString * _Nullable title, NSString * _Nonnull body, NSDate * _Nonnull date,
                              NSURL * _Nullable imageURL) {
    Notification notification;
    notification.title = title;
    notification.body = body;
    notification.date = date;
    notification.imageUrl = imageURL;
    return notification;
}

@end
