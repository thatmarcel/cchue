#import "CCHSelectLightsController+TableViewDataSource.h"

@implementation CCHSelectLightsController (TableViewDelegate)
    - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        CCHLight *light = (CCHLight*) self.allLights[indexPath.row];

        NSMutableArray *mutableLights = [self.selectedLights mutableCopy];

        CCHLight *lightToRemove;

        for (CCHLight *selectedLight in mutableLights) {
            if ([selectedLight.name isEqual: light.name]) {
                lightToRemove = selectedLight;
            }
        }

        if (lightToRemove) {
            [mutableLights removeObject: lightToRemove];
        } else {
            [mutableLights addObject: [light duplicate]];
        }

        self.selectedLights = mutableLights;

        [[CCHPrefs get] setObject: [NSKeyedArchiver archivedDataWithRootObject: self.selectedLights] forKey: @"selectedlights"];

        [self.tableView reloadData];
    }
@end
