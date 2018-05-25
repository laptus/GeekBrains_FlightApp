#import <UIKit/UIKit.h>
#import "../DataManager/DataManager.h"
#import "NSString+Localize.h"

typedef enum PlaceType{
    PlaceTypeArrival,
    PlaceTypeDeparture
} PlaceType;

@protocol PlaceViewControllerDelegate <NSObject>
-(void) selectPlace: (id) place withType: (PlaceType) placeType andDataType:(DataSourceType) dataType;
@end

@interface PlaceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) id<PlaceViewControllerDelegate> delegate;
-(instancetype) initWithType: (PlaceType) type;
@end
