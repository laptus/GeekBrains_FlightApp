#import "CoreDateHelper.h"

@interface CoreDataHelper()

@property (nonatomic,strong) NSPersistentStoreCoordinator* persistantSoreCoordinator;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel* managedObjectModel;

@end

@implementation CoreDataHelper

+(instancetype)sharedInstance{
    static CoreDataHelper* dm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dm = [[CoreDataHelper alloc]init];
        [dm setup];
    });
    return dm;
}

-(void)setup{
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"FavoriteTicket" withExtension:@"momd"];
    NSAssert(modelURL, @"Failed to locate momd bundle in application");
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(_managedObjectModel, @"Failed to initialize mom from URL: %@", modelURL);
    NSURL* docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL* storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
    _persistantSoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    NSPersistentStore* store = [_persistantSoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    if (!store){
        abort();
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistantSoreCoordinator;
}

-(void)save{
    NSError* error;
    [_managedObjectContext save:&error];
    if (error){
        NSLog(@"%@",[error localizedDescription]);
    }
}

-(FavoriteTicket*)favoriteFromTicket:(Ticket*) ticket{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld",( long )ticket. price . integerValue , ticket.airline , ticket.from , ticket.t0 , ticket.departure , ticket.expires ,
                         ( long )ticket.flightNumber.integerValue];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

-(BOOL)isFavorite:(Ticket *)ticket{
    return [self favoriteFromTicket:ticket]!= nil;
}

-(void)addToFavorite:(Ticket *)ticket{
    FavoriteTicket* favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
    favorite.price = 10;
    favorite.price = ticket.price.intValue ;
    favorite.airline = ticket.airline ;
    favorite.departure = ticket.departure ;
    favorite.expires = ticket.expires ;
    favorite.flightNumber = ticket.flightNumber.intValue ;
    favorite.returnDate = ticket.returnDate ;
    favorite.from = ticket.from ;
    favorite.to = ticket.t0 ;
    favorite.created = [ NSDate date ];
    [ self save ];
}

-(void) removeFromFavorite:(Ticket *)ticket{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    [_managedObjectContext executeFetchRequest:request error:nil];
}

-(NSArray*)favorites{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]] ;
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

@end
