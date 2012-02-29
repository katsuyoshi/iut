//
//  NonArcWithRetainInMethod.m
//  IUTTest
//
//  Created by Ito Katsuyoshi on 12/02/29.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "NonArcWithAutoreleaseInMethod.h"

@implementation NonArcWithAutoreleaseInMethod

- (void)foo
{
    NSArray *array = [[NSArray new] autorelease];
}

@end
