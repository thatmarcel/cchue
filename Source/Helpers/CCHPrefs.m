#import "CCHPrefs.h"

@implementation CCHPrefs
    + (HBPreferences*) get {
        HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier: @"com.thatmarcel.tweaks.cchue.prefs"];
        [prefs registerDefaults:@{
            @"username": @"",
            @"ip": @"",
            @"selectedlights": [NSKeyedArchiver archivedDataWithRootObject: @[ ]]
        }];

        return prefs;
    }
@end
