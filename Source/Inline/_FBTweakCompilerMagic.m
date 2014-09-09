/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Tweaks/_FBTweakCompilerMagic.h>
#import <Tweaks/FBAllTweaks.h>
#import <Tweaks/FBTweakCollection.h>
#import <Tweaks/FBTweakStore.h>
#import <Tweaks/FBTweakCategory.h>

#import <libkern/OSAtomic.h>
#import <mach-o/getsect.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>

#if FB_TWEAK_ENABLED

extern NSString *_FBTweakIdentifier(NSString *category, NSString *collection, NSString *name)
{
    return [NSString stringWithFormat:@"FBTweak:%@-%@-%@", category, collection, name];
}

extern NSString *_FBTweakIdentifierFromEntry(fb_tweak_entry *entry)
{
    return _FBTweakIdentifier(*entry->category, *entry->collection, *entry->name);
}

@interface _FBTweakInlineLoader : NSObject
@end

@implementation _FBTweakInlineLoader

+ (void)load
{
    static uint32_t _tweaksLoaded = 0;
    if (OSAtomicTestAndSetBarrier(1, &_tweaksLoaded)) {
        return;
    }
    
#ifdef __LP64__
    typedef uint64_t fb_tweak_value;
    typedef struct section_64 fb_tweak_section;
#define fb_tweak_getsectbynamefromheader getsectbynamefromheader_64
#else
    typedef uint32_t fb_tweak_value;
    typedef struct section fb_tweak_section;
#define fb_tweak_getsectbynamefromheader getsectbynamefromheader
#endif
    
    FBTweakStore *store = [FBTweakStore sharedInstance];
    
    Dl_info info;
    dladdr(&_FBTweakIdentifier, &info);
    
    const fb_tweak_value mach_header = (fb_tweak_value)info.dli_fbase;
    const fb_tweak_section *section = fb_tweak_getsectbynamefromheader((void *)mach_header, FBTweakSegmentName, FBTweakSectionName);
    
    if (section == NULL) {
        return;
    }
    
    for (fb_tweak_value addr = section->offset; addr < section->offset + section->size; addr += sizeof(fb_tweak_entry)) {
        fb_tweak_entry *entry = (fb_tweak_entry *)(mach_header + addr);
        
        FBTweakCategory *category = [store tweakCategoryWithName:*entry->category];
        if (category == nil) {
            category = [[FBTweakCategory alloc] initWithName:*entry->category];
            [store addTweakCategory:category];
        }
        
        FBTweakCollection *collection = [category tweakCollectionWithName:*entry->collection];
        if (collection == nil) {
            collection = [[FBTweakCollection alloc] initWithName:*entry->collection];
            [category addTweakCollection:collection];
        }
        
        NSString *identifier = _FBTweakIdentifierFromEntry(entry);
        if ([collection tweakWithIdentifier:identifier] == nil) {

            fb_tweak_entry_init_block initBlock = *entry->initBlock;
            NSString *className = *entry->className;
            Class tweakClass = NSClassFromString(className);
            NSAssert(tweakClass != nil, @"Class is not in use by project. Runtime is clever and won't load if not necessary.");

            FBTweak *tweak = [[tweakClass alloc] initWithIdentifier:identifier];
            tweak.name = *entry->name;
            initBlock(tweak);
            [tweak load];
            
            if (tweak != nil) {
                [collection addTweak:tweak];
            }
        }
    }
}

@end

#endif
