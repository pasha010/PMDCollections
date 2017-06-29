//
//  NSArray(PMDCollections)
//  PMDCollections
// 
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import <objc/runtime.h>
#import "NSArray+PMDCollections.h"

@implementation NSArray (PMDCreation)

+ (nonnull NSArray<NSNumber *> *)arrayFromIndex:(NSUInteger)startIndex toIndex:(NSUInteger)endIndex {
    return [NSArray arrayFromRange:NSMakeRange(startIndex, startIndex + endIndex)];
}

+ (nonnull NSArray<NSNumber *> *)arrayFromRange:(NSRange)range {
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
    NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:range.length];
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [array addObject:@(idx)];
    }];
    return [array copy];
}

+ (nonnull NSArray<NSNumber *> *)arrayFromRange_noSet:(NSRange)range {
    NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:range.length];
    for (NSUInteger i = range.location; i < range.length; i++) {
        [array addObject:@(i)];
    }
    return [array copy];
}

@end

