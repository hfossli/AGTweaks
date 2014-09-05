/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

@class FBTweak;

/**
  @abstract Block to call when an update is observed.
  @param object The object that the observer is attached to.
 */
typedef void (^FBTweakBindObserverBlock)(id object);

/**
  @abstract Observes a tweak to issue bind updates.
  @discussion This is an implementation detail of {@ref FBTweakBind}.
 */
@interface FBTweakBindObserver : NSObject

/**
  @abstract Designated initializer.
  @param tweak The tweak to observe.
  @param block The block to call on change.
  @return A new bind observer.
*/
- (instancetype)initWithTweak:(FBTweak *)tweak block:(FBTweakBindObserverBlock)block;

/**
  @abstract Attaches to an object and deallocates with it.
  @discussion Useful to create a limited lifetime for the observer.
 */
- (void)attachToObject:(id)object;

@end
