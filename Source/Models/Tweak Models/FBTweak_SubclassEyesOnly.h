/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBTweak.h"

@interface FBTweak (SubclassEyesOnly)

/// Subclasses should call super whenever anything changes
- (void)tweakChanged:(FBTweakChangeReason)reason;

/// Subclasses should override to save whenever super decides is a good time
- (void)save;

/// Subclasses should override to load whenever super decides is a good time
- (void)load;

@end
