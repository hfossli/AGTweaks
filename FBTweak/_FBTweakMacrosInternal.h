/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <FBTweak/FBTweakEnabled.h>
#import <FBTweak/FBTweaks.h>
#import <FBTweak/FBTweak.h>
#import <FBTweak/FBTweakBindObserver.h>
#import <FBTweak/FBTweakStore.h>
#import <FBTweak/FBTweakCategory.h>
#import <FBTweak/FBTweakCollection.h>
#import <FBTweak/_FBTweakEXTMetamacros.h>
#import <FBTweak/_FBTweakCompilerMagic.h>

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
    NSString *identifier = _FBTweakIdentifier(&entry); \
    class_ *__inline_tweak = (class_ *)[collection tweakWithIdentifier:identifier]; \
    if(__inline_tweak == nil) { \
        __inline_tweak = [[class_ alloc] initWithIdentifier:identifier]; \
        [collection addTweak:__inline_tweak]; \
    } \
    NSAssert([__inline_tweak isKindOfClass:[class_ class]], @"You have defined '%@ > %@ > %@' twice – with different types.", category_, collection_, name_); \
    \
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
    FBTweakBindObserver *observer__ = [[FBTweakBindObserver alloc] initWithTweak:bindTweak_ block:^(id object__) { \
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
    return [_FBTweakValueInline(category_, collection_, name_, defaultValue_, __VA_ARGS__) currentValue]; \
}())

#define _FBTweakBindValue(object_, property_, category_, collection_, name_, defaultValue_, ...) ((^{ \
    FBTweak *bindTweak_ = _FBTweakValueInline(category_, collection_, name_, defaultValue_, __VA_ARGS__); \
    object_.property_ = _FBTweakValue(category_, collection_, name_, defaultValue_, __VA_ARGS__); \
    FBTweakBindObserver *observer__ = [[FBTweakBindObserver alloc] initWithTweak:bindTweak_ block:^(id object__) { \
        __typeof__(object_) object___ = object__; \
        object___.property_ = _FBTweakValue(category_, collection_, name_, defaultValue_, __VA_ARGS__); \
    }]; \
    [observer__ attachToObject:object_]; \
})())

#endif


