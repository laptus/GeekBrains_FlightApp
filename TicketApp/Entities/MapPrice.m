#import "MapPrice.h"

@implementation MapPrice

-(instancetype)initWithDictionary:(NSDictionary*)dictionary withOrigin:(City*)origin{
    self = [super init];
    if (self){
        _destination = [[DataManager sharedInstance] cityForIata: [dictionary valueForKey:@"destination"]];
        _origin = origin;
        _departure = [self dateFromStrin:[dictionary valueForKey:@"depart_date"]];
        _returnDate = [self dateFromStrin:[dictionary valueForKey:@"return_date"]];
        _numberOfChanges = [[dictionary valueForKey:@"number_of_changes"] integerValue];
        _value = [[dictionary valueForKey:@"value"] integerValue];
        _distance = [[dictionary valueForKey:@"distance"] integerValue];
        _actual = [[dictionary valueForKey:@"actual"] boolValue];
    }
    return self;
}

-(NSDate* _Nullable) dateFromStrin:(NSString*) dateString{
    if (!dateString){
        return nil;
    }
    NSDateFormatter* dateFofomatter = [[NSDateFormatter alloc] init];
    dateFofomatter.dateFormat = @"yyyy-MM-dd";
    return [dateFofomatter dateFromString:dateString];
}

@end
