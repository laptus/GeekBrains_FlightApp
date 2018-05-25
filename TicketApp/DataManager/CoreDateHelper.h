#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "NSString+Localize.h"

@interface CoreDataHelper: NSObject

+(instancetype) sharedInstance;
-(BOOL)isFavorite:(Ticket*) ticket;
-(NSArray*) favorites;
-(void)addToFavorite:(Ticket*) ticket;
-(void)removeFromFavorite:(Ticket*) ticket;

@end
