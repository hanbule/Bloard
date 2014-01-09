#define PREFSPLIST @"/var/mobile/Library/Preferences/com.gnos.bloard.plist"

@interface GNBloard : NSObject
- (void)createDefaultPreferences;
- (BOOL)isEnabled;
@end

@implementation GNBloard

- (void)createDefaultPreferences {
    NSDictionary *d = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:YES],nil] forKeys:[NSArray arrayWithObjects:@"enabled",nil]];
    [d writeToFile:PREFSPLIST atomically:YES];
    [d release];
}

- (BOOL)isEnabled {
    
    NSDictionary *prefs = nil;
    prefs = [[NSDictionary alloc] initWithContentsOfFile:PREFSPLIST]; // Load the plist
    //Is ENABLED not existent?
    if (prefs == nil) { // create new plist
        [self createDefaultPreferences];
        // Load the plist again
        prefs = [[NSDictionary alloc] initWithContentsOfFile:PREFSPLIST];
    }
    //get the value of enabled
    BOOL value = [[prefs objectForKey:@"enabled"] boolValue];
    [prefs release];
    return value;
}


@end


%hook UIKBRenderConfig

- (BOOL) lightKeyboard {
    GNBloard *prefs =  [[GNBloard alloc] init];
    if ([prefs isEnabled]) {
        [prefs release];
        return NO;
    
    } else {
        [prefs release];
         return %orig;
    }
}

%end

%hook UITextInputTraits

- (int)keyboardAppearance {
    GNBloard *prefs =  [[GNBloard alloc] init];
    if ([prefs isEnabled]) {
        [prefs release];
        return 1;
        
    } else {
        [prefs release];
        return %orig;
    }
}

%end

