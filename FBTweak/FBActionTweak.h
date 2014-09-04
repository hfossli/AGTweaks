//
//  FBActionTweak.h
//  FBTweak
//
//  Created by Maria Fossli on 02.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <FBTweak/FBTweak.h>

@interface FBActionTweak : FBTweak

@property (nonatomic, copy) dispatch_block_t action;

- (void)triggerAction;

@end
