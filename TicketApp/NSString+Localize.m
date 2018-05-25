#import "NSString+Localize.h"

@implementation NSString(Localize)

-(NSString*) localize{
    return NSLocalizedString(self,"");
}

@end
