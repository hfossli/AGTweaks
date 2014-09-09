/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <FBTweak/FBActionTweak.h>
#import <FBTweak/FBTweak_SubclassEyesOnly.h>

@implementation FBActionTweak

- (void)triggerAction
{
    if(self.action)
    {
        self.action();
    }
}

- (void)load
{
    // no values to load
}

- (void)save
{
    // no values to save
}

- (void)reset
{
    // no values to reset
}

@end
