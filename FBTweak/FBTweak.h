/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, FBTweakChangeReason) {
    FBTweakChangeReasonUnknown,
    FBTweakChangeReasonEdit,
    FBTweakChangeReasonReset,
};

@protocol FBTweakObserver;

/**
  @abstract Represents a unique, named tweak.
  @discussion A tweak contains a persistent, editable value.
 */
@interface FBTweak : NSObject <NSCoding>

/**
  @abstract Creates a new tweak model.
  @discussion This is the designated initializer.
 */
- (instancetype)initWithIdentifier:(NSString *)identifier;

/**
  @abstract This tweak's unique identifier.
  @discussion Used when reading and writing the tweak's value.
 */
@property (nonatomic, copy, readonly) NSString *identifier;

/**
  @abstract The human-readable name of the tweak.
  @discussion Show the name when displaying the tweak.
 */
@property (nonatomic, copy, readwrite) NSString *name; 

/**
  @abstract Adds an observer to the tweak.
  @param object The observer. Must not be nil.
  @discussion A weak reference is taken on the observer.
 */
- (void)addObserver:(id<FBTweakObserver>)observer;

/**
  @abstract Removes an observer from the tweak.
  @param observer The observer to remove. Must not be nil.
  @discussion Optional, removing an observer isn't required.
 */
- (void)removeObserver:(id<FBTweakObserver>)observer;

/**
 @abstract Loads any stored value
 */
- (void)load;

/**
 @abstract Removes any stored values
 @discussion Used to clear any saved values
 */
- (void)reset;

@end

/**
  @abstract Responds to updates when a tweak changes.
 */
@protocol FBTweakObserver <NSObject>

/**
  @abstract Called when a tweak's value changes.
  @param tweak The tweak which changed in value.
 */
- (void)tweakDidChange:(FBTweak *)tweak;

@end
