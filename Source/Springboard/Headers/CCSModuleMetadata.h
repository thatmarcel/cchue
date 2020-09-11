#import <Foundation/Foundation.h>

@interface CCSModuleMetadata: NSObject
    @property (nonatomic, copy, readonly) NSString *moduleIdentifier;
    @property (nonatomic, copy, readonly) NSSet *supportedDeviceFamilies;
    @property (nonatomic, copy, readonly) NSSet *requiredDeviceCapabilities;
    @property (nonatomic, copy, readonly) NSString *associatedBundleIdentifier;
    @property (nonatomic, copy, readonly) NSString *associatedBundleMinimumVersion;
    @property (nonatomic, readonly) unsigned long long visibilityPreference;
    @property (nonatomic, copy, readonly) NSURL *moduleBundleURL;

    + (id) _supportedDeviceFamiliesForBundleInfoDictionary:(id)arg1;
    + (id) _requiredCapabilitiesForInfoDictionary:(id)arg1;
    + (instancetype) metadataForBundleAtURL:(id)arg1;
    - (BOOL) isEqual:(id)arg1;
    - (unsigned long long) hash;
    - (id) description;
    - (instancetype) copyWithZone:(NSZone*)arg1;
    - (NSSet *) requiredDeviceCapabilities;
    - (NSString *) associatedBundleIdentifier;
    - (NSString *) moduleIdentifier;
    - (NSURL *) moduleBundleURL;
    // module identifier: com.bundle.id
    // device familes: {( 1, 2 )}
    // required device capabilities: {( )}
    // associated bundle identifier: nil
    // associated bundle minimum version: nil
    // associated bundle minimum version: nil
    // visibility preference: 0
    // module bundle url: file:///Library/ControlCenter/Bundles/BundleName.bundle
    - (id) _initWithModuleIdentifier:(NSString*)arg1 supportedDeviceFamilies:(NSSet*)arg2 requiredDeviceCapabilities:(NSSet*)arg3 associatedBundleIdentifier:(NSString*)arg4 associatedBundleMinimumVersion:(NSString*)arg5 visibilityPreference:(unsigned long long)arg6 moduleBundleURL:(id)arg7;
    - (NSSet *) supportedDeviceFamilies;
    - (NSString *) associatedBundleMinimumVersion;
    - (unsigned long long) visibilityPreference;
@end
