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

@implementation NSArray (PMDFunctions)

- (nullable NSArray<id> *)map:(id _Nullable (^ _Nullable)(id _Nonnull element))iterate {
    if (!iterate) {
        return nil;
    }
    NSMutableArray<id> *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id newElement = nil;
        @try {
            newElement = iterate(obj);
        }
        @catch (id error) {
            return;
        }
        if (newElement) {
            [array addObject:newElement];
        }
    }];
    return [array copy];
}

- (nullable NSArray<id> *)mapBySelector:(nullable SEL)sel {
    if (!sel) {
        return nil;
    }

    NSMutableArray<id> *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj respondsToSelector:sel]) {
            return;
        }
        IMP imp = [obj methodForSelector:sel];
        if (!imp) {
            return;
        }
        id (*func)(id, SEL) = (id (*)(id, SEL)) imp;
        id result = func(obj, sel);
        if (result) {
            [array addObject:result];
        }
    }];
    return [array copy];
}

- (nullable NSArray<id> *)mapByTarget:(nullable id)target withSelector:(nullable SEL)sel {
    if (!target || !sel) {
        return nil;
    }

    if (![target respondsToSelector:sel]) {
        return nil;
    }
    IMP imp = nil;
    imp = [target methodForSelector:sel];
    if (!imp) {
        return nil;
    }
    id (*func)(id, SEL, id) = (id (*)(id, SEL, id)) imp;

    NSMutableArray<id> *array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id result = nil;
        @try {
            result = func(target, sel, obj);
        }
        @catch (id error) {
            return;
        }
        if (result) {
            [array addObject:result];
        }
    }];
    return [array copy];
}

- (nonnull NSArray<id> *)filter:(BOOL(^ _Nullable)(id _Nonnull element))predicate {
    if (!predicate) {
        return self;
    }
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary<NSString *, id> *bindings) {
        BOOL hasPassed;
        @try {
            hasPassed = predicate(obj);
        }
        @catch (id error) {
            hasPassed = NO;
        }
        return hasPassed;
    }]];
}

- (nonnull NSArray<id> *)filterByTarget:(nullable id)target withSelector:(nullable SEL)sel {
    if (!target || !sel) {
        return self;
    }

    if (![target respondsToSelector:sel]) {
        return self;
    }
    IMP imp = nil;
    imp = [target methodForSelector:sel];
    if (!imp) {
        return self;
    }

    BOOL (*func)(id, SEL, id) = (BOOL (*)(id, SEL, id)) imp;

    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary<NSString *, id> *bindings) {
        BOOL hasPassed;
        @try {
            hasPassed = func(target, sel, obj);
        }
        @catch (id error) {
            hasPassed = NO;
        }
        return hasPassed;
    }]];
}

- (nullable id)find:(BOOL(^ _Nullable)(id _Nonnull element))predicate {
    if (!predicate) {
        return nil;
    }
    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL res;
        @try {
            res = predicate(obj);
        }
        @catch (id error) {
            res = NO;
        }
        return res;
    }];

    if (index == NSNotFound) {
        return nil;
    }
    return self[index];
}

- (nullable id)findByTarget:(nullable id)target withSelector:(nullable SEL)sel {
    if (!target || !sel) {
        return nil;
    }
    if (![target respondsToSelector:sel]) {
        return nil;
    }
    IMP imp = nil;
    imp = [target methodForSelector:sel];
    if (!imp) {
        return nil;
    }

    BOOL (*func)(id, SEL, id) = (BOOL (*)(id, SEL, id)) imp;

    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL res;
        @try {
            res = func(target, sel, obj);
        }
        @catch (id error) {
            res = NO;
        }
        return res;
    }];

    if (index == NSNotFound) {
        return nil;
    }
    return self[index];
}

- (nonnull NSArray<id> *)shuffle {
    if (self.count < 2) {
        return [self copy];
    }
    NSMutableArray<id> *array = [NSMutableArray arrayWithArray:self];
    NSUInteger count = self.count;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger remainingCount = count - idx;
        NSUInteger exchangeIndex = idx + arc4random_uniform((u_int32_t) remainingCount);
        [array exchangeObjectAtIndex:idx withObjectAtIndex:exchangeIndex];
    }];
    return [array copy];
}


@end