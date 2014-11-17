/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBTweakEnabled.h"
#import "FBAllTweaks.h"
#import "FBTweakStore.h"
#import "FBTweakCategory.h"
#import "FBTweakCollection.h"
#import "_FBTweakBindObserver.h"
#import "_FBTweakEXTMetamacros.h"
#import "_FBTweakCompilerMagic.h"

#ifndef FBTweakMacrosInternal
#define FBTweakMacrosInternal

// Base

#define _FBTweakInline(category_, collection_, name_, defaultValue_, class_, initBlock_) ({\
    /* store the tweak data in the binary at compile time. */ \
    __attribute__((used)) static FBTweakLiteralString category__ = category_; \
    __attribute__((used)) static FBTweakLiteralString collection__ = collection_; \
    __attribute__((used)) static FBTweakLiteralString name__ = name_; \
    __attribute__((used)) static FBTweakLiteralString className__ = @#class_; \
    __attribute__((used)) static char *encoding__ = NULL; \
    __attribute__((used)) static fb_tweak_entry_init_block initBlock__ = initBlock_; \
    __attribute__((used)) __attribute__((section (FBTweakSegmentName "," FBTweakSectionName))) static fb_tweak_entry entry = \
    { &category__, &collection__, &name__, &className__, &encoding__, &initBlock__}; \
    \
    /* find the registered tweak with the given identifier. */ \
    FBTweakStore *store = [FBTweakStore sharedInstance]; \
    FBTweakCategory *category = [store tweakCategoryWithName:category__]; \
    FBTweakCollection *collection = [category tweakCollectionWithName:collection__]; \
    \
    NSString *identifier = _FBTweakIdentifierFromEntry(&entry); \
    class_ *__inline_tweak = (class_ *)[collection tweakWithIdentifier:identifier]; \
    if(__inline_tweak == nil) { \
        __inline_tweak = [[class_ alloc] initWithIdentifier:identifier]; \
        __inline_tweak.name = name_; \
        initBlock_(__inline_tweak); \
        [collection addTweak:__inline_tweak]; \
        [__inline_tweak load]; \
    } \
    if(![__inline_tweak isKindOfClass:[class_ class]]) { \
        NSAssert(FALSE, @"You have defined '%@ > %@ > %@' twice – with different types. Prev type: '%@'. This type: '%@'.", category_, collection_, name_, NSStringFromClass([__inline_tweak class]), NSStringFromClass([class_ class])); \
    } \
    __inline_tweak; \
})

// Actions

#define _FBTweakAction(category_, collection_, name_, ...) \
    _FBTweakActionInternal(category_, collection_, name_, FBActionTweak, __COUNTER__, __VA_ARGS__)

#define _FBTweakActionInternal(category_, collection_, name_, className_, suffix_, ...) \
    /* store the tweak data in the binary at compile time. */ \
    __attribute__((used)) static FBTweakLiteralString metamacro_concat(__fb_tweak_action_category_, suffix_) = category_; \
    __attribute__((used)) static FBTweakLiteralString metamacro_concat(__fb_tweak_action_collection_, suffix_) = collection_; \
    __attribute__((used)) static FBTweakLiteralString metamacro_concat(__fb_tweak_action_name_, suffix_) = name_; \
    __attribute__((used)) static FBTweakLiteralString metamacro_concat(__fb_tweak_action_className_, suffix_) = @#className_; \
    __attribute__((used)) static char *metamacro_concat(__fb_tweak_action_encoding_, suffix_) = NULL; \
    __attribute__((used)) static dispatch_block_t metamacro_concat(__fb_tweak_action_block_, suffix_) = __VA_ARGS__; \
    __attribute__((used)) static fb_tweak_entry_init_block metamacro_concat(__fb_tweak_init_block_, suffix_) = ^(FBActionTweak *tweak) { \
        tweak.action = metamacro_concat(__fb_tweak_action_block_, suffix_); \
    }; \
    __attribute__((used)) __attribute__((section (FBTweakSegmentName "," FBTweakSectionName))) static fb_tweak_entry metamacro_concat(__fb_tweak_action_entry_, suffix_) = { \
        &metamacro_concat(__fb_tweak_action_category_, suffix_), \
        &metamacro_concat(__fb_tweak_action_collection_, suffix_), \
        &metamacro_concat(__fb_tweak_action_name_, suffix_), \
        &metamacro_concat(__fb_tweak_action_className_, suffix_), \
        &metamacro_concat(__fb_tweak_action_encoding_, suffix_), \
        &metamacro_concat(__fb_tweak_init_block_, suffix_), \
    }; \


