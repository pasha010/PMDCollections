//
//  NSArray(PMDCollections)
//  PMDCollections
// 
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (PMDCreation)

//+ (nonnull instancetype)arrayWithWeakReferences;


+ (nonnull NSArray<NSNumber *> *)arrayFromIndex:(NSUInteger)startIndex toIndex:(NSUInteger)endIndex;

+ (nonnull NSArray<NSNumber *> *)arrayFromRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END