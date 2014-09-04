
#import <FBTweak/FBTweakEnabled.h>
#import <FBTweak/FBTweaks.h>
#import <FBTweak/FBTweakInline.h>
#import <FBTweak/FBTweakInlineInternal.h>
#import <FBTweak/FBTweakEXTMetamacros.h>
#import <FBTweak/FBTweak.h>
#import <FBTweak/FBTweakStore.h>
#import <FBTweak/FBTweakCategory.h>
#import <FBTweak/FBTweakCollection.h>
#import <FBTweak/FBTweakCompilerMagic.h>

#ifndef FBTweakMacrosInternal
#define FBTweakMacrosInternal

// Base

#define _FBTweakInline(category_, collection_, name_, defaultValue_, class_, initBlock_) (^{ \
    /* store the tweak data in the binary at compile time. */ \
    __attribute__((used)) static FBTweakLiteralString category__ = category_; \
    __attribute__((used)) static FBTweakLiteralString collection__ = collection_; \
    __attribute__((used)) static FBTweakLiteralString name__ = name_; \
    __attribute__((used)) static FBTweakLiteralString className__ = @#class_; \
    __attribute__((used)) static char *encoding__ = (char *)@encode(__typeof__(defaultValue_)); \
    __attribute__((used)) static fb_tweak_entry_init_block initBlock__ = initBlock_; \
    __attribute__((used)) __attribute__((section (FBTweakSegmentName "," FBTweakSectionName))) static fb_tweak_entry entry = \
    { &category__, &collection__, &name__, &className__, &encoding__, &initBlock__}; \
    \
    /* find the registered tweak with the given identifier. */ \
    FBTweakStore *store = [FBTweakStore sharedInstance]; \
    FBTweakCategory *category = [store tweakCategoryWithName:category__]; \
    FBTweakCollection *collection = [category tweakCollectionWithName:collection__]; \
    \
    NSString *identifier = _FBTweakIdentifier(&entry); \
    class_ *__inline_tweak = (class_ *)[collection tweakWithIdentifier:identifier]; \
    if(__inline_tweak == nil) { \
        __inline_tweak = [[class_ alloc] initWithIdentifier:identifier]; \
        [collection addTweak:__inline_tweak]; \
    } \
    \
    return __inline_tweak; \
}())

#define _FBTweakInternal(category_, collection_, name_, defaultValue_, class_, initBlock_) \
        ([(_FBTweakInline(category_, collection_, name_, defaultValue_, class_, initBlock_)) currentValue])

// Bool

#define _FBTweakBool(category_, collection_, name_, defaultValue_) (^{ \
    return _FBTweakInternal(category_, collection_, name_, defaultValue_, FBBoolTweak, ^(FBBoolTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
    }); \
}())

// Double

#define _FBTweakDoubleWithoutRange(category_, collection_, name_, defaultValue_, ...) (^{ \
    return _FBTweakInternal(category_, collection_, name_, defaultValue_, FBDoubleTweak, ^(FBDoubleTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
    }); \
}())

#define _FBTweakDoubleWithRange(category_, collection_, name_, defaultValue_, minimumValue_, maximumValue_) (^{ \
    return _FBTweakInline(category_, collection_, name_, defaultValue_, FBDoubleTweak, ^(FBIntegerTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
        tweak.minimumValue = minimumValue_; \
        tweak.maximumValue = maximumValue_; \
    }); \
}())

#define _FBTweakDouble(category_, collection_, name_, defaultValue_, ...)  \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__)) \
        (_FBTweakDoubleWithoutRange(category_, collection_, name_, defaultValue_)) \
        (_FBTweakDoubleWithRange(category_, collection_, name_, defaultValue_, __VA_ARGS__))

// Integer

#define _FBTweakIntegerWithoutRange(category_, collection_, name_, defaultValue_, ...) (^{ \
    return _FBTweakInternal(category_, collection_, name_, defaultValue_, FBIntegerTweak, ^(FBIntegerTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
    }); \
}())

#define _FBTweakIntegerWithRange(category_, collection_, name_, defaultValue_, minimumValue_, maximumValue_) (^{ \
    return _FBTweakInternal(category_, collection_, name_, defaultValue_, FBIntegerTweak, ^(FBIntegerTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
        tweak.minimumValue = minimumValue_; \
        tweak.maximumValue = maximumValue_; \
    }); \
}())

#define _FBTweakInteger(category_, collection_, name_, defaultValue_, ...)  \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__)) \
        (_FBTweakIntegerWithoutRange(category_, collection_, name_, defaultValue_)) \
        (_FBTweakIntegerWithRange(category_, collection_, name_, defaultValue_, __VA_ARGS__))

// String

#define _FBTweakString(category_, collection_, name_, defaultValue_) (^{ \
    return _FBTweakInternal(category_, collection_, name_, defaultValue_, FBStringTweak, ^(FBStringTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
    }); \
}())

#define _FBTweakSelectString(category_, collection_, name_, defaultIndex_, ...) (^{ \
    return _FBTweakInternal(category_, collection_, name_, defaultIndex_, FBSelectValueTweak, ^(FBSelectValueTweak *tweak){ \
        tweak.defaultIndex = defaultIndex_; \
        /* Ok, I have no idea how to do this properly. */ \
        /* The problem is that I can't use [NSArray arrayWithObjects:__VA_ARGS__] or similar because I'm inside this block... */ \
        /* ...and everything has to be possible to capture compile time */ \
        NSString *joined = @"" #__VA_ARGS__; \
        joined = [joined stringByReplacingOccurrencesOfString:@"\",\\s+@\"" withString:@"|||" options:NSRegularExpressionSearch range:NSMakeRange(0, joined.length)]; \
        joined = [joined stringByReplacingOccurrencesOfString:@"^@\"" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, joined.length)]; \
        joined = [joined stringByReplacingOccurrencesOfString:@"\"$" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, joined.length)]; \
        tweak.strings = [joined componentsSeparatedByString:@"|||"]; \
    }); \
}())

// Generic

#define _FBTweakValues(category_, collection_, name_, defaultValue_, ...) \
((^__typeof__(defaultValue_) { \
    /* returns a correctly typed version of the current tweak value */ \
    return _Generic(defaultValue_, \
        long: FBTweakInteger(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        const long: FBTweakInteger(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        int: FBTweakInteger(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        const int: FBTweakInteger(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        BOOL: FBTweakInteger(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        const BOOL: FBTweakInteger(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        default: defaultValue_ \
    ); \
    return defaultValue_; \
})())

#define _FBTweakAction(category_, collection_, name_, defaultValue_)



#endif