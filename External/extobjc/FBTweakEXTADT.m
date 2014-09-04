//
//  FBTweakEXTADT.m
//  FBTweakEXTobjc
//
//  Created by Justin Spahr-Summers on 25.06.12.
//  Copyright (C) 2012 Justin Spahr-Summers.
//  Released under the MIT license.
//

#import "FBTweakEXTADT.h"

const char *FBTweakEXT_trimADTJunkFromTypeEncoding (const char *encoding) {
    // we need to skip past two unions in the type string
    const char *nFBTweakEXT;

    for (int i = 0; i < 2; ++i) {
        nFBTweakEXT = strstr(encoding, "(?=");
        if (!nFBTweakEXT)
            break;

        encoding = nFBTweakEXT + 3;
    }

    return encoding;
}

NSString *FBTweakEXT_parameterNameFromDeclaration (NSString *declaration) {
    NSMutableCharacterSet *identifierCharacterSet = [[NSCharacterSet alphanumericCharacterSet] mutableCopy];
    [identifierCharacterSet addCharactersInString:@"$_"];

    // now invert, to get all characters disallowed in identifiers
    [identifierCharacterSet invert];
    
    NSRange lastWhitespace = [declaration rangeOfCharacterFromSet:identifierCharacterSet options:NSBackwardsSearch];
    return [declaration substringFromIndex:lastWhitespace.location + 1];
}
