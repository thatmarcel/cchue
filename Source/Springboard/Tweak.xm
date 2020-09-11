#import "Headers/CCSModuleMetadata.h"
#import "../Helpers/CCHSelectedLights.h"
#import "../Helpers/CCHPrefs.h"
#import <Cephei/HBPreferences.h>

%hook CCSModuleRepository
    - (CCSModuleMetadata*) moduleMetadataForModuleIdentifier:(NSString*)identifier {
        if ([identifier hasPrefix: @"com.thatmarcel.tweaks.cchue.modules."]) {
            return [[%c(CCSModuleMetadata) alloc]
                        _initWithModuleIdentifier: identifier
                        supportedDeviceFamilies: [NSSet setWithArray: @[ @1, @2 ]]
                        requiredDeviceCapabilities: [NSSet set]
                        associatedBundleIdentifier: nil
                        associatedBundleMinimumVersion: nil
                        visibilityPreference: 0
                        moduleBundleURL: [NSURL fileURLWithPath: @"/Library/ControlCenter/Bundles/CCHueControlCenterModule.bundle"]];
        } else {
            return %orig;
        }
    }

    /* - (NSSet *) _loadableModuleIdentifiers {
        return [%orig setByAddingObjectsFromArray: moduleIdentifiers];
    } */

    - (NSSet *) loadableModuleIdentifiers {
        return [%orig setByAddingObjectsFromArray: [CCHSelectedLights moduleIdentifiers]];
    }
%end

%hook CCSModuleSettingsProvider
    - (NSArray*) userDisabledModuleIdentifiers {
        NSMutableArray *mutableArray = [%orig mutableCopy];

        for (NSString *disabledIdentifier in mutableArray) {
            for (NSString *addedIdentifier in [CCHSelectedLights moduleIdentifiers]) {
                if ([disabledIdentifier isEqual: addedIdentifier]) {
                    [mutableArray removeObject: disabledIdentifier];
                }
            }
        }

        return [mutableArray copy];
    }

    - (NSArray*) orderedUserEnabledModuleIdentifiers {
        NSMutableArray *mutableArray = [%orig mutableCopy];

        for (NSString *addedIdentifier in [CCHSelectedLights moduleIdentifiers]) {
            BOOL alreadyAdded = false;

            for (NSString *enabledIdentifier in mutableArray) {
                if ([enabledIdentifier isEqual: addedIdentifier]) {
                    alreadyAdded = true;
                    break;
                }
            }

            if (!alreadyAdded) {
                [mutableArray addObject: [addedIdentifier copy]];
            }
        }

        return [mutableArray copy];
    }
%end
