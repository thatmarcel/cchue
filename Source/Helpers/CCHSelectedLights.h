#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>
#import "CCHPrefs.h"
#import "CCHLight.h"

@interface CCHSelectedLights: NSObject
    + (NSArray*) moduleIdentifiers;
    + (NSArray*) lights;
@end
