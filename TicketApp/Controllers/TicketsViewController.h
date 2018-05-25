#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TicketTableViewCell.h"
#import "../DataManager/NotificationCenter.h"
#import "NSString+Localize.h"


@interface TicketsViewController : UITableViewController
-(instancetype) initWithTickets: (NSArray*)tickets;
-(instancetype) initFavoriteTicketController;
@end
