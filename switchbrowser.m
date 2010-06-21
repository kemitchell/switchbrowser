#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	CFStringRef https = CFSTR("HTTPS");
	CFArrayRef availableBrowsers = LSCopyAllHandlersForURLScheme(https);
	CFIndex availableBrowserCount = CFArrayGetCount(availableBrowsers);
	
	NSString *currentBrowser = (NSString*)LSCopyDefaultHandlerForURLScheme(https);
	
	int returnCode = EXIT_SUCCESS;
	
	if(argc < 2) {
		// list available browsers
		printf("Available Browsers:\n");
		NSUInteger i;
		for (i = 0; i < availableBrowserCount; i++) {
			NSString *browser = (NSString*)CFArrayGetValueAtIndex(availableBrowsers, i);
			// note current browser
			if([browser isEqualToString:currentBrowser]){
				printf(" * %s (current)\n", [browser UTF8String]);
			}else{
				printf("   %s\n", [browser UTF8String]);
			}
		}
	} else {
		// set default browser
		NSString *newBrowser = [[NSString alloc] initWithUTF8String:argv[1]];
		// do nothing if already default
		if([newBrowser isEqualToString:currentBrowser]){
			printf("Default browser is already %s\n", [newBrowser UTF8String]);
		} else {
			NSUInteger i;
			// check that the given app is capable of serving as a browser
			BOOL inList = FALSE;
			for (i = 0; i < availableBrowserCount; i++) {
				NSString *knownBrowser = (NSString*)CFArrayGetValueAtIndex(availableBrowsers, i);
				if ([knownBrowser isEqualToString:newBrowser]) {
					inList = TRUE;
					break;
				}
			}
			// set the given browser to the default
			if(inList){
				LSSetDefaultHandlerForURLScheme((CFStringRef)@"http", (CFStringRef)newBrowser);
				LSSetDefaultHandlerForURLScheme((CFStringRef)@"https", (CFStringRef)newBrowser);
				printf("HTTP/HTTPS browser set to: %s\n", [newBrowser UTF8String]);
			} else {
				printf("No such browser available: %s\n", [newBrowser UTF8String]);
				returnCode = EXIT_FAILURE;
			}
		}
	}
	
    [pool drain];
    return returnCode;
}