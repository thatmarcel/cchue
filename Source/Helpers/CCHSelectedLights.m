#import "CCHSelectedLights.h"

@implementation CCHSelectedLights
    static NSArray *__moduleIdentifiers;
    static NSArray *__lights;

    + (NSArray*) moduleIdentifiers {
        if (__moduleIdentifiers) {
            return __moduleIdentifiers;
        }

        NSMutableArray *mutableArray = [NSMutableArray new];

        for (CCHLight *light in self.lights) {
            [mutableArray addObject: [NSString stringWithFormat: @"com.thatmarcel.tweaks.cchue.modules.%@", light.identifier]];
        }

        __moduleIdentifiers = [mutableArray copy];

        return __moduleIdentifiers;
    }

    + (NSArray*) lights {
        if (__lights) {
            return __lights;
        }

        __lights = [[NSKeyedUnarchiver unarchiveObjectWithData: [[CCHPrefs get] objectForKey: @"selectedlights"]] copy];
        return __lights;
    }
@end
