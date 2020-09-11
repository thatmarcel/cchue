#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>

#import "../Helpers/STHTTPRequest.h"
#import "../Helpers/CCHPrefs.h"
#import "../Helpers/CCHAlert.h"

#import "CCHSelectLightsController.h"

@interface CCHPrefsController : HBRootListController {
    UITableView * _table;
}
@end
