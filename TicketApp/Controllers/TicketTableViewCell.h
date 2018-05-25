//#import <UIKit/UIKit.h>
#import "../DataManager/DataManager.h"
#import "../DataManager/ApiManager.h"
#import "NSString+Localize.h"

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket* ticket;
@property (nonatomic, strong) Ticket* favoriteTicket;
@property (nonatomic, strong) UIImageView* airlineLogoView;

@end
