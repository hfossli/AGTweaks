//
//  FBActionTweak.m
//  FBTweak
//
//  Created by Maria Fossli on 02.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "FBActionTweak.h"
#import "FBTweak_SubclassEyesOnly.h"

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
