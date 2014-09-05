
#import <FBTweak/_FBTweakMacrosInternal.h>
#import <FBTweak/_FBTweakEXTMetamacros.h>

#ifndef FBTweakMacros
#define FBTweakMacros

# if ! FB_TWEAK_ENABLED

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

#define FBTweakBool(category_, collection_, name_, defaultValue_) defaultValue_
#define FBTweakDouble(category_, collection_, name_, defaultValue_, ...) defaultValue_
#define FBTweakInteger(category_, collection_, name_, defaultValue_, ...) defaultValue_
#define FBTweakString(category_, collection_, name_, defaultValue_) defaultValue_
#define FBTweakSelectString(category_, collection_, name_, defaultIndex_, ...)  metamacro_at(defaultIndex_, __VA_ARGS__)
#define FBTweakValues(category_, collection_, name_, defaultValue_, ...) defaultValue_
#define FBTweakAction(...)
#define FBTweakBind(...)

# else

#define FBTweakBool(category_, collection_, name_, defaultValue_) \
        _FBTweakBool(category_, collection_, name_, defaultValue_)

#define FBTweakDouble(category_, collection_, name_, defaultValue_, ...) \
        _FBTweakDouble(category_, collection_, name_, defaultValue_, __VA_ARGS__)

#define FBTweakInteger(category_, collection_, name_, defaultValue_, ...) \
        _FBTweakInteger(category_, collection_, name_, defaultValue_, __VA_ARGS__)

#define FBTweakString(category_, collection_, name_, defaultValue_) \
        _FBTweakString(category_, collection_, name_, defaultValue_) 

#define FBTweakSelectString(category_, collection_, name_, defaultIndex_, ...) \
        _FBTweakSelectString(category_, collection_, name_, defaultIndex_, __VA_ARGS__)

#define FBTweakValue(category_, collection_, name_, defaultValue_, ...) \
        _FBTweakValue(category_, collection_, name_, defaultValue_, __VA_ARGS__)

#define FBTweakAction(category_, collection_, name_, action_) \
        _FBTweakAction(category_, collection_, name_, action_)

#define FBTweakBind(object_, property_, category_, collection_, name_, defaultValue_, ...) \
        _FBTweakBind(object_, property_, category_, collection_, name_, defaultValue_, __VA_ARGS__)

#define FBTweakObject(category_, collection_, name_, defaultValue_) \
        _FBTweakObject(category_, collection_, name_, defaultValue_)

# endif

#endif