//
//  NonArcWithReleaseInMethod.m
//  IUTTest
//
//  Created by Ito Katsuyoshi on 12/02/29.
//  Copyright (c) 2012年 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "NonArcWithReleaseInMethod.h"

@implementation NonArcWithReleaseInMethod

- (void)foo
{
    NSArray *array = [NSArray new];
    [array release];
}

@end
