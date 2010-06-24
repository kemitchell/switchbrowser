#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// set up shorthands dictionary
	NSArray *keys = [NSArray arrayWithObjects:
					 @"safari",
					 @"firefox",
					 @"opera",
					 @"webkit",
					 @"chrome",
					 @"camino",
					 @"flock",
					 nil];
	NSArray *objects = [NSArray arrayWithObjects:
						@"com.apple.safari",
						@"org.mozilla.firefox",
						@"com.operasoftware.opera",
						@"org.webkit.nightly.webKit",
						@"com.google.chrome",
						@"org.mozilla.camino",
						@"com.flock.flock",
						nil];
	NSDictionary *shorthands = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	// find available browser applications
	CFStringRef https = CFSTR("HTTPS");
	CFArrayRef availableBrowsers = LSCopyAllHandlersForURLScheme(https);
	CFIndex availableBrowserCount = CFArrayGetCount(availableBrowsers);
	
	// find the current default browser
	NSString *currentBrowserBundleIdentifier = (NSString*)LSCopyDefaultHandlerForURLScheme(https);
	
	int returnCode = EXIT_SUCCESS;
	
	if(argc < 2) {
		// no arguments: show usage and list available browsers
		printf("Usage: switchbrowser <bundle identifier or shorthand>\n");
		printf("\n");
		printf("%-45.45s    %s\n", "Bundle Identifier", "Shorthand");
		printf("----------------------------------------------------------\n");
		NSUInteger i;
		for (i = 0; i < availableBrowserCount; i++) {
			NSString *browserBundleIdentifier = (NSString*)CFArrayGetValueAtIndex(availableBrowsers, i);
			// note current default browser
			if([browserBundleIdentifier caseInsensitiveCompare:currentBrowserBundleIdentifier] == NSOrderedSame){
				printf("*%-45.45s", [browserBundleIdentifier UTF8String]);
			}else{
				printf(" %-45.45s", [browserBundleIdentifier UTF8String]);
			}
			// show shorthand if available
			NSString *shorthand = (NSString*)[[shorthands allKeysForObject:[browserBundleIdentifier lowercaseString]] lastObject];
			if(shorthand){
				printf("   %s", [shorthand UTF8String]);
			}
			printf("\n");
		}
	} else {
		// set default browser
		NSString *newBrowserBundleIdentifier = [[[NSString alloc] initWithUTF8String:argv[1]] lowercaseString];
		[newBrowserBundleIdentifier autorelease];
		NSString *longhand = [shorthands objectForKey: newBrowserBundleIdentifier];
		if(longhand){
			newBrowserBundleIdentifier = longhand;
		}
		
		// do nothing if already default
		if([newBrowserBundleIdentifier caseInsensitiveCompare:currentBrowserBundleIdentifier] == NSOrderedSame){
			printf("Default browser is already %s\n", [newBrowserBundleIdentifier UTF8String]);
		} else {
			NSUInteger i;
			// check that the given app is capable of serving as a browser
			BOOL amongAvailableBrowsers = FALSE;
			for (i = 0; i < availableBrowserCount; i++) {
				NSString *knownBrowserBundleIdentifier = (NSString*)CFArrayGetValueAtIndex(availableBrowsers, i);
				if ([knownBrowserBundleIdentifier caseInsensitiveCompare:newBrowserBundleIdentifier] == NSOrderedSame) {
					amongAvailableBrowsers = TRUE;
					break;
				}
			}
			// set the given browser to the default
			if(amongAvailableBrowsers){
				LSSetDefaultHandlerForURLScheme((CFStringRef)@"http", (CFStringRef)newBrowserBundleIdentifier);
				LSSetDefaultHandlerForURLScheme((CFStringRef)@"https", (CFStringRef)newBrowserBundleIdentifier);
				printf("HTTP/HTTPS browser set to: %s\n", [newBrowserBundleIdentifier UTF8String]);
			} else {
				printf("No such browser available: %s\n", [newBrowserBundleIdentifier UTF8String]);
				returnCode = EXIT_FAILURE;
			}
		}
	}
	
    [pool drain];
    return returnCode;
}