// Bool

#define _FBTweakBoolInline(category_, collection_, name_, defaultValue_) (^{ \
    return _FBTweakInline(category_, collection_, name_, defaultValue_, FBBoolTweak, ^(FBBoolTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
    }); \
}())

#define _FBTweakBool(category_, collection_, name_, defaultValue_) \
    [_FBTweakBoolInline(category_, collection_, name_, defaultValue_) currentValue]

// Double

#define _FBTweakDoubleWithoutRange(category_, collection_, name_, defaultValue_, ...) (^{ \
    return _FBTweakInline(category_, collection_, name_, defaultValue_, FBDoubleTweak, ^(FBDoubleTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
    }); \
}())

#define _FBTweakDoubleWithRange(category_, collection_, name_, defaultValue_, minimumValue_, maximumValue_) (^{ \
    return _FBTweakInline(category_, collection_, name_, defaultValue_, FBDoubleTweak, ^(FBDoubleTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
        tweak.minimumValue = minimumValue_; \
        tweak.maximumValue = maximumValue_; \
    }); \
}())

#define _FBTweakDoubleInline(category_, collection_, name_, defaultValue_, ...)  \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__)) \
        (_FBTweakDoubleWithoutRange(category_, collection_, name_, defaultValue_)) \
        (_FBTweakDoubleWithRange(category_, collection_, name_, defaultValue_, __VA_ARGS__))

#define _FBTweakDouble(category_, collection_, name_, defaultValue_, ...)  \
    [_FBTweakDoubleInline(category_, collection_, name_, defaultValue_, __VA_ARGS__) currentValue]

// Integer

#define _FBTweakIntegerWithoutRange(category_, collection_, name_, defaultValue_, ...) (^{ \
    return _FBTweakInline(category_, collection_, name_, defaultValue_, FBIntegerTweak, ^(FBIntegerTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
    }); \
}())

#define _FBTweakIntegerWithRange(category_, collection_, name_, defaultValue_, minimumValue_, maximumValue_) (^{ \
    return _FBTweakInline(category_, collection_, name_, defaultValue_, FBIntegerTweak, ^(FBIntegerTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
        tweak.minimumValue = minimumValue_; \
        tweak.maximumValue = maximumValue_; \
    }); \
}())

#define _FBTweakIntegerInline(category_, collection_, name_, defaultValue_, ...)  \
    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__)) \
        (_FBTweakIntegerWithoutRange(category_, collection_, name_, defaultValue_)) \
        (_FBTweakIntegerWithRange(category_, collection_, name_, defaultValue_, __VA_ARGS__))

#define _FBTweakInteger(category_, collection_, name_, defaultValue_, ...)  \
    [_FBTweakIntegerInline(category_, collection_, name_, defaultValue_, __VA_ARGS__) currentValue]

// Object

#define _FBTweakObjectInline(category_, collection_, name_, defaultValue_) (^{ \
    return _FBTweakInline(category_, collection_, name_, defaultValue_, FBObjectTweak, ^(FBObjectTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
    }); \
}())

#define _FBTweakObject(category_, collection_, name_, defaultValue_) \
    ((__typeof__(defaultValue_))[_FBTweakObjectInline(category_, collection_, name_, defaultValue_) currentValue])

#define _FBTweakBindObject(object_, property_, category_, collection_, name_, defaultValue_) ((^{ \
    FBObjectTweak *bindTweak_ = _FBTweakObjectInline(category_, collection_, name_, defaultValue_); \
    object_.property_ = (__typeof__(defaultValue_))[bindTweak_ currentValue]; \
    _FBTweakBindObserver *observer__ = [[_FBTweakBindObserver alloc] initWithTweak:bindTweak_ block:^(id object__) { \
        __typeof__(object_) object___ = object__; \
        object___.property_ = (__typeof__(defaultValue_))[bindTweak_ currentValue]; \
    }]; \
    [observer__ attachToObject:object_]; \
})())

// String

