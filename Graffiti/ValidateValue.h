//
//  ValidateValue.h
//  Graffiti
//
//  Created by Ade on 8/21/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateValue : NSObject

- (BOOL) isLoginNameValid : (NSString *) userName;
- (BOOL) isPasswordValid : (NSString *) password;

@end
