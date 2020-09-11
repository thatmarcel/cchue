#import "CCHSelectLightsController.h"
#import "CCHSelectLightsController+TableViewDataSource.h"
#import "CCHSelectLightsController+TableViewDelegate.h"

@implementation CCHSelectLightsController
    @synthesize tableView;
    @synthesize activityIndicatorView;
    @synthesize allLights;
    @synthesize selectedLights;

    - (void) viewDidLoad {
        [super viewDidLoad];

        UIBarButtonItem *respringItem = [[UIBarButtonItem alloc] initWithTitle: @"Respring"
                                            style: UIBarButtonItemStylePlain
                                            target: self
                                            action: @selector(respring)];
        self.navigationItem.rightBarButtonItem = respringItem;

        if (@available(iOS 13.0, *)) {
            self.view.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            self.view.backgroundColor = [UIColor whiteColor];
        }

        self.title = @"Select lights";

        [self addTableView];
        [self addActivityIndicatorView];
        [self fetchLights];
    }

    - (void) respring {
        pid_t pid;
    	const char *args[] = { "sbreload", NULL };
    	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char *const *) args, NULL);
    }

    - (void) fetchLights {
        NSString *ip = [[CCHPrefs get] objectForKey: @"ip"];
        NSString *username = [[CCHPrefs get] objectForKey: @"username"];

        if (!ip || !username || [@"" isEqual: [ip stringByReplacingOccurrencesOfString: @" " withString: @""]] || [@"" isEqual: [username stringByReplacingOccurrencesOfString: @" " withString: @""]]) {
            [CCHAlert
				showPoppingWithTitle: @"Missing IP or username"
				message: @"You have to input the username and ip address of the bridge before you can add lights to your control center"
				onViewController: self];
        }

        NSString *url = [NSString stringWithFormat: @"http://%@/api/%@/lights", ip, username];
		STHTTPRequest *req = [STHTTPRequest requestWithURLString: url];

        req.completionBlock = ^(NSDictionary *headers, NSString *body) {
            [self.activityIndicatorView stopAnimating];

            NSError* jsonDecodingError;
			NSData *resData = [body dataUsingEncoding: NSUTF8StringEncoding];
			NSDictionary* resJson = (NSDictionary*) [NSJSONSerialization JSONObjectWithData: resData options: kNilOptions error: &jsonDecodingError];
			if (jsonDecodingError != nil || !resJson || ![resJson isKindOfClass: [NSDictionary class]]) {
				[CCHAlert
					showPoppingWithTitle: @"Fetching lights failed"
					message: @"Make sure the username and ip address of the bridge are correct"
					onViewController: self];
				return;
			}

            NSMutableArray *lights = [NSMutableArray new];
            for (NSString* identifier in [resJson allKeys]) {
                NSDictionary *lightInfo = [resJson objectForKey: identifier];
                CCHLight *light = [[CCHLight alloc] init];
                light.identifier = identifier;
                light.name = [lightInfo objectForKey: @"name"];
                [lights addObject: light];
            }

            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"name" ascending: true];
            [lights sortUsingDescriptors: @[sortDescriptor]];

            self.allLights = [lights copy];

            [self.tableView reloadData];
            self.tableView.hidden = false;

            self.selectedLights = [NSKeyedUnarchiver unarchiveObjectWithData: [[CCHPrefs get] objectForKey: @"selectedlights"]];
		};

		req.errorBlock = ^(NSError *error) {
            [self.activityIndicatorView stopAnimating];

			[CCHAlert
				showPoppingWithTitle: @"Fetching lights failed"
				message: @"Make sure the ip address of the bridge is correct and check your internet connection"
				onViewController: self];
		};

		[req startAsynchronous];
    }

    - (void) addActivityIndicatorView {
        if (@available(iOS 13.0, *)) {
            self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleLarge];
        } else {
            self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        }
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false;
        [self.view addSubview: self.activityIndicatorView];
        [self.activityIndicatorView.centerXAnchor constraintEqualToAnchor: self.view.centerXAnchor constant: 0].active = YES;
        [self.activityIndicatorView.centerYAnchor constraintEqualToAnchor: self.view.centerYAnchor constant: 0].active = YES;

        [self.activityIndicatorView startAnimating];
        self.activityIndicatorView.hidesWhenStopped = true;
    }

    - (void) addTableView {
        self.tableView = [[UITableView alloc] init];
        self.tableView.translatesAutoresizingMaskIntoConstraints = false;
        [self.view addSubview: self.tableView];
        [self.tableView.topAnchor constraintEqualToAnchor: self.view.topAnchor constant: 0].active = YES;
        [self.tableView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor constant: 0].active = YES;
        [self.tableView.leftAnchor constraintEqualToAnchor: self.view.leftAnchor constant: 0].active = YES;
        [self.tableView.rightAnchor constraintEqualToAnchor: self.view.rightAnchor constant: 0].active = YES;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.hidden = true;
    }
@end
