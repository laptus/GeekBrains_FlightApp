#import <Foundation/Foundation.h>

typedef struct SearchRequest{
    __unsafe_unretained NSString* origin;
    __unsafe_unretained NSString* destination;
    __unsafe_unretained NSString* departTime;
    __unsafe_unretained NSString* returnDate;
} SearchRequest;
