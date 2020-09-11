#import "CCHPrefsController.h"

@implementation CCHPrefsController
	+ (nullable NSString *) hb_specifierPlist {
		return @"Root";
	}

	- (instancetype) init {
        self = [super init];

		if (self) {
        	UIBarButtonItem *respringItem = [[UIBarButtonItem alloc] initWithTitle: @"Respring"
											 	style: UIBarButtonItemStylePlain
												target: self
												action: @selector(respring)];
			self.navigationItem.rightBarButtonItem = respringItem;
    	}

        return self;
    }

    - (void) respring {
        pid_t pid;
    	const char *args[] = { "sbreload", NULL };
    	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char *const *) args, NULL);
    }

	- (void) selectLights {
		NSString *ip = [[CCHPrefs get] objectForKey: @"ip"];
		NSString *username = [[CCHPrefs get] objectForKey: @"username"];

		NSLog(@"CCHue IP:%@Username:%@", ip, username);

		if (!ip || [@"" isEqual: [ip stringByReplacingOccurrencesOfString: @" " withString: @""]]) {
			[CCHAlert
				showWithTitle: @"Missing IP"
				message: @"You have to input the ip address of the bridge before you can add lights to your control center"
				onViewController: self];
			return;
		}

		if (!username || [@"" isEqual: [username stringByReplacingOccurrencesOfString: @" " withString: @""]]) {
			[CCHAlert
				showWithTitle: @"Missing username"
				message: @"You have to generate a username before you can add lights to your control center"
				onViewController: self];
			return;
		}

		CCHSelectLightsController *controller = [[CCHSelectLightsController alloc] init];
		[self.navigationController pushViewController: controller animated: true];
	}

	- (void) generateUsername {
		NSString *ip = [[CCHPrefs get] objectForKey: @"ip"];

		if (!ip) {
			[CCHAlert
				showWithTitle: @"Missing IP"
				message: @"You have to input the ip address of the bridge before you can generate a username"
				onViewController: self];
			return;
		}

		NSString *url = [NSString stringWithFormat: @"http://%@/api", ip];
		STHTTPRequest *req = [STHTTPRequest requestWithURLString: url];

		NSDictionary *reqData = @{
			@"devicetype": [NSString stringWithFormat: @"CCHue#%@", [[UIDevice currentDevice].name
																		stringByAddingPercentEncodingWithAllowedCharacters:
																			[NSCharacterSet URLQueryAllowedCharacterSet]]]
		};

		NSError *jsonEncodingError = nil;
		NSData *reqJson = [NSJSONSerialization dataWithJSONObject: reqData
                                                   options: kNilOptions
                                                     error: &jsonEncodingError];

		[req setHeaderWithName: @"content-type" value: @"application/json; charset=utf-8"];

		req.rawPOSTData = reqJson;

		req.completionBlock = ^(NSDictionary *headers, NSString *body) {
			NSError* jsonDecodingError;
			NSData *resData = [body dataUsingEncoding: NSUTF8StringEncoding];
			NSArray* resJson = (NSArray*) [NSJSONSerialization JSONObjectWithData: resData options: kNilOptions error: &jsonDecodingError];
			if (jsonDecodingError != nil || [resJson count] < 1 || ![resJson.firstObject objectForKey: @"success"]) {
				[CCHAlert
					showWithTitle: @"Username generation failed"
					message: @"Make sure you pressed the link button on top of the bridge"
					onViewController: self];
				return;
			}

			NSString *username = [(NSDictionary*) [resJson.firstObject objectForKey: @"success"] objectForKey: @"username"];

			[[CCHPrefs get] setObject: username forKey: @"username"];

			[self reload];

			[CCHAlert
				showWithTitle: @"Username generation succeeded"
				message: @"A username was successfully generated. You can now add lights to the control center."
				onViewController: self];
		};

		req.errorBlock = ^(NSError *error) {
			[CCHAlert
				showWithTitle: @"Username generation failed"
				message: @"Make sure you typed in the correct ip address of the bridge"
				onViewController: self];
		};

		[req startAsynchronous];
	}
@end
