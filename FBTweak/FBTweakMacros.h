
#import <FBTweak/_FBTweakMacrosInternal.h>
#import <FBTweak/_FBTweakEXTMetamacros.h>

#ifndef FBTweakMacros
#define FBTweakMacros

# if ! FB_TWEAK_ENABLED

#define FBTweakSelectString(category_, collection_, name_, defaultIndex_, ...)  metamacro_at(defaultIndex_, __VA_ARGS__)
#define FBTweakAction(...)
#define FBTweakValue(category_, collection_, name_, defaultValue_, ...) defaultValue_
#define FBTweakValueInline(category_, collection_, name_, defaultValue_, ...) nil
#define FBTweakBindValue(object_, property_, category_, collection_, name_, defaultValue_, ...) object_.property_ = defaultValue_
#define FBTweakObject(category_, collection_, name_, defaultObject_) defaultObject_
#define FBTweakObjectInline(category_, collection_, name_, defaultValue_) nil
#define FBTweakBindObject(object_, property_, category_, collection_, name_, defaultObject_) object_.property_ = defaultObject_

# else

/**
 @abstract Common parameters in these macros.
 @param category_ The category the tweak's collection is in. Must be a constant NSString.
 @param collection_ The collection the tweak goes in. Must be a constant NSString.
 @param name_ The name of the tweak. Must be a constant NSString.
 @param default_ The default value of the tweak. If the user doesn't configure
 a custom value or the build is a release build, then the default value is used.
 The default value supports a variety of types, but all must be constant literals.
 Supported types include: BOOL, NSInteger, NSUInteger, CGFloat, NSString *, char *.
 @param min_ Optional, for numbers. The minimum value. Same restrictions as default.
 @param max_ Optional, for numbers. The maximum value. Same restrictions as default.
 */

/**
 @abstract Loads the value of a tweak inline.
 @param defaultIndex_
 @param ... A comma separated list of all the strings you want to choose between
 @discussion To use a tweak, use this instead of the constant value you otherwise would.
 To use the same tweak in two places, define a C function that returns FBTweakValue.
 @return One of the strings passed
 
    NSString *string = FBTweakSelectString(@"Category", @"Collection", @"Name", 1, @"Skeumorphic", @"Flat");
    NSLog(@"Selected value: %@", string); // Defaults to "Flat"
 
 */
#define FBTweakSelectString(category_, collection_, name_, defaultIndex_, ...) \
        _FBTweakSelectString(category_, collection_, name_, defaultIndex_, __VA_ARGS__)

/**
 @abstract Performs an action on tweak selection.
 @param ... The last parameter is a block containing the action to run.
 @discussion The action does not have access to local state. It might be necessary to
 access global state in the block to perform actions scoped to a specific class.
 */
#define FBTweakAction(category_, collection_, name_, ...) \
        _FBTweakAction(category_, collection_, name_, __VA_ARGS__)

/**
 @abstract Loads the value of a tweak inline.
 @discussion To use a tweak, use this instead of the constant value you otherwise would.
 To use the same tweak in two places, define a C function that returns FBTweakValue.
 @return The current value of the tweak, or the default value if none is set.
 
    You can optionally add 2 more parameters specifying a 'minimumValue' and a 'maximumValue'
    <type> var = FBTweakSelectString(@"Category", @"Collection", @"Name", <defaultValue>);
    <type> var = FBTweakSelectString(@"Category", @"Collection", @"Name", <defaultValue>, <minimumValue>, <maximumValue>);
 
    BOOL showUnicorns = FBTweakSelectString(@"Category", @"Collection", @"Enable unicorns", YES);
    NSInteger unicorns = FBTweakSelectString(@"Category", @"Collection", @"Number of unicorns", 10, 1, 100);
    double size = FBTweakSelectString(@"Category", @"Collection", @"Size of unicorns", 19.0, 10.0, 1000.0);
 */
#define FBTweakValue(category_, collection_, name_, default_, ...) \
        _FBTweakValue(category_, collection_, name_, default_, __VA_ARGS__)

#define FBTweakValueInline(category_, collection_, name_, defaultValue_, ...) \
        _FBTweakValueInline(category_, collection_, name_, defaultValue_, __VA_ARGS__)
/**
 @abstract Binds an object property to a tweak.
 @param object_ The object to bind to.
 @param property_ The property to bind.
 @discussion As long as the object is alive, the property will be updated to match the tweak.
 */
#define FBTweakBindValue(object_, property_, category_, collection_, name_, default_, ...) \
        _FBTweakBindValue(object_, property_, category_, collection_, name_, default_, __VA_ARGS__)

/**
 @abstract Loads the value of a tweak inline.
 @discussion To use a tweak, use this instead of the constant value you otherwise would.
 To use the same tweak in two places, define a C function that returns FBTweakValue.
 @return The current value of the tweak, or the default value if none is set.
 */
#define FBTweakObject(category_, collection_, name_, default_) \
        _FBTweakObject(category_, collection_, name_, default_)

#define FBTweakObjectInline(category_, collection_, name_, defaultValue_) \
        _FBTweakObjectInline(category_, collection_, name_, defaultValue_)

/**
 @abstract Binds an object property to a tweak.
 @param object_ The object to bind to.
 @param property_ The property to bind.
 @discussion As long as the object is alive, the property will be updated to match the tweak.
 */
#define FBTweakBindObject(object_, property_, category_, collection_, name_, default_) \
        _FBTweakBindObject(object_, property_, category_, collection_, name_, default_)

# endif

#endif