/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>
#import "FBTweakEnabled.h"

#if !FB_TWEAK_ENABLED

#else

#ifdef __cplusplus
extern "C" {
#endif

#define FBTweakSegmentName "__DATA"
#define FBTweakSectionName "FBTweak"

#define FBTweakEncodingAction "__ACTION__"

    typedef __unsafe_unretained NSString *FBTweakLiteralString;

    typedef __unsafe_unretained void (^fb_tweak_entry_init_block)(id tweak);

    typedef struct {
        FBTweakLiteralString *category;
        FBTweakLiteralString *collection;
        FBTweakLiteralString *name;
        FBTweakLiteralString *className;
        char **encoding;
        fb_tweak_entry_init_block *initBlock;
    } fb_tweak_entry;

    extern NSString *_FBTweakIdentifier(fb_tweak_entry *entry);
    
#ifdef __cplusplus
}
#endif

#endif