#define _FBTweakStringInline(category_, collection_, name_, defaultValue_) (^{ \
    return _FBTweakInline(category_, collection_, name_, defaultValue_, FBObjectTweak, ^(FBObjectTweak *tweak){ \
        tweak.defaultValue = defaultValue_; \
    }); \
}())

#define _FBTweakString(category_, collection_, name_, defaultValue_) \
    [_FBTweakStringInline(category_, collection_, name_, defaultValue_) currentValue]

#define _FBTweakSelectStringInline(category_, collection_, name_, defaultIndex_, ...) (^{ \
    return _FBTweakInline(category_, collection_, name_, defaultIndex_, FBSelectValueTweak, ^(FBSelectValueTweak *tweak){ \
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

#define _FBTweakSelectString(category_, collection_, name_, defaultIndex_, ...) \
    [_FBTweakSelectStringInline(category_, collection_, name_, defaultIndex_, __VA_ARGS__) currentValue]


// Generic

#define _FBTweakValueInline(category_, collection_, name_, defaultValue_, ...) \
    _Generic(defaultValue_, \
        \
        /* int */ \
        long: _FBTweakIntegerInline(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        const long: _FBTweakIntegerInline(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        int: _FBTweakIntegerInline(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        const int: _FBTweakIntegerInline(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        unsigned int: _FBTweakIntegerInline(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        const unsigned int: _FBTweakIntegerInline(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        \
        /* double */ \
        float: _FBTweakDoubleInline(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        const float: _FBTweakDoubleInline(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        double: _FBTweakDoubleInline(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        const double: _FBTweakDoubleInline(category_, collection_, name_, defaultValue_, __VA_ARGS__), \
        \
        /* bool */ \
        BOOL: _FBTweakBoolInline(category_, collection_, name_, defaultValue_), \
        const BOOL: _FBTweakBoolInline(category_, collection_, name_, defaultValue_), \
        \
        default: nil \
    )

#define _FBTweakValue(category_, collection_, name_, defaultValue_, ...) (^{ \
    return (__typeof__(defaultValue_))[_FBTweakValueInline(category_, collection_, name_, defaultValue_, __VA_ARGS__) currentValue]; \
}())

#define _FBTweakBindValue(object_, property_, category_, collection_, name_, defaultValue_, ...) ((^{ \
    __typeof__(_FBTweakValueInline(category_, collection_, name_, defaultValue_, __VA_ARGS__)) bindTweak_ = _FBTweakValueInline(category_, collection_, name_, defaultValue_, __VA_ARGS__); \
    object_.property_ = (__typeof__(defaultValue_))[bindTweak_ currentValue]; \
    _FBTweakBindObserver *observer__ = [[_FBTweakBindObserver alloc] initWithTweak:bindTweak_ block:^(id object__) { \
        __typeof__(object_) object___ = object__; \
        object___.property_ = (__typeof__(defaultValue_))[bindTweak_ currentValue]; \
    }]; \
    [observer__ attachToObject:object_]; \
})())

#define _FBTweakGet(category_, collection_, name_) ((^{ \
    NSString *identifier = _FBTweakIdentifier(category_, collection_, name_); \
    FBTweakStore *store = [FBTweakStore sharedInstance]; \
    FBTweakCategory *category = [store tweakCategoryWithName:category_]; \
    FBTweakCollection *collection = [category tweakCollectionWithName:collection_]; \
    FBTweak *tweak = [collection tweakWithIdentifier:identifier]; \
    return (id)tweak; \
})())

#define _FBTweakRead(category_, collection_, name_, ...) ((^{ \
    NSString *identifier = _FBTweakIdentifier(category_, collection_, name_); \
    FBTweakStore *store = [FBTweakStore sharedInstance]; \
    FBTweakCategory *category = [store tweakCategoryWithName:category_]; \
    FBTweakCollection *collection = [category tweakCollectionWithName:collection_]; \
    FBTweak *tweak_ = [collection tweakWithIdentifier:identifier]; \
    void (^block_)(id tweak) = __VA_ARGS__; \
    _FBTweakBindObserver *observer = [[_FBTweakBindObserver alloc] initWithTweak:tweak_ block:^(id object__) { \
        block_(tweak_); \
    }]; \
    block_(tweak_); \
    [observer attachToObject:self]; \
})())

#endif
