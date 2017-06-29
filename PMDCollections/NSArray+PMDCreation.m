//
//  NSArray+PMDCreation
//  PMDCollections
//
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import "NSArray+PMDCreation.h"

//  неплохо бы создать имплементацию без добавлению кучи элементов в массив

@implementation NSArray (PMDCreationFromRange)

+ (nullable NSArray<NSNumber *> *)arrayFromIndex:(NSInteger)startIndex toIndex:(NSInteger)endIndex {
    if (startIndex >= endIndex) {
        return nil;
    }

    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    for (NSInteger i = startIndex; i < (endIndex + 1); i++) {
        [array addObject:@(i)];
    }
    return array;
}

@end