///**
// Copyright (c) 2014-present, Facebook, Inc.
// All rights reserved.
// 
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree. An additional grant
// of patent rights can be found in the PATENTS file in the same directory.
// */
//
//#import "FBTweakEnabled.h"
//#import "FBTweak.h"
//#import "FBTweakStore.h"
//#import "FBTweakCategory.h"
//#import "FBTweakCollection.h"
//#import "FBTweakBindObserver.h"
//
//#if !FB_TWEAK_ENABLED
//
//#define __FBTweakDefault(default, ...) default
//#define _FBTweakInline(category_, collection_, name_, ...) nil
//#define _FBTweakValue(category_, collection_, name_, ...) (__FBTweakDefault(__VA_ARGS__, _))
//#define _FBTweakBind(object_, property_, category_, collection_, name_, ...) (object_.property_ = __FBTweakDefault(__VA_ARGS__, _))
//#define _FBTweakAction(category_, collection_, name_, ...)
//
//#else
//
//#ifdef __cplusplus
//extern "C" {
//#endif
//
//#define FBTweakSegmentName "__DATA"
//#define FBTweakSectionName "FBTweak"
//
//#define FBTweakEncodingAction "__ACTION__"
//
//typedef __unsafe_unretained NSString *FBTweakLiteralString;
//  
//typedef struct {
//  FBTweakLiteralString *category;
//  FBTweakLiteralString *collection;
//  FBTweakLiteralString *name;
//  void *value;
//  void *min;
//  void *max;
//  char **encoding;
//} fb_tweak_entry;
//
//extern NSString *_FBTweakIdentifier(fb_tweak_entry *entry);
//  
//#if __has_feature(objc_arc)
//#define _FBTweakRelease(x)
//#else
//#define _FBTweakRelease(x) [x release]
//#endif
//  
//#define __FBTweakConcat_(X, Y) X ## Y
//#define __FBTweakConcat(X, Y) __FBTweakConcat_(X, Y)
//
//#define __FBTweakIndex(_1, _2, _3, value, ...) value
//#define __FBTweakIndexCount(...) __FBTweakIndex(__VA_ARGS__, 3, 2, 1)
//  
//#define __FBTweakHasRange1(__withoutRange, __withRange, ...) __withoutRange
//#define __FBTweakHasRange2(__withoutRange, __withRange, ...) __FBTweakInvalidNumberOfArgumentsPassed
//#define __FBTweakHasRange3(__withoutRange, __withRange, ...) __withRange
//#define _FBTweakHasRange(__withoutRange, __withRange, ...) __FBTweakConcat(__FBTweakHasRange, __FBTweakIndexCount(__VA_ARGS__))(__withoutRange, __withRange)
//  
//#define _FBTweakInlineWithoutRange(category_, collection_, name_, default_) \
//((^{ \
//  return _FBTweakInlineWithRangeInternal(category_, collection_, name_, default_, NULL, NULL); \
//})())
//#define _FBTweakInlineWithRange(category_, collection_, name_, default_, min_, max_) \
//((^{ \
//  __attribute__((used)) static __typeof__(default_) min__ = (__typeof__(default_))min_; \
//  __attribute__((used)) static __typeof__(default_) max__ = (__typeof__(default_))max_; \
//  return _FBTweakInlineWithRangeInternal(category_, collection_, name_, default_, &min__, &max__); \
//})())
//#define _FBTweakInlineWithRangeInternal(category_, collection_, name_, default_, min__, max__) \
//((^{ \
//  /* store the tweak data in the binary at compile time. */ \
//  __attribute__((used)) static FBTweakLiteralString category__ = category_; \
//  __attribute__((used)) static FBTweakLiteralString collection__ = collection_; \
//  __attribute__((used)) static FBTweakLiteralString name__ = name_; \
//  __attribute__((used)) static __typeof__(default_) default__ = default_; \
//  __attribute__((used)) static char *encoding__ = (char *)@encode(__typeof__(default_)); \
//  __attribute__((used)) __attribute__((section (FBTweakSegmentName "," FBTweakSectionName))) static fb_tweak_entry entry = \
//    { &category__, &collection__, &name__, (void *)&default__, (void *)min__, (void *)max__, &encoding__ }; \
//\
//  /* find the registered tweak with the given identifier. */ \
//  FBTweakStore *store = [FBTweakStore sharedInstance]; \
//  FBTweakCategory *category = [store tweakCategoryWithName:category__]; \
//  FBTweakCollection *collection = [category tweakCollectionWithName:collection__]; \
//\
//  NSString *identifier = _FBTweakIdentifier(&entry); \
//  FBTweak *__inline_tweak = [collection tweakWithIdentifier:identifier]; \
//\
//  return __inline_tweak; \
//})())
//#define _FBTweakInline(category_, collection_, name_, ...) _FBTweakHasRange(_FBTweakInlineWithoutRange, _FBTweakInlineWithRange, __VA_ARGS__)(category_, collection_, name_, __VA_ARGS__)
//  
//#define _FBTweakValueInternal(tweak_, category_, collection_, name_, default_) \
//((^{ \
//  /* returns a correctly typed version of the current tweak value */ \
//  FBTweakValue currentValue = tweak_.currentValue ?: tweak_.defaultValue; \
//  return _Generic(default_, \
//    float: [currentValue floatValue], \
//    const float: [currentValue floatValue], \
//    double: [currentValue doubleValue], \
//    const double: [currentValue doubleValue], \
//    short: [currentValue shortValue], \
//    const short: [currentValue shortValue], \
//    unsigned short: [currentValue unsignedShortValue], \
//    const unsigned short: [currentValue unsignedShortValue], \
//    int: [currentValue intValue], \
//    const int: [currentValue intValue], \
//    unsigned int: [currentValue unsignedIntValue], \
//    const unsigned int: [currentValue unsignedIntValue], \
//    long long: [currentValue longLongValue], \
//    const long long: [currentValue longLongValue], \
//    unsigned long long: [currentValue unsignedLongLongValue], \
//    const unsigned long long: [currentValue unsignedLongLongValue], \
//    BOOL: [currentValue boolValue], \
//    const BOOL: [currentValue boolValue], \
//    id: currentValue, \
//    const id: currentValue, \
//    /* assume char * as the default. */ \
//    /* constant strings are typed as char[N] */ \
//    /* and we can't enumerate all of those. */ \
//    /* luckily, we only need one fallback */ \
//    default: [currentValue UTF8String] \
//  ); \
//})())
//
//#define _FBTweakValueWithoutRange(category_, collection_, name_, default_) \
//((^{ \
//    FBTweak *__value_tweak = _FBTweakInlineWithoutRange(category_, collection_, name_, default_); \
//    return _FBTweakValueInternal(__value_tweak, category_, collection_, name_, default_); \
//})())
//#define _FBTweakValueWithRange(category_, collection_, name_, default_, min_, max_) \
//((^{ \
//  FBTweak *__value_tweak = _FBTweakInlineWithRange(category_, collection_, name_, default_, min_, max_); \
//  return _FBTweakValueInternal(__value_tweak, category_, collection_, name_, default_); \
//})())
//#define _FBTweakValue(category_, collection_, name_, ...) _FBTweakHasRange(_FBTweakValueWithoutRange, _FBTweakValueWithRange, __VA_ARGS__)(category_, collection_, name_, __VA_ARGS__)
//
//#define _FBTweakBindWithoutRange(object_, property_, category_, collection_, name_, default_) \
//((^{ \
//  FBTweak *__bind_tweak = _FBTweakInlineWithoutRange(category_, collection_, name_, default_); \
//  _FBTweakBindWithRangeInternal(object_, property_, category_, collection_, name_, default_, __bind_tweak); \
//})())
//#define _FBTweakBindWithRange(object_, property_, category_, collection_, name_, default_, min_, max_) \
//((^{ \
//  FBTweak *__bind_tweak = _FBTweakInlineWithRange(category_, collection_, name_, default_, min_, max_); \
//  _FBTweakBindWithRangeInternal(object_, property_, category_, collection_, name_, default_, __bind_tweak); \
//})())
//#define _FBTweakBindWithRangeInternal(object_, property_, category_, collection_, name_, default_, tweak_) \
//((^{ \
//  object_.property_ = _FBTweakValueInternal(tweak_, category_, collection_, name_, default_); \
//  FBTweakBindObserver *observer__ = [[FBTweakBindObserver alloc] initWithTweak:tweak_ block:^(id object__) { \
//    __typeof__(object_) object___ = object__; \
//    object___.property_ = _FBTweakValueInternal(tweak_, category_, collection_, name_, default_); \
//  }]; \
//  [observer__ attachToObject:object_]; \
//})())
//#define _FBTweakBind(object_, property_, category_, collection_, name_, ...) _FBTweakHasRange(_FBTweakBindWithoutRange, _FBTweakBindWithRange, __VA_ARGS__)(object_, property_, category_, collection_, name_, __VA_ARGS__)
//
//#define _FBTweakAction(category_, collection_, name_, ...) \
//  _FBTweakActionInternal(category_, collection_, name_, __COUNTER__, __VA_ARGS__)
//#define _FBTweakActionInternal(category_, collection_, name_, suffix_, ...) \
//  /* store the tweak data in the binary at compile time. */ \
//  __attribute__((used)) static FBTweakLiteralString __FBTweakConcat(__fb_tweak_action_category_, suffix_) = category_; \
//  __attribute__((used)) static FBTweakLiteralString __FBTweakConcat(__fb_tweak_action_collection_, suffix_) = collection_; \
//  __attribute__((used)) static FBTweakLiteralString __FBTweakConcat(__fb_tweak_action_name_, suffix_) = name_; \
//  __attribute__((used)) static dispatch_block_t __FBTweakConcat(__fb_tweak_action_block_, suffix_) = __VA_ARGS__; \
//  __attribute__((used)) static char *__FBTweakConcat(__fb_tweak_action_encoding_, suffix_) = (char *)FBTweakEncodingAction; \
//  __attribute__((used)) __attribute__((section (FBTweakSegmentName "," FBTweakSectionName))) static fb_tweak_entry __FBTweakConcat(__fb_tweak_action_entry_, suffix_) = { \
//    &__FBTweakConcat(__fb_tweak_action_category_, suffix_), \
//    &__FBTweakConcat(__fb_tweak_action_collection_, suffix_), \
//    &__FBTweakConcat(__fb_tweak_action_name_, suffix_), \
//    &__FBTweakConcat(__fb_tweak_action_block_, suffix_), \
//    NULL, NULL, \
//    &__FBTweakConcat(__fb_tweak_action_encoding_, suffix_), \
//  }; \
//
//#ifdef __cplusplus
//}
//#endif
//
