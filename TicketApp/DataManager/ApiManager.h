#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "../Entities/Structures.h"
#import "../Entities/Ticket.h"


@interface ApiManager:NSObject

+(instancetype) sharedInstance;
-(void) cityForCurrentIP:(void(^)(City* city))completion;
-(void)ticketsWithRequest:(SearchRequest) request withCompletion:(void(^)(NSArray* tickets)) completion;
-(void)mapPricesFor:(City*) origin withCompletion:(void(^)(NSArray* prices))completion;
@end
