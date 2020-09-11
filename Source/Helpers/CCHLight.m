#import "CCHLight.h"

@implementation CCHLight
    @synthesize identifier;
    @synthesize name;

    - (instancetype) duplicate {
        CCHLight *duplicate  = [[CCHLight alloc] init];
        duplicate.identifier = [self.identifier copy];
        duplicate.name       = [self.name copy];

        return duplicate;
    }

    - (instancetype) initWithCoder:(NSCoder *)decoder {
        self = [super init];
        if (!self) {
            return nil;
        }

        self.identifier = [decoder decodeObjectForKey: @"identifier"];
        self.name       = [decoder decodeObjectForKey: @"name"];

        return self;
    }

    - (void) encodeWithCoder:(NSCoder *)encoder {
        [encoder encodeObject: self.identifier forKey: @"identifier"];
        [encoder encodeObject: self.name forKey: @"name"];
    }
@end
