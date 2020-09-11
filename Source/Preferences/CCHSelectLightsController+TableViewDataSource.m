#import "CCHSelectLightsController+TableViewDataSource.h"

@implementation CCHSelectLightsController (TableViewDataSource)
    - (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        if ([self.allLights count] < 1) {
            return 0;
        }
        return [self.allLights count];
    }

    - (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"CCHLightTableViewCell"];

        CCHLight *light = (CCHLight*) self.allLights[indexPath.row];

        cell.textLabel.text = light.name;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.accessoryType = UITableViewCellAccessoryNone;

        for (CCHLight *selectedLight in self.selectedLights) {
            if ([selectedLight.name isEqual: light.name]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }

        return cell;
    }

    - (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
    }
@end
