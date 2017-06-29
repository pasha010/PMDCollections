//
//  NSArray+PMDCreation
//  PMDCollections
//
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (PMDCreationFromRange)

/**
 * create NSArray from NSNumbers with values from startIndex to endIndex
 * @param startIndex less than endIndex
 * @param endIndex greater than startIndex
 * @return array from nsnumbers
 */
+ (nullable NSArray<NSNumber *> *)arrayFromIndex:(NSInteger)startIndex toIndex:(NSInteger)endIndex;

@end

NS_ASSUME_NONNULL_END