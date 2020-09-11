#import <Foundation/Foundation.h>

@interface CCHLight: NSObject <NSCoding>
    @property (retain) NSString *identifier;
    @property (retain) NSString *name;

    - (instancetype) duplicate;
@end
